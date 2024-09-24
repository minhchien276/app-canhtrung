import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showRegisterSuccess(
  BuildContext context,
  String title,
  String subTitle,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 14.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/success.png'),
            BuildText(
              text: title,
              style: 20.text600,
              color: greyText,
              textAlign: TextAlign.center,
            ),
            14.verticalSpace,
            BuildText(
              text: subTitle,
              style: 14.text400,
              color: greyText,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    },
  );
}
