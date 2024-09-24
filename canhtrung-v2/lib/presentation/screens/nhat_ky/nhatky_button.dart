// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';

class NhatKyButton extends StatelessWidget {
  final String textButton;
  final VoidCallback? onTap;
  const NhatKyButton({
    Key? key,
    required this.textButton,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DecoratedBox(
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
              ],
            ),
            child: ElevatedButton(
              onPressed: onTap ?? () => Navigator.pop(context),
              style: ButtonStyle(
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(38),
                  ),
                ),
                elevation: WidgetStatePropertyAll(0),
                fixedSize: WidgetStatePropertyAll(Size(size.width, 50)),
                //foregroundColor: WidgetStatePropertyAll(roseTitleText),
              ),
              child: Text(
                textButton,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
