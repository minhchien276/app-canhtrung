import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showDeleteAccountModal(
  BuildContext context, {
  required VoidCallback onSubmit,
}) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(26),
      ),
    ),
    isScrollControlled: true,
    barrierColor: grey900.withOpacity(0.4),
    context: context,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          decoration: const BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 60.h,
              horizontal: 20.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BuildText(
                  text: 'Xoá tài khoản',
                  style: 18.text700,
                  color: rose500,
                ),
                20.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 70.w),
                  child: BuildText(
                    text: 'Bạn có chắc chắn xoá tài khoản này không?',
                    style: 14.text500,
                    color: grey700,
                    textAlign: TextAlign.center,
                  ),
                ),
                40.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: KSubmitButton(
                        size: Size(context.width, 50.h),
                        text: 'Quay lại',
                        bgColor: rose25,
                        textColor: rose400,
                        onTap: () => context.pop(),
                      ),
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: KSubmitButton(
                        size: Size(context.width, 50.h),
                        text: 'Xác nhận',
                        bgColor: rose500,
                        textColor: whiteColor,
                        onTap: onSubmit,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
