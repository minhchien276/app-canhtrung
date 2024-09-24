import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/handle/datetime_handle.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/logic/upgrade/upgrade_api.dart';
import 'package:flutter_ovumb_app_version1/logic/upgrade/upgrade_version.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/upgrade/upgrade_dialog.dart';

class UpgraderLogic {
  final _upgradeApi = UpgradeApi();
  final _dateTimeHandle = DateTimeHandle();
  final _prefs = SharedPreferencesService();

  Future<void> checkVersion({
    required BuildContext context,
    required int dayNextRequest,
  }) async {
    int now = _dateTimeHandle.dateStartFormat(DateTime.now());
    int next = _dateTimeHandle
        .dateStartFormat(DateTime.now().add(Duration(days: dayNextRequest)));
    //kiểm tra xem ngày hôm nay đã call api chưa
    int? localAPItime = await _prefs.version;
    if (localAPItime != null) {
      if (localAPItime < now) {
        int? lastest = await _upgradeApi.getLastestVersion();
        if (lastest != null) {
          if (OVUMB_CURRENT_VERSION < lastest) {
            _prefs.setCallVersion(next);
            upgradeVersionAppDialog(context, checkPlatform());
          }
          _prefs.setCallVersion(now);
        }
      }
    } else {
      int? lastest = await _upgradeApi.getLastestVersion();
      if (lastest != null) {
        if (OVUMB_CURRENT_VERSION < lastest) {
          _prefs.setCallVersion(next);
          upgradeVersionAppDialog(context, checkPlatform());
        }
        _prefs.setCallVersion(now);
      }
    }
  }

  String checkPlatform() {
    if (Platform.isIOS) {
      return OVUMB_IOS_LINK;
    } else if (Platform.isAndroid) {
      return OVUMB_ANDROID_LINK;
    }
    return OVUMB_LINK;
  }
}
