import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';

class ConfirmButton extends StatelessWidget {
  final WidgetStateProperty<Size>? fixedSize;
  final WidgetStateProperty<TextStyle>? textStyle;
  final String text;
  const ConfirmButton({
    super.key,
    required this.text,
    this.fixedSize,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              rose600,
              rose500,
            ],
          ),
          borderRadius: BorderRadius.circular(38),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.1),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ]),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ButtonStyle(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(38),
            ),
          ),
          elevation: WidgetStatePropertyAll(0),
          fixedSize: fixedSize,
          //foregroundColor: WidgetStatePropertyAll(roseTitleText),
          textStyle: textStyle,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
