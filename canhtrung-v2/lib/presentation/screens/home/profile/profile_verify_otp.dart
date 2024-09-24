// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/auth_v2/auth_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_event.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_logo.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';
import 'package:pinput/pinput.dart';

import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/primary_font.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class ProfileVerifyOtpScreen extends StatefulWidget {
  static const String routeName = 'profile-verify-otp-screen';
  final String email;
  const ProfileVerifyOtpScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<ProfileVerifyOtpScreen> createState() => _ProfileVerifyOtpScreenState();
}

class _ProfileVerifyOtpScreenState extends State<ProfileVerifyOtpScreen> {
  final _auth = AuthRepositoryV2();
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  late Timer _timer;
  int _start = 59;

  String formatCountdown(int seconds) {
    if (seconds > 9) {
      return '00:$seconds';
    }
    return '00:0$seconds';
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = rose400;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: rose100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: whiteColor),
      ),
    );
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: TitleText(
            text: 'Xoá tài khoản',
            fontWeight: FontWeight.w600,
            size: 18,
            color: grey700,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset(
              'assets/icons/back_button.png',
              scale: 3,
            ),
          ),
          backgroundColor: whiteColor,
          shadowColor: whiteColor,
          bottomOpacity: 0.1,
          elevation: 3,
        ),
        body: MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                children: [
                  TitleText(
                    text: 'Xác thực mã OTP',
                    fontWeight: FontWeight.w900,
                    size: 20,
                    color: grey700,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  TitleText(
                    text: 'Nhập mã OTP đã gửi đến email',
                    fontWeight: FontWeight.w500,
                    size: 14,
                    color: grey500,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  TitleText(
                    text: widget.email,
                    fontWeight: FontWeight.w500,
                    size: 14,
                    color: grey900,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Pinput(
                    autofocus: true,
                    controller: pinController,
                    focusNode: focusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    validator: (value) {
                      if (value == null || value.length != 4) {
                        return 'Vui lòng nhập đúng mã xác thực';
                      }
                      return null;
                    },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {},
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: rose200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: rose100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TitleText(
                        text: 'Không nhận được OTP?',
                        fontWeight: FontWeight.w500,
                        size: 14,
                        color: grey700,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 6),
                      _start != 0
                          ? TitleText(
                              text: formatCountdown(_start),
                              fontWeight: FontWeight.w600,
                              size: 14,
                              color: rose500,
                              textAlign: TextAlign.center,
                            )
                          : InkWell(
                              onTap: () {},
                              child: TitleText(
                                text: 'Gửi lại',
                                fontWeight: FontWeight.w600,
                                size: 14,
                                color: rose500,
                                textAlign: TextAlign.center,
                                textDecoration: TextDecoration.underline,
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              rose600,
                              rose400,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(38),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.1),
                              spreadRadius: 4,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ]),
                      child: ElevatedButton(
                        onPressed: () async {
                          LoadingLogo().show(context: context);
                          bool check =
                              await _auth.verifyOtp(otp: pinController.text);
                          LoadingLogo().hide();
                          if (check == true) {
                            showToast(context, 'Xoá tài khoản thành công');
                            BlocProvider.of<AuthBloc>(context)
                                .add(AuthEventLogout(context));
                          } else {
                            showToast(context,
                                'Mã OTP không hợp lệ hoặc đã hết hạn. Vui lòng thử lại');
                          }
                        },
                        style: ButtonStyle(
                          overlayColor:
                              const WidgetStatePropertyAll(Colors.transparent),
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(38),
                            ),
                          ),
                          elevation: WidgetStatePropertyAll(0),
                          fixedSize: WidgetStatePropertyAll(
                            Size(size.width * 0.8, 50),
                          ),
                          textStyle: WidgetStatePropertyAll(
                            PrimaryFont.semibold(16, FontWeight.w600)
                                .copyWith(color: greyText),
                          ),
                        ),
                        child: TitleText(
                          text: 'Xác nhận',
                          fontWeight: FontWeight.w600,
                          size: 16,
                          color: whiteColor,
                        ),
                      ),
                    ),
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
