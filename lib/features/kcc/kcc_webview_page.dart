import 'dart:async';

import 'package:didpay/features/did/did_provider.dart';
import 'package:didpay/features/kcc/kcc_issuance_service.dart';
import 'package:didpay/features/kcc/kcc_retrieval_page.dart';
import 'package:didpay/features/kcc/lib/idv_request.dart';
import 'package:didpay/features/pfis/pfi.dart';
import 'package:didpay/l10n/app_localizations.dart';
import 'package:didpay/shared/async/async_error_widget.dart';
import 'package:didpay/shared/async/async_loading_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class KccWebviewPage extends HookConsumerWidget {
  final Pfi pfi;

  const KccWebviewPage({
    required this.pfi,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bearerDid = ref.watch(didProvider);
    final kccIssuanceService = ref.watch(kccIssuanceProvider);
    final idvRequest = useState<AsyncValue<IdvRequest>>(const AsyncLoading());

    final settings = InAppWebViewSettings(
      isInspectable:
          kDebugMode, // TODO(mistermoe): only enable for debug builds
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: 'camera; microphone',
      iframeAllowFullscreen: true,
    );

    useEffect(
      () {
        Future.microtask(() async {
          try {
            final value =
                await kccIssuanceService.getIdvRequest(pfi, bearerDid);
            idvRequest.value = AsyncData(value);
          } on Exception catch (e, stackTrace) {
            idvRequest.value = AsyncError(e, stackTrace);
          }
        });

        return;
      },
      [],
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: idvRequest.value.when(
        loading: () => AsyncLoadingWidget(text: Loc.of(context).startingIdv),
        error: (error, stackTrace) => AsyncErrorWidget(
          text: error.toString(),
          onRetry: () => Navigator.of(context).pop(),
        ),
        data: (data) {
          return InAppWebView(
            initialSettings: settings,
            onWebViewCreated: (c) {
              // TODO(mistermoe): this url needs to be fixed on our PFI side
              final fullPath = Uri.parse(data.url)
                  .replace(port: 5173, scheme: 'https')
                  .toString();

              c.loadUrl(urlRequest: URLRequest(url: WebUri(fullPath)));
            },
            onCloseWindow: (controller) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => KccRetrievalPage(
                    pfi: pfi,
                    idvRequest: data,
                  ),
                ),
              );
            },
            onReceivedServerTrustAuthRequest: (controller, challenge) async {
              return ServerTrustAuthResponse(
                action: ServerTrustAuthResponseAction.PROCEED,
              );
            },
            onPermissionRequest: (controller, permissionRequest) async {
              return PermissionResponse(
                action: PermissionResponseAction.GRANT,
              );
            },
          );
        },
      ),
    );
  }
}
