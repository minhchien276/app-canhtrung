import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:intl/intl.dart';

extension DatetimeFormat on DateTime {
  DateTime formatStartDate() {
    return DateTime.parse(DateFormat('yyyy-MM-dd 00:00:00.000').format(this));
  }

  DateTime formatEndDate() {
    return DateTime.parse(DateFormat('yyyy-MM-dd 23:59:59.000').format(this));
  }

  String formatDayMonth() {
    return '${this.day}/${this.month}';
  }

  String formatDDMMYYY() {
    return '${this.day}/${this.month}/${this.year}';
  }

  toTime() => DateFormat('HH:mm').format(this);

  formatDateTime() => DateFormat('dd/MM/yyyy HH:mm').format(this);

  String betweenNow() {
    DateTime now = DateTime.now();
    final res = now.difference(this).inDays;
    if (res == 0) {
      return 'Hôm nay';
    } else if (res == 1) {
      return 'Hôm qua';
    }
    return DateFormat('dd/MM/yyyy').format(this);
  }
}

String periodBeginAndEnd(DateTime begin, DateTime end) {
  if (checkBetween(
      DateTime.now(), begin.formatStartDate(), end.formatEndDate())) {
    return '${begin.day}/${begin.month}/${begin.year} - ${end.day}/${end.month}/${end.year}*';
  }
  return '${begin.day}/${begin.month}/${begin.year} - ${end.day}/${end.month}/${end.year}';
}

extension TimeFormat on TimeOfDay {
  String formatTime() {
    return '${this.hour.toString().padLeft(2, '0')}:${this.minute.toString().padLeft(2, '0')}';
  }
}
