// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/que_type.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/quan_ly_que_test.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/image_analyze_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/test_thai_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// màn hình chọn que test
class TestSelectScreen extends StatefulWidget {
  static const routeName = 'test-select-screen';
  const TestSelectScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TestSelectScreen> createState() => _TestSelectScreenState();
}

class _TestSelectScreenState extends State<TestSelectScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller1;
  late Animation<double> animation;
  late Animation<double> animation1;

  bool test1Selected = false;
  bool test2Selected = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    setRotation(15);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    controller1.dispose();
  }

  //animation
  void setRotation(int degrees) {
    final angle = degrees * pi / 180;
    animation = Tween<double>(begin: -0.1, end: angle).animate(controller);
    animation1 = Tween<double>(begin: -0.1, end: angle).animate(controller1);
  }

  void _onNextPressed(
    QuanLyQueTest? item,
    List<Guide> videos,
    List<Guide> images,
  ) async {
    if (item != null) {
      if (test1Selected) {
        if (item.soLuongQueTrung > 0) {
          context.pushNamed(
            ImageAnalyzeScreen.routeName,
            arguments: {
              'maQuanLyQueTest': item.maQuanLyQueTest,
              'queTestType': QueTestType.trung,
              'videos': videos,
              'images': images,
            },
          );
        }
      } else if (test2Selected) {
        bool? check =
            await requestThaiTest(context, Size(context.width, context.height));
        if (check == true) {
          if (item.soLuongQueThai > 0) {
            context.pushNamed(
              ImageAnalyzeScreen.routeName,
              arguments: {
                'maQuanLyQueTest': item.maQuanLyQueTest,
                'queTestType': QueTestType.thai,
                'videos': videos,
                'images': images,
              },
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<TestBloc, TestState>(
      listener: (context, state) {
        if (state.status == LoadedStatus.succes && state.isNext) {
          _onNextPressed(
            state.quanLyQueTest,
            state.videos,
            state.images,
          );
        }
      },
      builder: (context, state) {
        int quetrung = state.quanLyQueTest!.soLuongQueTrung;
        int quethai = state.quanLyQueTest!.soLuongQueThai;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              BuildText(
                text: 'Chọn que Test',
                style: 22.text700,
                color: rose400,
              ),
              SizedBox(
                height: 50.h,
                child: test1Selected
                    ? RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Bạn đã lựa chọn',
                              style: 15.text400.copyWith(color: grey700),
                            ),
                            TextSpan(
                              text: ' Que test thử rụng trứng\n',
                              style: 15.text700.copyWith(color: violet500),
                            ),
                            TextSpan(
                              text: 'Còn ',
                              style: 15.text400.copyWith(color: grey700),
                            ),
                            TextSpan(
                              text: '$quetrung lượt sử dụng ',
                              style: 15.text700.copyWith(color: violet500),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      )
                    : test2Selected
                        ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Bạn đã lựa chọn',
                                  style: 15.text400.copyWith(color: grey700),
                                ),
                                TextSpan(
                                  text: ' Que test thử thai\n',
                                  style: 15.text700.copyWith(color: greenColor),
                                ),
                                TextSpan(
                                  text: 'Còn ',
                                  style: 15.text400.copyWith(color: grey700),
                                ),
                                TextSpan(
                                  text: '$quethai lượt sử dụng ',
                                  style: 15.text700.copyWith(color: greenColor),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Lựa chọn que phù hợp với mục đích của bạn',
                            style: 15.text400.copyWith(color: grey700),
                            textAlign: TextAlign.center,
                          ),
              ),
              20.verticalSpace,
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 5,
                      left: 40,
                      child: AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) => Transform.scale(
                          scale: animation.value + 1,
                          child: Transform.rotate(
                            angle: animation.value,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  // nếu bằng true thì đảo ngược lại, fasle thì chạy lên
                                  test1Selected
                                      ? controller.reverse(from: 15)
                                      : controller.forward(from: 0);

                                  test1Selected = !test1Selected;

                                  //nếu test2 cũng đang được chọn thì set về false đồng thời đảo lại
                                  if (test2Selected) {
                                    test2Selected = !test2Selected;
                                    controller1.reverse(from: 15);
                                  }
                                });
                              },
                              hoverColor: Colors.transparent,
                              child: SizedBox(
                                width: size.width * 0.8,
                                child: Image.asset(
                                  test2Selected ? Imgs.que : Imgs.queTrung,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 40,
                      child: AnimatedBuilder(
                        animation: animation1,
                        builder: (context, child) => Transform.scale(
                          scale: animation1.value + 1,
                          child: Transform.rotate(
                            angle: animation1.value,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  test2Selected
                                      ? controller1.reverse(from: 15)
                                      : controller1.forward(from: 0);

                                  test2Selected = !test2Selected;
                                  if (test1Selected) {
                                    test1Selected = !test1Selected;
                                    controller.reverse(from: 15);
                                  }
                                });
                              },
                              hoverColor: Colors.transparent,
                              child: SizedBox(
                                width: size.width * 0.8,
                                child: Image.asset(
                                  test1Selected ? Imgs.que : Imgs.queThai,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              50.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        test2Selected ? Imgs.dot : Imgs.dotTrung,
                        scale: 3,
                      ),
                      4.horizontalSpace,
                      BuildText(
                        text: 'Que thử rụng trứng',
                        style: 12.text500,
                        color: grey600,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        test2Selected ? Imgs.dot : Imgs.dotThai,
                        scale: 3,
                      ),
                      4.horizontalSpace,
                      BuildText(
                        text: 'Que thử thai',
                        style: 12.text500,
                        color: grey600,
                      ),
                    ],
                  ),
                ],
              ),
              50.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: KSubmitButton(
                  size: Size(context.width, 50.h),
                  text: 'Xác nhận',
                  bgColor: ((test1Selected && quetrung > 0) ||
                          (test2Selected && quethai > 0))
                      ? null
                      : rose600.withOpacity(0.6),
                  onTap: () => context
                      .read<TestBloc>()
                      .add(TestGuideEvent(context: context, isNext: true)),
                ),
              ),
              TextButton(
                onPressed: () => context.pop(),
                child: BuildText(
                  text: 'Huỷ',
                  style: 16.text400,
                  color: rose400,
                  textDecoration: TextDecoration.underline,
                ),
              ),
              40.verticalSpace,
            ],
          ),
        );
      },
    );
  }
}
