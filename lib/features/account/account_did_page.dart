import 'dart:math';

import 'package:didpay/features/did/did_provider.dart';
import 'package:didpay/features/did/did_qr.dart';
import 'package:didpay/l10n/app_localizations.dart';
import 'package:didpay/shared/theme/grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountDidPage extends HookConsumerWidget {
  const AccountDidPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final did = ref.watch(didProvider);

    const maxSize = 250.0;
    final screenSize = MediaQuery.of(context).size;
    final qrSize = min(screenSize.width * 0.7, maxSize);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: Grid.xxl),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(Grid.radius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Grid.sm),
              child: DidQr.buildQrCode(context, did.uri, qrSize),
            ),
          ),
          _buildDid(context, did.uri),
        ],
      ),
    );
  }

  Widget _buildDid(BuildContext context, String did) => Padding(
        padding: const EdgeInsets.only(top: Grid.xxl),
        child: ListTile(
          title: Text(did),
          trailing: const Icon(Icons.content_copy),
          onTap: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();

            Clipboard.setData(ClipboardData(text: did));
            final snackBar = SnackBar(
              content: Text(
                Loc.of(context).copiedDid,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      );
}
