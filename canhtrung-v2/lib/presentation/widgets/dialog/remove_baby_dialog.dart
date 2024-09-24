import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';

Future<bool?> removeBabyDialog(
  BuildContext context,
  String text,
) async {
  return showDialog<bool?>(
    barrierColor: Colors.black45,
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Lưu ý',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          color: rose500,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Tất cả thông tin của bé ',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: grey700,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: text,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: grey700,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' sẽ bị xóa hoàn toàn, bạn có chắc chắn muốn xóa không?',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: grey700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  color: grey300,
                ),
                SizedBox(
                  height: 50,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(false),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Hủy',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        VerticalDivider(
                          color: grey300,
                          width: 0,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(true),
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Xác nhận',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      color: Color(0xff6792FF),
                                      fontWeight: FontWeight.w600,
                                    ),
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
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
