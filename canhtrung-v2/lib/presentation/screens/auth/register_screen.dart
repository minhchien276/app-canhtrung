import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/constant/link.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/notification_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/form/password_input_field.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/form/picker_input_field.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/form/text_input_field.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/webview.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = 'register-screen';
  const RegisterScreen({
    super.key,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _dobController;
  late final TextEditingController _pwdController;
  late final TextEditingController _repwdController;
  bool isVerify = false;
  bool isClick = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _dobController = TextEditingController();
    _pwdController = TextEditingController();
    _repwdController = TextEditingController();
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _pwdController.dispose();
    _repwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccessState) {
          showRegisterSuccess(
            context,
            'Đăng ký thành công',
            'Tài khoản của bạn đã sẵn sàng được sử dụng. Trang chủ sẽ được quay lại sau vài giây',
          );
          Future.delayed(
            const Duration(seconds: 2),
            () {
              context.pop();
              context.pop();
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: whiteColor,
          shadowColor: whiteColor,
          centerTitle: true,
          title: BuildText(
            text: 'Đăng ký',
            style: 20.text600,
            color: grey700,
          ),
          leading: kBackButton(context),
        ),
        body: Container(
          height: context.height,
          width: context.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                30.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100.w),
                  child: Image.asset(Imgs.ovumbText, color: rose400),
                ),
                30.verticalSpace,
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextInputField(
                      name: 'Họ và tên',
                      iconUrl: IconApp.userUnactive,
                      controller: _nameController,
                    ),
                    20.verticalSpace,
                    TextInputField(
                      name: 'Số điện thoại',
                      iconUrl: IconApp.phone,
                      controller: _phoneController,
                      textInputType: TextInputType.number,
                      formatter: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    20.verticalSpace,
                    TextInputField(
                      name: 'Email',
                      iconUrl: IconApp.email,
                      controller: _emailController,
                    ),
                    20.verticalSpace,
                    PickerInputField(
                      name: 'Năm sinh',
                      iconUrl: IconApp.calendar,
                      controller: _dobController,
                      isClick: false,
                      enabled: true,
                      beginNumber: DateTime.now()
                          .subtract(Duration(days: 12 * 30 * 60))
                          .year,
                      endNumber: DateTime.now().year,
                    ),
                    20.verticalSpace,
                    PasswordInputField(
                      name: 'Mật khẩu mới',
                      iconUrl: IconApp.password,
                      controller: _pwdController,
                      isClick: isClick,
                    ),
                    20.verticalSpace,
                    PasswordInputField(
                      name: 'Xác nhận mật khẩu',
                      iconUrl: IconApp.password,
                      controller: _repwdController,
                      isClick: isClick,
                    ),
                  ],
                ),
                //button
                20.verticalSpace,
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isVerify = !isVerify;
                        });
                      },
                      child: Row(
                        children: [
                          10.horizontalSpace,
                          Image.asset(
                            isVerify ? IconApp.mark : IconApp.unmark,
                            scale: 3.5,
                          ),
                          10.horizontalSpace,
                          BuildText(
                            text: 'Tôi đồng ý với ',
                            style: 14.text600,
                            color: grey500,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => context.pushNamed(
                        WebviewScreen.routeName,
                        arguments: {
                          'title': 'Chính sách & Bảo mật',
                          'url': linkPolicy,
                        },
                      ),
                      child: BuildText(
                        text: 'Chính sách & Bảo mật',
                        style: 14.text600,
                        color: rose500,
                        textDecoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                30.verticalSpace,
                KSubmitButton(
                  size: Size(context.width, 50.h),
                  text: 'Đăng ký',
                  onTap: () => context.read<AuthBloc>().add(
                        AuthEventRegister(
                          context,
                          phone: _phoneController.text,
                          password: _pwdController.text,
                          repassword: _repwdController.text,
                          name: _nameController.text,
                          email: _emailController.text,
                          dob: _dobController.text,
                          isVerify: isVerify,
                        ),
                      ),
                ),
                40.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
