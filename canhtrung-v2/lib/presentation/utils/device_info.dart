import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  static Future<String> name() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String name = '';
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      name = androidInfo.model.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      name = iosInfo.utsname.machine;
    }
    return name;
  }
}
