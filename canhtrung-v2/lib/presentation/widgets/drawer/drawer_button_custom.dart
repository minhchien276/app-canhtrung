// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerButtonCustom extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  const DrawerButtonCustom({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(icon, scale: 3, color: rose400),
                12.horizontalSpace,
                BuildText(
                  text: title,
                  style: 13.text600,
                  color: rose400,
                ),
              ],
            ),
            Image.asset(
              IconApp.next,
              scale: 3,
            ),
          ],
        ),
      ),
    );
  }
}
