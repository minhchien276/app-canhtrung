// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/primary_font.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class KLoaderButton extends StatelessWidget {
  final Size size;
  final String text;
  final bool isLoading;
  final VoidCallback onTap;
  const KLoaderButton({
    Key? key,
    required this.size,
    required this.text,
    this.isLoading = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(rose500),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(38),
        )),
        elevation: WidgetStatePropertyAll(0),
        fixedSize: WidgetStatePropertyAll(size),
        //foregroundColor: WidgetStatePropertyAll(roseTitleText),
        textStyle: WidgetStatePropertyAll(
          PrimaryFont.semibold(16, FontWeight.w600).copyWith(color: whiteColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BuildText(
            text: text,
            style: 16.text600,
            color: whiteColor,
          ),
          if (isLoading) ...[
            const SizedBox(width: 14),
            SizedBox(
              height: 26,
              width: 26,
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                color: whiteColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
