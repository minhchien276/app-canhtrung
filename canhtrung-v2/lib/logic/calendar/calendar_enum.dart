//chu kì kinh nguyệt có 3 trạng thái là quá khứ, hiện tại, tương lai
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';

enum CalendarStatus {
  past,
  now,
  future,
}

class CalendarHandler {
  static getIndex(CalendarStatus status) {
    switch (status) {
      case CalendarStatus.past:
        return 0;
      case CalendarStatus.now:
        return 1;
      case CalendarStatus.future:
        return 2;
      default:
        return 1;
    }
  }

  static getStatus(int index) {
    switch (index) {
      case 0:
        return CalendarStatus.past;
      case 1:
        return CalendarStatus.now;
      case 2:
        return CalendarStatus.future;
      default:
        return CalendarStatus.now;
    }
  }

  static getIndexByDate(DateTime begin, DateTime end, {DateTime? now}) {
    now = now ?? DateTime.now().formatStartDate();
    begin = begin.formatStartDate();
    end = end.formatStartDate();
    if (now.isAfter(end)) {
      return 0;
    } else if (checkBetween(now, begin, end)) {
      return 1;
    } else {
      return 2;
    }
  }
}
