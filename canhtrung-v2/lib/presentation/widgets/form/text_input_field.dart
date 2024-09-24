// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextInputField extends StatefulWidget {
  String name;
  String iconUrl;
  TextEditingController controller;
  bool? enabled;
  TextInputType? textInputType;
  List<TextInputFormatter>? formatter;
  int? maxLength;
  TextInputField({
    Key? key,
    required this.name,
    required this.iconUrl,
    required this.controller,
    this.enabled,
    this.textInputType,
    this.formatter,
    this.maxLength,
  }) : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late FocusNode _focus;

  @override
  void initState() {
    _focus = FocusNode();
    _focus.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: grey100,
            blurRadius: 10,
            spreadRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        enabled: widget.enabled ?? true,
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        focusNode: _focus,
        cursorColor: rose400,
        keyboardType: widget.textInputType,
        inputFormatters: widget.formatter,
        maxLength: widget.maxLength,
        style: 16.text600.copyWith(color: _focus.hasFocus ? rose400 : grey400),
        onTapOutside: (event) {
          _focus.unfocus();
        },
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          focusColor: rose400,
          prefixIcon: Padding(
            padding: EdgeInsets.all(20.h),
            child: Image.asset(
              widget.iconUrl,
              color: _focus.hasFocus ? rose400 : grey400,
            ),
          ),
          prefixIconColor: grey400,
          hintText: widget.name,
          hintStyle: 14.text500.copyWith(color: grey400),
          filled: true,
          fillColor: whiteColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              width: 0,
              color: whiteColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
