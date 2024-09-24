import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension ToastExtension on BuildContext {
  showSuccessToast(String message, {int? seconds}) {
    FToast fToast = FToast();
    fToast.init(this);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38),
        color: Colors.black.withOpacity(0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.done, color: Colors.green),
          10.horizontalSpace,
          Flexible(
            child: BuildText(
              text: message,
              style: 12.text600,
              color: whiteColor,
              maxLines: 5,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: seconds ?? 3),
    );
  }

  showErrorToast(String message, {int? seconds}) {
    FToast fToast = FToast();
    fToast.init(this);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38),
        color: Colors.black.withOpacity(0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.close, color: Colors.red),
          10.horizontalSpace,
          Flexible(
            child: BuildText(
              text: message,
              style: 12.text600,
              color: whiteColor,
              maxLines: 5,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: seconds ?? 3),
    );
  }

  showToast(String message, {int? seconds}) {
    FToast fToast = FToast();
    fToast.init(this);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(38),
        color: Colors.black.withOpacity(0.8),
      ),
      child: BuildText(
        text: message,
        style: 12.text600,
        color: whiteColor,
        textAlign: TextAlign.center,
        maxLines: 5,
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: seconds ?? 3),
    );
  }
}
