// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/constant/choose_phase.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_event.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

//phần chọn màn
class ChooseHomeScreen extends StatefulWidget {
  static const routeName = 'choose-home-screen';
  const ChooseHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChooseHomeScreen> createState() => _ChooseHomeScreenState();
}

class _ChooseHomeScreenState extends State<ChooseHomeScreen> {
  List<bool> select = [false, false, false, false];
  int? pos = null;
  ChoosePhase? phaseSelected;

  handleNextPressed(ChoosePhase? phaseSelected) =>
      context.read<AuthBloc>().add(AuthChoosePhaseEvent(
            context,
            phaseSelected: phaseSelected,
          ));
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            100.verticalSpace,
            Flexible(child: Image.asset(ImageApp.logoAppbar)),
            60.verticalSpace,
            Container(
              height: 110.h,
              width: size.width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      TitleText(
                        text: 'Hãy lựa chọn tính năng',
                        fontWeight: FontWeight.w700,
                        size: 24,
                        color: grey700,
                      ),
                      4.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        child: ChooseText(
                          text: pos != null
                              ? choosePhase[pos!].content
                              : 'Bạn đang mong muốn sử dụng',
                          textColor: pos != null
                              ? choosePhase[pos!].fromColor
                              : grey700,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: -30.w,
                    top: 0,
                    bottom: 0,
                    child: Transform(
                      transform: Matrix4.rotationY(3.14),
                      child: Container(
                        child: Lottie.asset(
                          fit: BoxFit.cover,
                          'assets/animations/arrow_down.json',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => InkWell(
                    onTap: () {
                      select = [false, false, false, false];
                      setState(() {
                        select[index] = true;
                        pos = index;
                        phaseSelected = choosePhase[index];
                      });
                    },
                    splashColor: grey200,
                    child: Container(
                      height: 85.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Image.asset(
                                  choosePhase[index].image,
                                  scale: 3,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        BuildText(
                                          text: choosePhase[index].title,
                                          style: 16.text600,
                                          color: grey700,
                                        ),
                                        2.verticalSpace,
                                        BuildText(
                                          text: choosePhase[index].subTitle,
                                          style: 16.text400,
                                          color: grey500,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  !select[index]
                                      ? 'assets/icons/radio_uncheck.png'
                                      : 'assets/icons/radio_check.png',
                                  scale: 2.5,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                              color: grey100, thickness: 1, height: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            70.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: KSubmitButton(
                size: Size(context.width, 50.h),
                text: 'Xác nhận',
                onTap: () => handleNextPressed(phaseSelected),
              ),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class ChooseText extends StatelessWidget {
  final String text;
  final Color textColor;
  const ChooseText({
    Key? key,
    required this.text,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ).copyWith(color: textColor),
      textAlign: TextAlign.center,
    );
  }
}
