import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/notification_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = 'forget-password-screen';
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with TickerProviderStateMixin {
  late final TextEditingController _emailController;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.repeat();
  }

  @override
  void dispose() {
    _emailController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateResetPaswordSuccess) {
          showRegisterSuccess(
            context,
            'Mật khẩu đã được làm mới',
            'Mật khẩu mới đã được gửi vào email của bạn. Trang chủ sẽ được quay lại sau vài giây',
          );
          Future.delayed(
            const Duration(seconds: 3),
            () {
              context.pop();
              context.pop();
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: rose300,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: kBackButton(context, color: whiteColor),
          title: BuildText(
            text: 'Quên mật khẩu',
            style: 18.text600,
            color: whiteColor,
          ),
        ),
        body: Container(
          height: context.height,
          width: context.width,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                rose300,
                rose600,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(24.r)),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BuildText(
                          text: 'Quên mật khẩu?',
                          style: 24.text700,
                          color: Palette.title,
                        ),
                        10.verticalSpace,
                        BuildText(
                          text:
                              'Đừng lo lắng, hãy nhập lại địa chỉ email và OvumB sẽ gửi mật khẩu mới ngay cho bạn',
                          style: 16.text500,
                          color: grey700,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Column(
                      children: [
                        BuildText(
                          text: 'Nhập email của bạn',
                          style: 14.text400,
                          color: grey700,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: TextField(
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.left,
                            style: 16.text600.copyWith(color: rose400),
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.transparent,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Palette.title),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Palette.title),
                              ),
                            ),
                            cursorColor: rose400,
                          ),
                        ),
                      ],
                    ),
                    40.verticalSpace,
                    KSubmitButton(
                      size: Size(context.width, 50.h),
                      text: 'Lấy lại mật khẩu',
                      onTap: () => context.read<AuthBloc>().add(
                            AuthResetPasswordEvent(context,
                                email: _emailController.text),
                          ),
                    ),
                  ],
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
