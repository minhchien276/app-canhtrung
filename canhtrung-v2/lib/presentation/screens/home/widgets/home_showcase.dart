// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeShowcase extends StatefulWidget {
  final GlobalKey currentKey;
  final GlobalKey? nextKey;
  final String text;
  final Widget container;
  final bool isFull;
  const HomeShowcase({
    Key? key,
    required this.currentKey,
    this.nextKey,
    this.isFull = false,
    required this.text,
    required this.container,
  }) : super(key: key);

  @override
  State<HomeShowcase> createState() => _HomeShowcaseState();
}

class _HomeShowcaseState extends State<HomeShowcase> {
  @override
  Widget build(BuildContext context) {
    return Showcase.withWidget(
      targetBorderRadius: BorderRadius.circular(14.r),
      disableMovingAnimation: true,
      key: widget.currentKey,
      height: 0,
      width: widget.isFull ? context.width / 2 : context.width / 4,
      container: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: DottedBorder(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
              color: Colors.white,
              strokeWidth: 1,
              borderType: BorderType.RRect,
              radius: Radius.circular(4.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: widget.isFull ? 150.w : 100.w,
                    alignment: Alignment.center,
                    child: BuildText(
                      text: widget.text,
                      style: 12.text500,
                      color: Colors.white,
                      textAlign: TextAlign.start,
                      maxLines: 10,
                    ),
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            ShowCaseWidget.of(context).dismiss();
                          });
                        },
                        child: BuildText(
                          text: 'Bỏ qua',
                          style: 10.text400,
                          color: Colors.white,
                          textDecoration: TextDecoration.underline,
                        ),
                      ),
                      10.horizontalSpace,
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (widget.nextKey != null) {
                              ShowCaseWidget.of(context)
                                  .startShowCase([widget.nextKey!]);
                            } else {
                              ShowCaseWidget.of(context).dismiss();
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Center(
                            child: BuildText(
                              text: 'Tiếp tục',
                              style: 10.text400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 3.h,
            left: 20.w,
            height: 10.h,
            width: 10.h,
            child: Image.asset(
              IconApp.triangle,
              color: whiteColor,
            ),
          ),
        ],
      ),
      child: widget.container,
    );
  }
}
