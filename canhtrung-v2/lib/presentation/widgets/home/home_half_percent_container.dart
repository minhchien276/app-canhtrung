// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'package:flutter_ovumb_app_version1/data/models/calendar/ckkn_display.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class HomePercent extends StatefulWidget {
  final CKKNDisplay ckknDisplay;
  const HomePercent({
    Key? key,
    required this.ckknDisplay,
  }) : super(key: key);

  @override
  State<HomePercent> createState() => _HomePercentState();
}

class _HomePercentState extends State<HomePercent> {
  bool leftShow = false;
  bool rightShow = false;
  bool bothShow = true;

  @override
  Widget build(BuildContext context) {
    final int flexShow = 75;
    final int flexHide = 25;

    Size screenSize = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: bothShow
              ? 2
              : leftShow
                  ? flexShow
                  : flexHide,
          child: InkWell(
            onTap: () {
              setState(() {
                if (!leftShow && !rightShow) {
                  leftShow = true;
                  bothShow = false;
                } else if (rightShow) {
                  rightShow = false;
                  bothShow = true;
                } else {
                  leftShow = false;
                  bothShow = true;
                }
              });
            },
            child: HomeHalfPercentContainer(
              size: screenSize,
              color: rose600,
              backgroundColor: rose100,
              text: widget.ckknDisplay.snkcl.toString(),
              percent: widget.ckknDisplay.kinhPercent,
              titleText: widget.ckknDisplay.kinhPercent == 1
                  ? widget.ckknDisplay.titleKinh[1]
                  : widget.ckknDisplay.titleKinh[0],
              subText: widget.ckknDisplay.kinhPercent == 1
                  ? widget.ckknDisplay.subKinh[1]
                  : widget.ckknDisplay.subKinh[0],
              subTextColor: rose400,
              imageUrl: widget.ckknDisplay.icon1,
              visibleSubText: leftShow,
              visibleTitleText: !rightShow,
            ),
          ),
        ),
        10.horizontalSpace,
        Flexible(
          flex: bothShow
              ? 2
              : leftShow
                  ? flexHide
                  : flexShow,
          child: InkWell(
            onTap: () {
              setState(() {
                if (!rightShow && !leftShow) {
                  rightShow = true;
                  bothShow = false;
                } else if (leftShow) {
                  leftShow = false;
                  bothShow = true;
                } else {
                  rightShow = false;
                  bothShow = true;
                }
              });
            },
            child: HomeHalfPercentContainer(
              size: screenSize,
              color: widget.ckknDisplay.color,
              backgroundColor: widget.ckknDisplay.bgColor,
              text: widget.ckknDisplay.sntcl.toString(),
              percent: widget.ckknDisplay.trungPercent,
              titleText: widget.ckknDisplay.trungPercent == 1
                  ? widget.ckknDisplay.titleTrung[1]
                  : widget.ckknDisplay.titleTrung[0],
              subText: widget.ckknDisplay.trungPercent == 1
                  ? widget.ckknDisplay.subTrung[1]
                  : widget.ckknDisplay.subTrung[0],
              subTextColor: widget.ckknDisplay.color,
              imageUrl: widget.ckknDisplay.icon2,
              visibleSubText: rightShow,
              visibleTitleText: !leftShow,
            ),
          ),
        ),
      ],
    );
  }
}

class HomeHalfPercentContainer extends StatelessWidget {
  const HomeHalfPercentContainer({
    Key? key,
    required this.size,
    required this.color,
    required this.backgroundColor,
    required this.text,
    required this.percent,
    required this.titleText,
    required this.subText,
    required this.subTextColor,
    required this.imageUrl,
    required this.visibleSubText,
    required this.visibleTitleText,
  }) : super(key: key);

  final Size size;
  final Color color;
  final Color backgroundColor;
  final String text;
  final double percent;
  final String titleText;
  final String subText;
  final Color subTextColor;
  final String imageUrl;
  final bool visibleSubText;
  final bool visibleTitleText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50.h,
            width: 50.h,
            child: percent == 1
                ? Image.asset(
                    imageUrl,
                  )
                : CircularPercentIndicator(
                    radius: 22.h,
                    lineWidth: 5,
                    animation: true,
                    percent: percent,
                    center:
                        BuildText(text: text, style: 14.text700, color: color),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: color,
                    backgroundColor: whiteColor,
                  ),
          ),
          Visibility(
            visible: visibleTitleText,
            child: 10.horizontalSpace,
          ),
          Visibility(
            visible: visibleTitleText,
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: visibleTitleText,
                    child: BuildText(
                      text: titleText,
                      style: 12.text700,
                      color: color,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                    ),
                  ),
                  Visibility(
                    visible: visibleSubText,
                    child: BuildText(
                      text: subText,
                      style: 10.text500,
                      color: subTextColor,
                      maxLines: 2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  //SubText(text: subText, size: 12, color: subTextColor)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
