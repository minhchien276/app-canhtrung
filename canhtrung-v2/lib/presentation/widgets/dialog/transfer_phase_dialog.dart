import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool?> transferPhaseDialog(
  BuildContext context,
  String text,
) async {
  return showDialog<bool?>(
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
                      text: 'Lưu ý',
                      style: 18.text600,
                      color: rose500,
                    ),
                    6.verticalSpace,
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Bạn sẽ chuyển sang tính năng\n',
                        style: 14.text400.copyWith(color: grey700),
                        children: [
                          TextSpan(
                              text: text,
                              style: 14.text600.copyWith(color: grey700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 0, color: grey300),
              SizedBox(
                height: 46.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(false),
                        child: Ink(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BuildText(
                                text: 'Không',
                                style: 16.text400,
                                color: Colors.red,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(color: grey300, width: 0),
                    Expanded(
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(true),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BuildText(
                                text: 'Tiếp tục',
                                style: 16.text500,
                                color: Color(0xff6792FF),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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
