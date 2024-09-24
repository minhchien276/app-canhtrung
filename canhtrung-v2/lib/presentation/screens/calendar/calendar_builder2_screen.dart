// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/calendar/calendar_display_phase2.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/calendar/calendar_modal.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/custom_calendar.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter_ovumb_app_version1/data/models/calendar/calendar_day.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/cau_hoi.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';

class CalendarBuild2Screen extends StatefulWidget {
  final List<Map<String, DateTime>> listRange;
  final NguoiDung nguoiDung;
  final List<CauHoi> listCauHoi;
  final CalendarDay listCalendar;
  const CalendarBuild2Screen({
    Key? key,
    required this.listRange,
    required this.nguoiDung,
    required this.listCauHoi,
    required this.listCalendar,
  }) : super(key: key);

  @override
  State<CalendarBuild2Screen> createState() => _CalendarBuild2ScreenState();
}

class _CalendarBuild2ScreenState extends State<CalendarBuild2Screen> {
  int getIndex() {
    int index = 0;
    for (int i = 0; i < widget.listRange.length; i++) {
      if (checkBetween(DateTime.now().formatStartDate(),
          widget.listRange[i].values.first, widget.listRange[i].values.last)) {
        return i;
      }
    }
    return index;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ScrollablePositionedList.builder(
      itemCount: widget.listRange.length,
      initialScrollIndex: getIndex(),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
            BuildText(
              text: convertMonthYear(widget.listRange[index].values.first),
              style: 14.text700,
              color: grey700,
            ),
            10.verticalSpace,
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: rose50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: CustomCalendar(
                headerVisible: false,
                firstDay: widget.listRange[index].values.first,
                lastDay: widget.listRange[index].values.last,
                focusDay: widget.listRange[index].values.first,
                builder: (day) => CalendarDisplayPhase2(
                  listCalendar: widget.listCalendar,
                  day: day.formatStartDate(),
                ),
                onSelectDay: (selectedDay, _) {
                  showCalendarPicker(
                    context,
                    screenSize,
                    selectDay: selectedDay.formatStartDate(),
                    calendarData: widget.listCalendar,
                  );
                },
              ),
            ),
            10.verticalSpace,
          ],
        );
      },
    );
  }
}
