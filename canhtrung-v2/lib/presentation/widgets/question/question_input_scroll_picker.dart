// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_nhatky.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//Nút input thường
// ignore: must_be_immutable
class QuestionInputScrollPicker extends StatefulWidget {
  final String text;
  TextEditingController controller;
  final int beginNumber;
  final int endNumber;
  final String subtext;
  final int? initialItem;
  QuestionInputScrollPicker({
    Key? key,
    required this.text,
    required this.controller,
    required this.beginNumber,
    required this.endNumber,
    required this.subtext,
    this.initialItem,
  }) : super(key: key);

  @override
  State<QuestionInputScrollPicker> createState() =>
      _QuestionInputScrollPickerState();
}

class _QuestionInputScrollPickerState extends State<QuestionInputScrollPicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      height: 90.h,
      width: context.width,
      child: Column(
        children: [
          Expanded(
            //fit: FlexFit.tight,
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TitleText(
                text: widget.text,
                fontWeight: FontWeight.w600,
                size: 18,
                color: grey600,
              ),
            ),
          ),
          Expanded(
            //fit: FlexFit.tight,
            flex: 1,
            child: InkWell(
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
                    return ScrollPicker(
                      itemSelected: widget.controller,
                      beginNumber: widget.beginNumber,
                      endNumber: widget.endNumber - widget.beginNumber,
                      subtext: widget.subtext,
                      initialItem: 0,
                    );
                  },
                );
              },
              child: TextFormField(
                enabled: false,
                controller: widget.controller,
                keyboardType: TextInputType.number,
                //controller: widget.controller,
                cursorColor: rose300,
                decoration: InputDecoration(
                  focusColor: rose400,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 35),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(38),
                    borderSide: const BorderSide(
                      width: 0,
                      color: grey25,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(38),
                    borderSide: const BorderSide(
                      color: rose300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(38),
                    borderSide: const BorderSide(
                      color: grey300,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ScrollPicker extends StatefulWidget {
  TextEditingController itemSelected;
  int beginNumber;
  int endNumber;
  String subtext;
  int initialItem;
  ScrollPicker({
    Key? key,
    required this.itemSelected,
    required this.beginNumber,
    required this.endNumber,
    required this.subtext,
    required this.initialItem,
  }) : super(key: key);

  @override
  State<ScrollPicker> createState() => _ScrollPickerState();
}

class _ScrollPickerState extends State<ScrollPicker> {
  late FixedExtentScrollController controller;
  @override
  void initState() {
    if (widget.itemSelected.text.isEmpty) {
      controller = FixedExtentScrollController(initialItem: widget.initialItem);
    } else {
      controller = FixedExtentScrollController(
          initialItem:
              int.parse(widget.itemSelected.text) - widget.beginNumber);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 4.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: grey400,
                  borderRadius: BorderRadius.circular(32),
                  // color: Colors.white
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300.h,
          child: ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: ListWheelScrollView(
              overAndUnderCenterOpacity: 0.1,
              controller: controller,
              physics: const FixedExtentScrollPhysics(),
              itemExtent: 50.w,
              children: List.generate(widget.endNumber, (index) {
                return DayPickerIntNumber(
                  intNumber: (index + widget.beginNumber),
                  subtext: widget.subtext,
                );
              }),
              onSelectedItemChanged: (value) {
                setState(() {
                  widget.itemSelected.text =
                      (value + widget.beginNumber).toString();
                  controller = FixedExtentScrollController(
                      initialItem: int.parse(widget.itemSelected.text));
                });
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: KSubmitButton(
            size: Size(context.width, 50.h),
            text: 'Xác nhận',
            onTap: () => context.pop(),
          ),
        ),
        30.verticalSpace,
      ],
    );
  }
}
