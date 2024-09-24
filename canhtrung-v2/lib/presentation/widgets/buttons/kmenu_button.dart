import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';

Widget kMenuButton(
  BuildContext context, {
  VoidCallback? onTap,
  Color? color,
}) =>
    IconButton(
      onPressed: onTap,
      icon: Image.asset(
        'assets/buttons/menu.png',
        scale: 3,
        color: color ?? rose25,
      ),
    );
