import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/services/permission/permisson_exception.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<void> cameraRequest(BuildContext context) async {
    //camera permisson
    PermissionStatus cameraStatus = await Permission.camera.status;

    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
    }

    if (!cameraStatus.isGranted) {
      throw CameraDeniedException();
    }
  }

  static Future<bool> photoRequest() async {
    if (Platform.isIOS) {
      PermissionStatus status1 = await Permission.photos.status;

      if (status1.isGranted) {
        return true;
      }
      if (!status1.isGranted) {
        status1 = await Permission.photos.request();
      }

      if (!status1.isGranted) {
        throw PhotosDeniedException();
      }

      return status1.isGranted;
    }
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted ||
          await Permission.photos.request().isGranted &&
              await Permission.videos.request().isGranted) {
        return true;
      }
    }
    return false;
  }
}
