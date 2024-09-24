// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kloader_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

// màn hình chọn que test
class HomePhase3DisconnectScreen extends StatelessWidget {
  static const routeName = 'home3-disconnect-screen';
  final VoidCallback onTap;
  const HomePhase3DisconnectScreen({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        children: [
          40.verticalSpace,
          Container(
            height: 450,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: grey100,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: Offset(0, 2),
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset('assets/images/connect_error.png'),
                const SizedBox(height: 10),
                TitleText(
                  text: 'Không Có Kết Nối Internet',
                  fontWeight: FontWeight.w600,
                  size: 20,
                  color: rose500,
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(
                        text: 'Hãy thử các bước sau để kết nối lại:',
                        fontWeight: FontWeight.w400,
                        size: 14,
                        color: greyText,
                      ),
                      const SizedBox(height: 4),
                      TitleText(
                        text: '\u2022 Kiểm tra modem và bộ định tuyến',
                        fontWeight: FontWeight.w400,
                        size: 14,
                        color: greyText,
                      ),
                      const SizedBox(height: 4),
                      TitleText(
                        text: '\u2022 Kết nối lại Wifi',
                        fontWeight: FontWeight.w400,
                        size: 14,
                        color: greyText,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          50.verticalSpace,
          KLoaderButton(
            size: Size(size.width, 50),
            text: 'Thử lại',
            onTap: onTap,
          )
        ],
      ),
    );
  }
}
