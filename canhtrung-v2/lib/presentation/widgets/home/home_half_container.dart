// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/color.dart';

// Phần container box chiếm nửa chiều ngang màn hình
class HomeHalfContainer extends StatelessWidget {
  const HomeHalfContainer({
    Key? key,
    required this.gradientFrom,
    required this.gradientTo,
    required this.title,
    this.sub,
    required this.image,
    required this.beginGradient,
    required this.endGradient,
  }) : super(key: key);

  final Color gradientFrom;
  final Color gradientTo;
  final String title;
  final String? sub;
  final String image;
  final Alignment beginGradient;
  final Alignment endGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: beginGradient,
          end: endGradient,
          colors: [
            gradientFrom,
            gradientTo,
          ],
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildText(
                      text: title,
                      style: 12.text700,
                      textAlign: TextAlign.left,
                      color: whiteColor,
                      maxLines: 2,
                    ),
                    if (sub != null) ...[
                      BuildText(
                        text: sub ?? '',
                        style: 10.text500,
                        color: whiteColor,
                        maxLines: 2,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ],
                ),
              ),
              8.horizontalSpace,
              // Image.asset(image, width: 40.w),
            ],
          ),
          Positioned(
            right: 0,
            child: Image.asset(image, width: 40.w),
          ),
        ],
      ),
    );
  }
}
