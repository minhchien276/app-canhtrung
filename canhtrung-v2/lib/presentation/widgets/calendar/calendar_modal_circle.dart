// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/models/calendar/calendar_day.dart';
import 'package:flutter_ovumb_app_version1/data/models/modal/calendar_modal.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/nhatky_screen_v2.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/color.dart';

//hình tròn để hiển thị ngày và có nút chỉnh sửa thông tin khi hiện modal bottomf chọn ngày trong lịch
class CalendarModalCircle extends StatelessWidget {
  final int dayOfChuKi;
  final int check;
  final DateTime date;
  final CalendarDay listCalendar;
  final int indexModal;
  const CalendarModalCircle({
    Key? key,
    required this.dayOfChuKi,
    required this.check,
    required this.date,
    required this.listCalendar,
    required this.indexModal,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    handleNextClick() {
      int numbersDateToNow =
          DateTime.now().formatStartDate().difference(date).inDays;
      if (numbersDateToNow > 90) {
        showToast(
          context,
          "Bạn chỉ có thể chỉnh sửa trong khoảng 90 ngày từ ngày hiện tại",
        );
      } else if (numbersDateToNow >= 0) {
        Navigator.pushReplacementNamed(
          context,
          NhatkyScreenV2.routeName,
          arguments: date,
        );
      } else {
        showToast(
          context,
          "Bạn chỉ có thể chỉnh sửa ngày hiện tại hoặc ngày trước đó",
        );
      }
    }

    return CircleAvatar(
      radius: size.width * 0.29,
      backgroundColor: calendarModal[indexModal].circle2,
      child: CircleAvatar(
        radius: size.width * 0.27,
        backgroundColor: calendarModal[indexModal].circle1,
        child: Container(
          height: size.width * 0.5,
          width: size.width * 0.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                calendarModal[indexModal].beginColor,
                calendarModal[indexModal].endColor,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(400),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BuildText(
                text: 'Chu kỳ\nKinh nguyệt',
                style: 14.text400,
                textAlign: TextAlign.center,
                color: whiteColor,
              ),
              BuildText(
                text: dayOfChuKi == 0
                    ? 'Không rõ'
                    : 'Ngày thứ ${dayOfChuKi.toString()}',
                style: 22.text700,
                textAlign: TextAlign.center,
                color: whiteColor,
              ),
              InkWell(
                onTap: () => handleNextClick(),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(30.r)),
                  child: BuildText(
                    text: 'Chỉnh sửa',
                    style: 12.text700,
                    color: calendarModal[indexModal].textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
