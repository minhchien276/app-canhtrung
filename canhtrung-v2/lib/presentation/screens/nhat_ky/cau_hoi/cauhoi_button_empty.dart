// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/enum/nhatky_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/cau_hoi.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_nhatky.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/cau_hoi/cauhoi_checklist.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/cau_hoi/cauhoi_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/cau_hoi/cauhoi_radio.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class CauHoiButtonEmpty extends StatelessWidget {
  final int index;
  const CauHoiButtonEmpty({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 50,
      decoration: BoxDecoration(
        //color: Colors.blue,
        border: Border.all(color: const Color(0xfffd6f8d)),
        borderRadius: BorderRadius.circular(15),
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
            children: [
              Expanded(
                flex: 10,
                child: TitleText(
                  text: listCauHoi[index].noiDung,
                  fontWeight: FontWeight.w600,
                  size: 14,
                  color: Color(0xfffd6f8e),
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/icons/plus.png',
                  scale: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
