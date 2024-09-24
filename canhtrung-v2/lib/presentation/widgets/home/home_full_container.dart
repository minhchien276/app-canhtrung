// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Phần container box chiếm cả chiều ngang màn hình
class HomeFullContainer extends StatelessWidget {
  final String title;
  final String sub;
  final String image;
  final Color fromColor;
  final Color toColor;
  final Color textColor;
  final Alignment directFrom;
  final Alignment directTo;
  final BoxShadow? shadow;
  const HomeFullContainer({
    Key? key,
    required this.title,
    required this.sub,
    required this.image,
    required this.fromColor,
    required this.toColor,
    required this.textColor,
    required this.directFrom,
    required this.directTo,
    this.shadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        boxShadow: shadow != null ? [shadow!] : null,
        gradient: LinearGradient(
          begin: directFrom,
          end: directTo,
          colors: [
            fromColor,
            toColor,
          ],
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Image.asset(image, height: 50.h),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuildText(
                  text: title,
                  style: 12.text700,
                  color: textColor,
                  maxLines: 2,
                ),
                4.verticalSpace,
                BuildText(
                  text: sub,
                  style: 10.text500,
                  color: textColor,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
