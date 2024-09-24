// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/calendar/calendar_display_phase1.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/calendar/calendar_modal.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/custom_calendar.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_ovumb_app_version1/data/models/calendar/calendar_day.dart';
import 'package:flutter_ovumb_app_version1/data/models/calendar/ckkn_display.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/cau_hoi.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/logic/notification/local/data_notification.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/home/home_half_percent_container.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomeCalendarPhase1 extends StatefulWidget {
  final CalendarDay listCalendar;
  final CKKNDisplay ckknDisplay;
  final List<CauHoi> listCauHoi;
  final NguoiDung nguoiDung;

  const HomeCalendarPhase1({
    Key? key,
    required this.listCalendar,
    required this.ckknDisplay,
    required this.listCauHoi,
    required this.nguoiDung,
  }) : super(key: key);

  @override
  State<HomeCalendarPhase1> createState() => _HomeCalendarPhase1State();
}

class _HomeCalendarPhase1State extends State<HomeCalendarPhase1> {
  //percent
  bool leftShow = false;
  bool rightShow = false;
  bool bothShow = true;

  @override
  void initState() {
    checkNotification(widget.listCalendar.listKinhNguyet, widget.ckknDisplay,
        flutterLocalNotificationsPlugin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(5.h),
              decoration: BoxDecoration(
                color: rose50,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: CustomCalendar(
                builder: (day) => CalendarDisplayPhase1(
                  listCalendar: widget.listCalendar,
                  day: day.formatStartDate(),
                ),
                onSelectDay: (selectedDay, _) => showCalendarPicker(
                  context,
                  screenSize,
                  selectDay: selectedDay.formatStartDate(),
                  calendarData: widget.listCalendar,
                ),
              ),
            ),
            10.verticalSpace,
            HomePercent(ckknDisplay: widget.ckknDisplay),
          ],
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: Image.asset(
              IconApp.note,
              scale: 3,
            ),
            onPressed: () {
              if (widget.nguoiDung.phase == 2) {
                dialogBuilder(context, screenSize);
              } else if (widget.nguoiDung.phase == 1) {
                dialogBuilder1(context, screenSize);
              } else {
                dialogBuilder2(context, screenSize);
              }
            },
            //onPressed: () => adsDialog(context, screenSize),
          ),
        ),
      ],
    );
  }
}
