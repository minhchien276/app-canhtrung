// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/primary_font.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class KSubmitButton extends StatelessWidget {
  final Size size;
  final String text;
  final String? icon;
  final Color? bgColor;
  final Color? textColor;
  final BorderSide border;
  final double? borderRadius;
  final VoidCallback onTap;
  const KSubmitButton({
    Key? key,
    required this.size,
    required this.text,
    this.icon,
    this.bgColor,
    this.textColor,
    this.borderRadius,
    this.border = BorderSide.none,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            bgColor ?? rose600,
            bgColor ?? rose400,
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 38),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(38), side: border)),
          elevation: WidgetStatePropertyAll(0),
          fixedSize: WidgetStatePropertyAll(size),
          textStyle: WidgetStatePropertyAll(
            PrimaryFont.semibold(16, FontWeight.w600)
                .copyWith(color: whiteColor),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Image.asset(icon!, scale: 3, color: textColor),
              14.horizontalSpace,
            ],
            BuildText(
              text: text,
              style: 15.text600,
              color: textColor ?? whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
