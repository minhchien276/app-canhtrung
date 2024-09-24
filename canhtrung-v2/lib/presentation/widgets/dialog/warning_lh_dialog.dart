import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';

Future<void> warningLHDialog(
  BuildContext context,
) async {
  return showDialog<void>(
    barrierColor: Colors.black45,
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 240,
            width: 200,
            //margin: EdgeInsets.symmetric(horizontal: 20),
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
              children: [
                Container(
                  padding:
                      EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        'Cảnh báo',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'OvumB thấy rằng có thể bạn đang gặp phải một số vấn đề về sức khỏe do độ dài chu kỳ kinh nguyệt đã vượt quá mức 45 ngày. Bạn nên liên hệ với chuyên gia của mình để được tư vấn kịp thời.',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 0,
                  color: grey300,
                ),
                Expanded(
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Đồng ý',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: Color(0xff6792FF),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
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

Future<void> warningMenstrualDialog(
  BuildContext context,
  int tbnkn,
) async {
  return showDialog<void>(
    barrierColor: Colors.black45,
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 420,
            padding: EdgeInsets.all(50),
            //margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
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
              children: [
                Image.asset(
                  'assets/images/menstrual_problems.png',
                  scale: 3,
                ),
                const SizedBox(height: 30),
                Text(
                  'Dấu hiệu của một\nChu kỳ bất thường',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    color: rose500,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: 'Chu kỳ hiện tại của bạn đang là một',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: grey700,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: ' Chu kỳ dài ($tbnkn ngày). ',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: grey700,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Vui lòng liên hệ chuyên gia sinh sản OvumB để hỗ trợ theo dõi sức khỏe của bạn kịp thời',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: grey700,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
