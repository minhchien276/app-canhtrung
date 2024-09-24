// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/models/nguoidung/luong_kinh.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nhat_ky.dart';
import 'package:flutter_ovumb_app_version1/logic/ads/ads.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/custom_calendar.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarWaterMark extends StatefulWidget {
  final bool hasData;
  final bool isToday;
  final bool isNormal;
  final DateTime day;
  final List<LuongKinh> listLuongKinh;
  final List<NhatKy> listNhatKy;
  const CalendarWaterMark({
    Key? key,
    required this.hasData,
    required this.isToday,
    required this.isNormal,
    required this.day,
    required this.listLuongKinh,
    required this.listNhatKy,
  }) : super(key: key);

  @override
  State<CalendarWaterMark> createState() => _CalendarWaterMarkState();
}

class _CalendarWaterMarkState extends State<CalendarWaterMark> {
  final List<String> listImage = [
    IconApp.waterFill1,
    IconApp.waterFill2,
    IconApp.waterFill3,
  ];
  int index = 2;
  bool hasNhatKy = false;

  @override
  void initState() {
    super.initState();
    showAds(
      context: context,
      isToday: widget.isToday,
      type: 1,
    );
  }

  void checkKinh(List<LuongKinh> listLuongKinh) {
    if (widget.hasData) {
      LuongKinh luongKinh = listLuongKinh
          .where((e) =>
              e.thoiGian.millisecondsSinceEpoch ==
              widget.day.millisecondsSinceEpoch)
          .toList()
          .first;

      if (luongKinh.luongKinh == 'Ít') {
        index = 2;
      } else if (luongKinh.luongKinh == 'Trung bình') {
        index = 1;
      } else if (luongKinh.luongKinh == 'Nhiều') {
        index = 0;
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
    checkKinh(widget.listLuongKinh);
    checkNhatKy(widget.listNhatKy);
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!widget.isNormal) ...[
          Center(
            child: Container(
              child: Image.asset(
                widget.hasData ? listImage[index] : IconApp.waterRounded,
                fit: BoxFit.contain,
                height: 38.h,
                width: 38.h,
              ),
            ),
          ),
        ],
        Center(
          child: BuildText(
            text: widget.day.day.toString(),
            style: textStyleDefaultCalendar,
            color: widget.hasData ? whiteColor : greyText,
          ),
        ),
        hasNhatKy
            ? Positioned(
                bottom: 8.h,
                child: Image.asset(
                  IconApp.dash,
                  width: 15.h,
                  color: widget.hasData ? whiteColor : rose400,
                ),
              )
            : widget.isToday
                ? Positioned(
                    height: 4.h,
                    width: 4.h,
                    bottom: 8.h,
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
