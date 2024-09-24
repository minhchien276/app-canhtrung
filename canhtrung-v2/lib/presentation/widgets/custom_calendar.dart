// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';

class CustomCalendar extends StatelessWidget {
  final Widget Function(DateTime) builder;
  final Function(DateTime, DateTime) onSelectDay;
  final bool headerVisible;
  final DateTime? firstDay;
  final DateTime? lastDay;
  final DateTime? focusDay;
  const CustomCalendar({
    Key? key,
    required this.builder,
    required this.onSelectDay,
    this.headerVisible = true,
    this.firstDay,
    this.lastDay,
    this.focusDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      rowHeight: 40.h,
      daysOfWeekHeight: 40.h,
      locale: 'vi',
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      focusedDay: focusDay ?? DateTime.now(),
      firstDay: firstDay ?? DateTime.utc(2023, 1, 1),
      lastDay: lastDay ?? DateTime.utc(2030, 3, 14),
      headerVisible: headerVisible,
      headerStyle: HeaderStyle(
        titleTextFormatter: (date, _) => 'Tháng ${date.month}',
        formatButtonVisible: false,
        titleCentered: true,
        headerPadding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: rose50,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.r),
            topRight: Radius.circular(14.r),
          ),
        ),
        leftChevronIcon: const Icon(
          Icons.keyboard_arrow_left,
          color: rose400,
        ),
        rightChevronIcon: const Icon(
          Icons.keyboard_arrow_right,
          color: rose400,
        ),
        rightChevronPadding: EdgeInsets.only(right: 50.w),
        leftChevronPadding: EdgeInsets.only(left: 50.w),
        titleTextStyle: 13.text700.copyWith(color: grey700),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        dowTextFormatter: (date, locale) {
          return convertWeekDay(date.weekday);
        },
        decoration: BoxDecoration(color: rose50),
        weekdayStyle: 12.text700.copyWith(color: grey700),
        weekendStyle: 12.text700.copyWith(color: grey700),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, markedDates) {
          return builder(day);
        },
      ),
      calendarStyle: CalendarStyle(
        rowDecoration: BoxDecoration(
          color: rose50,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: textStyleDefaultCalendar,
        weekendTextStyle: textStyleDefaultCalendar,
        todayTextStyle: textStyleDefaultCalendar,
        holidayTextStyle: textStyleDefaultCalendar,
        outsideTextStyle: textStyleDefaultCalendar,
        disabledTextStyle: textStyleDefaultCalendar,
        rangeEndTextStyle: textStyleDefaultCalendar,
        selectedTextStyle: textStyleDefaultCalendar,
        rangeStartTextStyle: textStyleDefaultCalendar,
        weekNumberTextStyle: textStyleDefaultCalendar,
        withinRangeTextStyle: textStyleDefaultCalendar,
      ),
      onDaySelected: onSelectDay,
      availableGestures: AvailableGestures.horizontalSwipe,
    );
  }
}

final textStyleDefaultCalendar = 11.text500;
