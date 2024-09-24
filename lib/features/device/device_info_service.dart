import 'dart:io';

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
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return false; // Assume non-physical device for desktop platforms
  } else if (Platform.isFuchsia) {
    return false; // Assume non-physical device for Fuchsia platform
  } else {
    return false; // Default case (including web)
  }
}
}
