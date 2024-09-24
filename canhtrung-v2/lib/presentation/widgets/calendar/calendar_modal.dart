import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/calendar/calendar_day.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/calendar/calendar_modal_bottom.dart';

showCalendarPicker(
  BuildContext context,
  Size screenSize, {
  required DateTime selectDay,
  required CalendarDay calendarData,
}) {
  showModalBottomSheet(
    elevation: 0,
    constraints: BoxConstraints(
      maxWidth: double.infinity,
    ),
    backgroundColor: Colors.white.withOpacity(0),
    barrierColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(26),
      ),
    ),
    context: context,
    builder: (context) {
      return Container(
        width: context.width,
        height: screenSize.height * 0.82,
        child: Stack(
          children: [
            Positioned(
              top: 10,
              child: Container(
                height: screenSize.height * 0.1,
                width: screenSize.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      rose300.withOpacity(0.7),
                      rose300.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: CalendarModalBottom(
                selectedDay: selectDay,
                calendarData: calendarData,
              ),
            ),
          ],
        ),
      );
    },
    isScrollControlled: true,
  );
}
