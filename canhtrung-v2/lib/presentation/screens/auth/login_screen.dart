// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/forget_password_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/register_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/form/password_input_field.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/form/text_input_field.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'login-screen';
  LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;

  bool isClick = false;

  @override
  void initState() {
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccessState) {
          _phoneController.text = state.phone;
          _passwordController.text = state.password;
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 250.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 100.w),
                      child: Image.asset(
                        ImageApp.logoAppbar,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      TextInputField(
                        name: 'Số điện thoại',
                        iconUrl: IconApp.phone,
                        controller: _phoneController,
                        textInputType: TextInputType.number,
                        formatter: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      20.verticalSpace,
                      PasswordInputField(
                        name: 'Mật khẩu',
                        iconUrl: IconApp.password,
                        controller: _passwordController,
                        isClick: isClick,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => context
                                  .pushNamed(ForgetPasswordScreen.routeName),
                              child: BuildText(
                                text: 'Quên mật khẩu?',
                                style: 12.text500,
                                color: grey400,
                                textDecoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  60.verticalSpace,
                  //button
                  KSubmitButton(
                    size: Size(context.width, 50.h),
                    text: 'Đăng nhập',
                    onTap: () => context.read<AuthBloc>().add(AuthLoginEvent(
                        context,
                        _phoneController.text,
                        _passwordController.text)),
                  ),
                  20.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BuildText(
                        text: 'Bạn chưa có tài khoản?',
                        style: 15.text500,
                        color: grey400,
                      ),
                      6.horizontalSpace,
                      InkWell(
                        onTap: () =>
                            context.pushNamed(RegisterScreen.routeName),
                        child: BuildText(
                          text: 'Đăng ký ngay',
                          style: 15.text500,
                          color: Palette.title,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
