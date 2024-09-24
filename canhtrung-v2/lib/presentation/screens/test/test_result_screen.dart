// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ovumb_app_version1/data/enum/que_type.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/ket_qua_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/test_resutl.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/ketquatest/ketquatest_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/server/server_repository.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_state.dart';
import 'package:flutter_ovumb_app_version1/logic/notification/local/data_notification.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/main_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/edit_test_result.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/notification_setting.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:lottie/lottie.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class TestResultScreen extends StatelessWidget {
  static const routeName = 'test-result-screen';
  final TestResult testResult;

  const TestResultScreen({
    Key? key,
    required this.testResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestBloc, TestState>(
      builder: (context, state) {
        return state.queTestType == QueTestType.trung
            ? TestResultTrungScreen(testResult: testResult)
            : TestResultThaiScreen(testResult: testResult);
      },
    );
  }
}

class TestResultTrungScreen extends StatefulWidget {
  static const routeName = 'test-result-screen';
  final TestResult testResult;

  const TestResultTrungScreen({
    Key? key,
    required this.testResult,
  }) : super(key: key);

  @override
  State<TestResultTrungScreen> createState() => _TestResultTrungScreenState();
}

class _TestResultTrungScreenState extends State<TestResultTrungScreen> {
  final _serverRepository = ServerRepository();
  final _ketQuaTestRepository = KetQuaTestRepository();
  bool isCheckSetting = false;
  double _value = 0;
  int index = 0;
  bool _isDrag = false;
  bool _isEditLH = true;
  bool isShowEditBtn = true;
  int lh = 0;

  @override
  void initState() {
    _value = initValue(widget.testResult.ketQua);
    index = checkRange(_value);
    super.initState();
  }

  double initValue(int lh) {
    return widget.testResult.ketQua.toDouble();
  }

  int lastValue(double value) {
    return value.toInt();
  }

  // final listText = ['Thấp', 'Cao', 'Đạt đỉnh'];
  int checkRange(double value) {
    if (value < 6) {
      return 0;
    } else if (value < 17) {
      return 1;
    } else if (value < 29) {
      return 2;
    } else if (value < 40) {
      return 3;
    } else if (value < 52) {
      return 4;
    } else if (value < 63) {
      return 5;
    } else if (value < 74) {
      return 6;
    } else if (value <= 80) {
      return 7;
    }
    return 0;
  }

  Future _onNextPressed() async {
    String maNguoiDung = await SharedPreferencesService().id ?? '';
    NguoiDung nguoiDung = await LocalRepository().getNguoiDung(maNguoiDung);
    if (widget.testResult.notification != '*') {
      if (isCheckSetting) {
        context.goName(MainScreen.routeName, arguments: nguoiDung);
        if (_isDrag) {
          _serverRepository.updateKetQuaTest(
            maKetQuaTest: widget.testResult.maKetQuaTest,
            ketQua: lastValue(_value),
          );
          _ketQuaTestRepository.insertKetQuaTest(
            ketQuaTest: KetQuaTest(
              maKetQuaTest: 1,
              maLoaiQue: 1,
              lanTest: 1,
              thoiGian: DateTime.now(),
              ketQua: lastValue(_value),
            ),
          );
        }
      } else {
        checkLHNotification(
          flutterLocalNotificationsPlugin,
          widget.testResult.titleNotification,
          widget.testResult.notification,
        );
        await requestNotificationPermission(context);
        isCheckSetting = true;
      }
    } else {
      flutterLocalNotificationsPlugin.cancel(1);
      flutterLocalNotificationsPlugin.cancel(2);
      flutterLocalNotificationsPlugin.cancel(3);

      context.goName(MainScreen.routeName, arguments: nguoiDung);
      if (_isDrag) {
        _serverRepository.updateKetQuaTest(
          maKetQuaTest: widget.testResult.maKetQuaTest,
          ketQua: lastValue(_value),
        );
        _ketQuaTestRepository.insertKetQuaTest(
          ketQuaTest: KetQuaTest(
            maKetQuaTest: 1,
            maLoaiQue: 1,
            lanTest: 1,
            thoiGian: DateTime.now(),
            ketQua: lastValue(_value),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(int.parse(widget.testResult.backgroundColor)),
      body: SafeArea(
        child: Column(
          children: [
            30.verticalSpace,
            SizedBox(
              height: 250.h,
              child: widget.testResult.imageType == 1
                  ? Lottie.network(widget.testResult.imageUrl)
                  : CachedNetworkImage(
                      imageUrl: widget.testResult.imageUrl,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
            ),
            30.verticalSpace,
            BuildText(
              text: widget.testResult.titleText,
              style: 30.text700,
              textAlign: TextAlign.center,
              color: Color(int.parse(widget.testResult.textColor)),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50.h,
                          color: Colors.transparent,
                          child: FlutterSlider(
                            disabled: _isEditLH,
                            values: [_value],
                            rangeSlider: false,
                            foregroundDecoration:
                                BoxDecoration(color: Colors.transparent),
                            max: 80,
                            min: 0,
                            selectByTap: false,
                            jump: false,
                            trackBar: FlutterSliderTrackBar(
                              activeTrackBarHeight: 6,
                              inactiveTrackBarHeight: 6,
                              activeDisabledTrackBarColor: Colors.transparent,
                              inactiveDisabledTrackBarColor: Colors.transparent,
                              inactiveTrackBar: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors
                                    .transparent, // Màu nền khi không được chọn
                              ),
                              activeTrackBar: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    Colors.transparent, // Màu nền khi được chọn
                              ),
                            ),
                            tooltip: FlutterSliderTooltip(
                              disabled: true,
                            ),
                            handlerHeight: 45,
                            handlerWidth: 45,
                            handler: FlutterSliderHandler(
                              decoration: BoxDecoration(),
                              child: Material(
                                color: Colors.transparent,
                                type: MaterialType.canvas,
                                //elevation: 3,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 8,
                                      child: Container(
                                        color: lineColor[index],
                                        height: 20,
                                        width: 30,
                                      ),
                                    ),
                                    Image.asset(IconApp.drag, scale: 3),
                                  ],
                                ),
                              ),
                            ),
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              setState(() {
                                print(index);
                                _isDrag = true;
                                _value = lowerValue;
                                index = checkRange(lowerValue);
                              });
                            },
                          ),
                        ),
                        Image.asset(IconApp.line, scale: 2),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      bottom: 20.h,
                      child: InkWell(
                        onTap: () async {
                          bool? check =
                              await editTestResult(context, screenSize);
                          if (check == true) {
                            setState(() {
                              _isEditLH = false;
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          //color: Colors.amber,
                          child: Image.asset(IconApp.pencil, scale: 3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: BuildText(
                text: widget.testResult.subText,
                style: 15.text500,
                color: grey600,
                textAlign: TextAlign.center,
                maxLines: 5,
              ),
            ),
            60.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: KSubmitButton(
                size: Size(context.width, 50.h),
                text: 'Hoàn thành',
                onTap: () => _onNextPressed(),
              ),
            ),
            50.verticalSpace,
          ],
        ),
      ),
    );
  }
}

class TestResultThaiScreen extends StatelessWidget {
  final TestResult testResult;
  const TestResultThaiScreen({
    Key? key,
    required this.testResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future _onNextPressed() async {
      String maNguoiDung = await SharedPreferencesService().id ?? '';
      NguoiDung nguoiDung = await LocalRepository().getNguoiDung(maNguoiDung);
      context.goName(
        MainScreen.routeName,
        arguments: nguoiDung,
      );
    }

    return Scaffold(
      backgroundColor: Color(int.parse(testResult.backgroundColor)),
      body: SafeArea(
        child: Column(
          children: [
            30.verticalSpace,
            SizedBox(
              height: 400.h,
              child: testResult.imageType == 1
                  ? Lottie.network(testResult.imageUrl)
                  : CachedNetworkImage(
                      imageUrl: testResult.imageUrl,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
            ),
            30.verticalSpace,
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  children: [
                    BuildText(
                      text: testResult.titleText,
                      style: 24.text700,
                      color: Color(int.parse(testResult.textColor)),
                      maxLines: 2,
                    ),
                    10.verticalSpace,
                    BuildText(
                      text: testResult.subText,
                      style: 16.text500,
                      color: grey600,
                      textAlign: TextAlign.center,
                      maxLines: 10,
                    ),
                  ],
                ),
              ),
            ),
            60.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: KSubmitButton(
                size: Size(context.width, 50.h),
                text: 'Hoàn thành',
                onTap: () => _onNextPressed(),
              ),
            ),
            50.verticalSpace,
          ],
        ),
      ),
    );
  }
}
