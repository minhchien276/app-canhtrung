import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestNotificationPermission(BuildContext context) async {
  var status = await Permission.notification.request();
  if (!status.isGranted) {
    return showDialog<void>(
      barrierColor: Colors.black45,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.transparent),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff101828).withAlpha(30),
                  spreadRadius: 0,
                  blurRadius: 24,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20.h),
                  child: Column(
                    children: [
                      BuildText(
                        text: 'Bật thông báo',
                        style: 18.text600,
                        textAlign: TextAlign.center,
                        color: Colors.black,
                      ),
                      4.verticalSpace,
                      BuildText(
                        text:
                            'Bạn chưa bật thông báo, hãy bật thông báo để nhận lời nhắc từ OvumB nhé!',
                        style: 12.text400,
                        textAlign: TextAlign.center,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                Divider(height: 0, color: grey300),
                SizedBox(
                  height: 50.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => context.pop(),
                          child: BuildText(
                            text: 'Hủy',
                            style: 16.text500,
                            color: Colors.red,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: grey300,
                        width: 0,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            AppSettings.openAppSettings(
                                type: AppSettingsType.notification);
                            context.pop();
                          },
                          child: BuildText(
                            text: 'Cài đặt',
                            style: 16.text500,
                            color: Color(0xff6792FF),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
