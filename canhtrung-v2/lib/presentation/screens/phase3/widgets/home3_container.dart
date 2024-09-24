// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home3Container extends StatelessWidget {
  final String image;
  final String text1;
  final String text2;
  final String text3;
  final String textButton;
  final Color color;
  final VoidCallback? callback;

  const Home3Container({
    Key? key,
    required this.image,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.textButton,
    required this.color,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: callback,
        child: Container(
          padding:
              const EdgeInsets.only(left: 22, right: 22, top: 30, bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.amber,
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
              scale: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildText(
                    text: text1,
                    style: 14.text600,
                    color: Colors.white,
                  ),
                  6.verticalSpace,
                  BuildText(
                    text: text2,
                    style: 14.text600,
                    color: Colors.white,
                  ),
                  6.verticalSpace,
                  BuildText(
                    text: text3,
                    style: 10.text400,
                    color: Colors.white,
                    maxLines: 4,
                  ),
                ],
              ),
              Container(
                height: 35.h,
                decoration: BoxDecoration(
                  color: rose50,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TitleText(
                      text: textButton,
                      fontWeight: FontWeight.w600,
                      size: 14,
                      color: color,
                    ),
                    Image.asset(
                      'assets/icons/next_icon.png',
                      scale: 3,
                      color: color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
