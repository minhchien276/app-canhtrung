// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Phần container box chiếm cả chiều ngang màn hình
class HomeFullContainer1 extends StatelessWidget {
  final String title;
  final String sub;
  final String image;
  final Color fromColor;
  final Color toColor;
  final Color textColor;
  final Alignment directFrom;
  final Alignment directTo;
  const HomeFullContainer1({
    Key? key,
    required this.title,
    required this.sub,
    required this.image,
    required this.fromColor,
    required this.toColor,
    required this.directFrom,
    required this.directTo,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          padding: EdgeInsets.all(12.h),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 12,
                offset: Offset(1, 5),
              ),
            ],
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
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
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
              ),
              4.horizontalSpace,
              Image.asset(image, height: 50.h),
            ],
          ),
        ),
      ],
    );
  }
}
