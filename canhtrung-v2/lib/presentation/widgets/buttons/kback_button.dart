import 'package:flutter/material.dart';

Widget kBackButton(
  BuildContext context, {
  VoidCallback? onTap,
  Color? color,
}) =>
    IconButton(
      onPressed: onTap ?? () => Navigator.pop(context),
      icon: Image.asset(
        'assets/icons/back_button.png',
        scale: 3,
        color: color,
      ),
    );
