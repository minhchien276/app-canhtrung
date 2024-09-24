import 'package:flutter_ovumb_app_version1/data/models/calendar/calendar_day.dart';

abstract class CalendarProviderV2 {
  Future<CalendarDay> getCalendarData();
  Stream<CalendarDay> streamData();
}
