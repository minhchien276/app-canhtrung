// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/enum/nhatky_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_nhatky.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/cau_hoi/cauhoi_checklist.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/cau_hoi/cauhoi_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/cau_hoi/cauhoi_radio.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/nhatky_checkbox.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/nhatky_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/nhatky_radiobutton.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class CauhoiButtonData extends StatelessWidget {
  final int index;
  final NhatKyState state;
  const CauhoiButtonData({
    Key? key,
    required this.index,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        //color: Colors.green,
        border: Border.all(color: const Color(0xfffd6f8d)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Palette.textColor.withOpacity(0.7),
            barrierColor: rose300.withOpacity(0),
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            context: context,
            builder: (context) {
              switch (question[index].type) {
                case NhatKyEnum.radiobutton:
                  return CauHoiRadio(titleId: index);
                case NhatKyEnum.checkbox:
                  return CauHoiChecklist(titleId: index);
                case NhatKyEnum.normal:
                  return CauHoiPicker(titleId: index);
                default:
                  return CauHoiPicker(titleId: index);
              }
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TitleText(
                        text: question[index].title,
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: Color(0xfffd6f8e),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 6),
                      if (question[index].type == NhatKyEnum.radiobutton) ...[
                        NhatKyRadioButton(
                          item: state.answers[index].data.toString(),
                        ),
                      ],
                      if (question[index].type == NhatKyEnum.checkbox) ...[
                        NhatKyCheckBox(
                          titleId: index,
                          state: state,
                        )
                      ],
                      if (question[index].type == NhatKyEnum.normal) ...[
                        NhatKyPicker(
                          temp1: state.answers[index].data[0],
                          temp2: state.answers[index].data[1],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/icons/next_button.png',
                  scale: 3,
                  color: Color(0xfffd6f8e),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
