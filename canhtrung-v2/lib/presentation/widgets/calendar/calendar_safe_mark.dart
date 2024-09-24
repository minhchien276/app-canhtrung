// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nhat_ky.dart';
import 'package:flutter_ovumb_app_version1/logic/ads/ads.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/custom_calendar.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarSafeMark extends StatefulWidget {
  final bool isToday;
  final bool isNormal;
  final DateTime day;
  final List<NhatKy> listNhatKy;
  final bool check;

  const CalendarSafeMark({
    Key? key,
    required this.isToday,
    required this.isNormal,
    required this.day,
    required this.listNhatKy,
    required this.check,
  }) : super(key: key);

  @override
  State<CalendarSafeMark> createState() => _CalendarSafeMarkState();
}

class _CalendarSafeMarkState extends State<CalendarSafeMark> {
  bool hasNhatKy = false;

  @override
  void initState() {
    super.initState();
    showAds(
      context: context,
      isToday: widget.isToday,
      type: 2,
    );
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
        Image.asset(
          height: 32.h,
          width: 32.h,
          widget.check
              ? IconApp.rectangleDashRounded
              : IconApp.rectangleSafeFill,
          fit: BoxFit.cover,
          color: const Color(0xff5181FF),
        ),
        Center(
          child: BuildText(
            text: widget.day.day.toString(),
            style: textStyleDefaultCalendar,
            color: widget.check ? const Color(0xff5181FF) : whiteColor,
          ),
        ),
        hasNhatKy
            ? Positioned(
                bottom: 10.h,
                child: Image.asset(
                  IconApp.dash,
                  width: 15.h,
                  color: rose400,
                ),
              )
            : widget.isToday
                ? Positioned(
                    height: 4.h,
                    width: 4.h,
                    bottom: 8.h,
                    child: Image.asset(
                      IconApp.dot,
                      color: widget.check
                          ? (widget.isNormal ? rose400 : whiteColor)
                          : whiteColor,
                    ),
                  )
                : Container(),
      ],
    );
  }
}
