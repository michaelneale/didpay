import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final deviceInfoServiceProvider = Provider((ref) => DeviceInfoService());

class DeviceInfoService {
  final _deviceInfo = DeviceInfoPlugin();

  Future<bool> isPhysicalDevice() async {
    if (Platform.isIOS) {
      return (await _deviceInfo.iosInfo).isPhysicalDevice;
    }
    if (Platform.isAndroid) {
      return (await _deviceInfo.androidInfo).isPhysicalDevice;
    }
    if (Platform.isLinux || Platform.isMacOS || Platform.isWindows || Platform.isFuchsia || kIsWeb) {
      return false; // Ensures no error for unsupported platforms and no QR code scanning on web
    }
    // Default case
    return false;
  }
}
