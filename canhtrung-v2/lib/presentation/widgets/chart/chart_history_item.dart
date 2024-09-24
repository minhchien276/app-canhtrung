// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:flutter_ovumb_app_version1/logic/chart/chart_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/chart/chart_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

import '../../utils/color.dart';

//đây item thông số của mỗi lần test để hiện ra trong listview ở phần biểu đồ
class ChartHistoryItem extends StatelessWidget {
  final ChartLHData ketQuaTest;
  final int index;
  const ChartHistoryItem({
    Key? key,
    required this.ketQuaTest,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(6),
      ),
      height: 35,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: BuildText(
                text: convertDateTimeChart(ketQuaTest.time),
                style: 12.text400,
                color: grey700,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: BuildText(
                text: ketQuaTest.time.toTime(),
                style: 12.text400,
                color: grey700,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: BuildText(
                text: checkLH(ketQuaTest.y),
                style: 12.text400,
                color: grey700,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: BuildText(
                text: index.toString(),
                style: 12.text400,
                color: grey700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
