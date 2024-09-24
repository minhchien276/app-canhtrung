// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class HalfSampleButton extends StatelessWidget {
  final WidgetStateProperty<Size>? fixedSize;
  final TextStyle textStyle;
  final String text;
  final String routeName;
  final Color formColor;
  final Color toColor;
  const HalfSampleButton({
    Key? key,
    this.fixedSize,
    required this.textStyle,
    required this.text,
    required this.routeName,
    required this.formColor,
    required this.toColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              formColor,
              toColor,
            ],
          ),
          borderRadius: BorderRadius.circular(38),
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, routeName);
          },
          style: ButtonStyle(
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(38),
            )),
            elevation: WidgetStatePropertyAll(0),
            fixedSize: fixedSize,
            //foregroundColor: WidgetStatePropertyAll(primaryColorRoseTitleText),
          ),
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
