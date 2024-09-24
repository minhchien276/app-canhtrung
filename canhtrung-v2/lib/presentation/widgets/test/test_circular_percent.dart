// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_test.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';

class TestCircularPercent extends StatelessWidget {
  final int conlai;
  final int tong;
  final int index;
  const TestCircularPercent({
    Key? key,
    required this.conlai,
    required this.tong,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percent = tong == 0 ? 0 : conlai / tong;
    return CircularPercentIndicator(
      circularStrokeCap: CircularStrokeCap.round,
      radius: 45.h,
      lineWidth: 10.h,
      percent: percent,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BuildText(
            text: '$conlai Test',
            style: 10.text900,
          ),
          BuildText(
            text: '/$tong Test',
            style: 9.text400,
            color: Palette.text,
          ),
        ],
      ),
      backgroundColor: Color(0xfff2f4f7),
      linearGradient: dataTestPercent[index].progressColor, //mau phan tram
    );
  }
}
