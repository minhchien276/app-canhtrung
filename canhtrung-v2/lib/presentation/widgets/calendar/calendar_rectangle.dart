// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/models/nguoidung/ket_qua_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nhat_ky.dart';
import 'package:flutter_ovumb_app_version1/logic/ads/ads.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/custom_calendar.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarRectangleMark extends StatefulWidget {
  final bool hasData;
  final bool isToday;
  final bool isNormal;
  final DateTime day;
  final List<NhatKy> listNhatKy;
  final List<KetQuaTest> listKetQuaTest;

  const CalendarRectangleMark({
    Key? key,
    required this.hasData,
    required this.isToday,
    required this.isNormal,
    required this.day,
    required this.listNhatKy,
    required this.listKetQuaTest,
  }) : super(key: key);

  @override
  State<CalendarRectangleMark> createState() => _CalendarRectangleMarkState();
}

class _CalendarRectangleMarkState extends State<CalendarRectangleMark> {
  bool hasNhatKy = false;
  List<String> listImage = [
    IconApp.rectangleFill1,
    IconApp.rectangleFill2,
    IconApp.rectangleFill3,
  ];
  int index = 0;

  @override
  void initState() {
    super.initState();
    showAds(
      context: context,
      isToday: widget.isToday,
      type: 3,
    );
    checkLH();
  }

  void checkLH() {
    if (widget.hasData) {
      final res = widget.listKetQuaTest
          .where((e) =>
              e.thoiGian.millisecondsSinceEpoch ==
              widget.day.millisecondsSinceEpoch)
          .toList();

      if (res.isNotEmpty) {
        final ketQuaTest = res.first;
        if (ketQuaTest.ketQua < 35) {
          index = 2;
        } else if (ketQuaTest.ketQua < 46) {
          index = 1;
        } else {
          index = 0;
        }
      }
    }
  }

  void checkNhatKy(List<NhatKy> listNhatKy) {
    List<NhatKy> nhatKys = listNhatKy
        .where((e) =>
            e.thoiGian.millisecondsSinceEpoch ==
            widget.day.millisecondsSinceEpoch)
        .toList();
    if (nhatKys.isNotEmpty) {
      hasNhatKy = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkNhatKy(widget.listNhatKy);
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!widget.isNormal) ...[
          Center(
            child: Image.asset(
              height: 32.h,
              width: 32.h,
              widget.hasData ? listImage[index] : IconApp.rectangleDashRounded,
              fit: BoxFit.cover,
              color: rose500,
            ),
          ),
        ],
        Center(
          child: BuildText(
            text: widget.day.day.toString(),
            style: textStyleDefaultCalendar,
            color: widget.hasData ? whiteColor : rose500,
          ),
        ),
        hasNhatKy
            ? Positioned(
                bottom: 10.h,
                child: Image.asset(
                  IconApp.dash,
                  width: 15.h,
                  color: widget.hasData ? whiteColor : rose400,
                ),
              )
            : widget.isToday
                ? Positioned(
                    bottom: 8.h,
                    height: 4.h,
                    width: 4.h,
                    child: Image.asset(
                      IconApp.dot,
                      color: widget.isNormal
                          ? rose400
                          : widget.hasData
                              ? whiteColor
                              : rose400,
                    ),
                  )
                : Container(),
      ],
    );
  }
}
