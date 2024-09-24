import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showAvatarDialog(BuildContext context, {String? image}) {
  return showDialog<void>(
    barrierColor: Colors.black45,
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: whiteColor,
        surfaceTintColor: whiteColor,
        elevation: 0,
        contentPadding: EdgeInsets.zero,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
        content: networkImageWithCached(
          size: Size(300.h, 300.h),
          url: image,
          borderRadius: 1000,
          boxBorder: Border.all(color: rose400, width: 2),
        ),
      );
    },
  );
}
