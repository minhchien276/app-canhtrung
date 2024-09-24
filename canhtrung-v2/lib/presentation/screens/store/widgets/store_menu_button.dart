import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreMenuButton extends StatelessWidget {
  const StoreMenuButton({
    super.key,
    required this.title,
    required this.image,
  });

  final String title;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60.h,
          width: 60.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Color(0xffFFF1F3),
          ),
          child: Image.asset(
            image,
            scale: 3.5,
          ),
        ),
        4.verticalSpace,
        BuildText(
          text: title,
          style: 10.text600,
          color: grey500,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
