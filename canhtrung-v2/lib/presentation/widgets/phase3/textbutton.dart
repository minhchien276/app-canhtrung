import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Textbutton extends StatelessWidget {
  String text;
  Color textColor;
  FontWeight fontWeight;
  VoidCallback onPressed;
  Textbutton({
    super.key,
    required this.text,
    required this.textColor,
    required this.fontWeight,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 35,
      child: TextButton(
        style: ButtonStyle(
          overlayColor: WidgetStatePropertyAll(Colors.transparent),
          shadowColor: WidgetStatePropertyAll(Colors.transparent),
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: fontWeight,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
