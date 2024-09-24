import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/login_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = 'welcome-screen';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          height: context.height,
          width: context.width,
          decoration: BoxDecoration(
            gradient: Palette.background,
            image: DecorationImage(
              alignment: Alignment.topLeft,
              fit: BoxFit.scaleDown,
              image: const AssetImage(Imgs.welcomeBg),
              opacity: 0.35,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100.w),
                  child: Image.asset(Imgs.ovumbText),
                ),
              ),
              BuildText(
                text: 'Chào mừng bạn\nđến với OvumB',
                style: 30.text700,
                color: whiteColor,
                textAlign: TextAlign.center,
                height: 1.2,
              ),
              22.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.h),
                child: BuildText(
                  text:
                      'Ứng dụng hỗ trợ chăm sóc sức khỏe sinh sản dành cho nữ giới hàng đầu Việt Nam',
                  style: 16.text400,
                  color: whiteColor,
                  textAlign: TextAlign.center,
                  height: 1.2,
                ),
              ),
              80.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: KSubmitButton(
                  size: Size(context.width, 50.h),
                  text: 'Bắt đầu',
                  onTap: () => Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName),
                  bgColor: whiteColor,
                  textColor: rose500,
                ),
              ),
              100.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
