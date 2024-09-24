import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DateTimePickerWiget {
  /// This builds material date picker in Android
  Future<DateTime?> buildMaterialDatePicker(
    BuildContext context,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime initDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: firstDate ??
          DateTime.parse(
              DateFormat('yyyy-MM-dd 00:00:00.000').format(DateTime.now())),
      lastDate: lastDate ??
          DateTime.now().add(Duration(
            hours: 23 - DateTime.now().hour,
            minutes: 59 - DateTime.now().minute,
            seconds: 59 - DateTime.now().second,
            milliseconds: 999 - DateTime.now().millisecond,
          )),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: rose400,
            ),
            dialogTheme: DialogTheme(
              backgroundColor: whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(28),
                ),
              ),
            ),
          ).copyWith(
            datePickerTheme: const DatePickerThemeData(
              headerBackgroundColor: rose400,
              headerForegroundColor: Colors.white,
              backgroundColor: whiteColor,
            ),
            dividerTheme: const DividerThemeData(
              color: Colors.transparent,
            ),
          ),
          child: child!,
        );
      },
    );
    return picked;
  }

  /// This builds cupertion date picker in iOS
  Future<DateTime?> buildCupertinoDatePicker(
    BuildContext context,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime initDate,
  ) async {
    DateTime? date;
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (picked) {
              date = picked;
            },
            initialDateTime: initDate,
            minimumDate: firstDate ??
                DateTime.parse(DateFormat('yyyy-MM-dd 00:00:00.000')
                    .format(DateTime.now())),
            maximumDate: lastDate ??
                DateTime.now().add(
                  Duration(
                    hours: 23 - DateTime.now().hour,
                    minutes: 59 - DateTime.now().minute,
                    seconds: 59 - DateTime.now().second,
                    milliseconds: 999 - DateTime.now().millisecond,
                  ),
                ),
          ),
        );
      },
    );
    return date;
  }

  /// This builds material date picker in Android
  Future<TimeOfDay?> buildMaterialTimePicker(
      BuildContext context, TimeOfDay initTime) async {
    final TimeOfDay? picked = await showTimePicker(
        builder: (context1, child) {
          return Theme(
            data: ThemeData(
              colorScheme: ColorScheme.light(
                primary: rose400, // header background color
              ),
              dialogTheme: DialogTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(28),
                  ),
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialTime: initTime);
    return picked;
  }

  Future<TimeOfDay?> buildCupertinoTimePicker(
    BuildContext context,
    TimeOfDay initTime,
  ) async {
    TimeOfDay? selectedTime;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (picked) {
              selectedTime = TimeOfDay.fromDateTime(
                DateTime(2023, 1, 1, picked.hour, picked.minute),
              );
            },
            use24hFormat: true,
            initialDateTime:
                DateTime(2023, 1, 1, initTime.hour, initTime.minute),
          ),
        );
      },
    );

    return selectedTime;
  }

  Future<DateTime?> selectDate(
    BuildContext context, {
    DateTime? firstDate,
    DateTime? lastDate,
    required DateTime initDate,
  }) async {
    return buildCupertinoDatePicker(context, firstDate, lastDate, initDate);
  }

  Future<TimeOfDay?> selectTime(
    BuildContext context, {
    required TimeOfDay initDate,
  }) async {
    return buildCupertinoTimePicker(context, initDate);
  }
}

void showDateTimePicker(
  BuildContext context, {
  DateTime? initDate,
  required Function(DateTime) onChange,
}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 300.h,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: CupertinoDatePicker(
          initialDateTime: initDate ?? DateTime.now(),
          use24hFormat: true,
          onDateTimeChanged: onChange,
          maximumDate: DateTime.now(),
        ),
      ),
    ),
  );
}
