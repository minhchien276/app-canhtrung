// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nhat_ky.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/custom_calendar.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarHash extends StatefulWidget {
  final DateTime day;
  final List<NhatKy> listNhatKy;
  final bool isToday;

  const CalendarHash({
    Key? key,
    required this.day,
    required this.listNhatKy,
    required this.isToday,
  }) : super(key: key);

  @override
  State<CalendarHash> createState() => _CalendarHashState();
}

class _CalendarHashState extends State<CalendarHash> {
  bool hasNhatKy = false;

  @override
  void initState() {
    super.initState();
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
        Center(
          child: BuildText(
            text: widget.day.day.toString(),
            style: textStyleDefaultCalendar,
            color: grey700,
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
                    bottom: 8.h,
                    height: 4.h,
                    width: 4.h,
                    child: SizedBox(
                      child: Image.asset(
                        IconApp.dot,
                        color: rose400,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(),
      ],
    );
  }
}
