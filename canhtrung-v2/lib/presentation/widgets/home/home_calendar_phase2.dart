// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/calendar/calendar_display_phase2.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/calendar/calendar_modal.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/custom_calendar.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog_calendar.dart';
import 'package:flutter_ovumb_app_version1/data/models/calendar/calendar_day.dart';
import 'package:flutter_ovumb_app_version1/data/models/calendar/ckkn_display.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/cau_hoi.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/logic/notification/local/data_notification.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/home/home_half_percent_container.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomeCalendarPhase2 extends StatefulWidget {
  final CalendarDay listCalendar;
  final CKKNDisplay ckknDisplay;
  final List<CauHoi> listCauHoi;
  final NguoiDung nguoiDung;

  const HomeCalendarPhase2({
    Key? key,
    required this.listCalendar,
    required this.ckknDisplay,
    required this.listCauHoi,
    required this.nguoiDung,
  }) : super(key: key);

  @override
  State<HomeCalendarPhase2> createState() => _HomeCalendarPhase2State();
}

class _HomeCalendarPhase2State extends State<HomeCalendarPhase2> {
  //percent
  bool leftShow = false;
  bool rightShow = false;
  bool bothShow = true;

  //get dislay ckkn
  //late CKKNDisplay ckknDisplay;

  @override
  void initState() {
    // lấy dữ liệu
    //ckknDisplay = getCKKNDisplay(widget.listCalendar.currentKinhNguyet);
    // gửi thông báo
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
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: rose50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: CustomCalendar(
                builder: (day) => CalendarDisplayPhase2(
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
          ),
        ),
      ],
    );
  }
}
