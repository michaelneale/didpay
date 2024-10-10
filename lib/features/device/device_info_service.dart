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
    } else if (Platform.isAndroid) {
      return (await _deviceInfo.androidInfo).isPhysicalDevice;
    } else if (kIsWeb) {
      return false; // Since the web platform does not support physical devices.
    }
    return false; // Defaulting to false for any unsupported platform
  }
}
