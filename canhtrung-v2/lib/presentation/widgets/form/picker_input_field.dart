// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/question/question_input_scroll_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PickerInputField extends StatefulWidget {
  String name;
  String iconUrl;
  TextEditingController controller;
  bool isClick;
  bool? enabled;
  int beginNumber;
  int endNumber;
  PickerInputField({
    Key? key,
    required this.name,
    required this.iconUrl,
    required this.controller,
    required this.isClick,
    this.enabled,
    required this.beginNumber,
    required this.endNumber,
  }) : super(key: key);

  @override
  State<PickerInputField> createState() => _PickerInputFieldState();
}

class _PickerInputFieldState extends State<PickerInputField> {
  late FocusNode _focus;
  late bool isShow;

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
    return InkWell(
      onTap: () {
        if (widget.controller.text.isEmpty) {
          setState(() {
            widget.controller.text = widget.beginNumber.toString();
          });
        }
        showModalBottomSheet(
          backgroundColor: whiteColor,
          //barrierColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32),
            ),
          ),
          context: context,
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1)),
              child: ScrollPicker(
                itemSelected: widget.controller,
                beginNumber: widget.beginNumber,
                endNumber: widget.endNumber - widget.beginNumber,
                subtext: '',
                initialItem: 30,
              ),
            );
          },
        );
      },
      child: Container(
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
        child: TextField(
          enabled: false,
          controller: widget.controller,
          textAlignVertical: TextAlignVertical.center,
          cursorColor: rose400,
          style:
              16.text600.copyWith(color: _focus.hasFocus ? rose400 : grey400),
          decoration: InputDecoration(
            isDense: true,
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
            contentPadding: EdgeInsets.zero,
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
              borderSide: widget.controller.text.isEmpty && widget.isClick
                  ? const BorderSide(
                      width: 1,
                      color: rose400,
                    )
                  : BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
