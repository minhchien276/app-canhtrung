// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_nhatky.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_cubit.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/nhatky_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart'; // {}

class CauHoiChecklist extends StatefulWidget {
  final int titleId;
  const CauHoiChecklist({
    Key? key,
    required this.titleId,
  }) : super(key: key);

  @override
  State<CauHoiChecklist> createState() => _CauHoiChecklistState();
}

class _CauHoiChecklistState extends State<CauHoiChecklist> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NhatKyCubit>().state;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 200 +
              state.answers[widget.titleId].detailTitle.length *
                  36, // chua responsive
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.transparent),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: TitleText(
                      text: question[widget.titleId].title.toString(),
                      fontWeight: FontWeight.w600,
                      size: 18,
                      color: Palette.textColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //    data[widget.titleId].title.toString(),
                  const Divider(color: Palette.textColor, height: 0),
                  SizedBox(
                    height:
                        state.answers[widget.titleId].detailTitle.length * 36,
                    child: Column(
                      children: List.generate(
                        state.answers[widget.titleId].detailTitle.length,
                        (index) => Expanded(
                          child: Container(
                            height: 36,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Theme(
                              data: ThemeData(
                                unselectedWidgetColor: Palette.textColor,
                                checkboxTheme: CheckboxThemeData(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.5),
                                  ),
                                ),
                              ),
                              child: CheckboxListTile(
                                side: BorderSide(
                                  color: Palette.textColor,
                                  width: 2,
                                ),
                                // activeColor: Colors.blue,
                                activeColor: Palette.textColor,
                                value: state
                                    .answers[widget.titleId].checkbox[index],
                                title: TitleText(
                                  text: state.answers[widget.titleId]
                                      .detailTitle[index],
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                  color: Palette.text,
                                ),
                                onChanged: (value) => context
                                    .read<NhatKyCubit>()
                                    .setCheckboxValue(
                                        widget.titleId, index, state.luongkinh),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              NhatKyButton(textButton: 'Xác nhận'),
              const SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}
