import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/question/question.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/primary_font.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/datetime/datetime_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionDateScrollPicker extends StatefulWidget {
  const QuestionDateScrollPicker({
    super.key,
    required this.context,
    required this.listQuestion,
    required this.date,
  });

  final BuildContext context;
  final List<Question> listQuestion;
  final TextEditingController date;

  @override
  State<QuestionDateScrollPicker> createState() =>
      _QuestionDateScrollPickerState();
}

class _QuestionDateScrollPickerState extends State<QuestionDateScrollPicker> {
  DateTime selectedDate = DateTime.now();
  final _dateTimePicker = DateTimePickerWiget();
  DateTime threeMonthsAgo = DateTime.now().subtract(Duration(days: 90));

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      width: context.width,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Expanded(
            //fit: FlexFit.tight,
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TitleText(
                text: widget.listQuestion[2].title,
                fontWeight: FontWeight.w600,
                size: 18,
                color: grey600,
              ),
            ),
          ),
          Expanded(
            //fit: FlexFit.tight,
            flex: 1,
            child: GestureDetector(
              onTap: () async {
                DateTime? picker = await _dateTimePicker.selectDate(
                  context,
                  firstDate: DateTime.now().subtract(Duration(days: 90)),
                  lastDate: DateTime.now(),
                  initDate: selectedDate,
                );
                if (picker != null && picker != selectedDate) {
                  setState(() {
                    selectedDate = picker;
                    widget.date.text = selectedDate.toString().split(' ')[0];
                  });
                }
              },
              child: TextFormField(
                autovalidateMode: AutovalidateMode.always,
                enabled: false,
                controller: widget.date,
                cursorColor: rose300,
                style: PrimaryFont.medium(16, FontWeight.w500).copyWith(
                  color: grey300,
                ),
                decoration: InputDecoration(
                  suffixIcon: Image.asset(
                    'assets/icons/calendar_icon.png',
                    scale: 3,
                  ),
                  focusColor: rose400,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 35),
                  fillColor: grey25,
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
