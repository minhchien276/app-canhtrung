import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_nhatky.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_cubit.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/nhatky_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class CauHoiRadio extends StatefulWidget {
  final int titleId;
  const CauHoiRadio({super.key, required this.titleId});

  @override
  State<CauHoiRadio> createState() => _CauHoiRadioState();
}

class _CauHoiRadioState extends State<CauHoiRadio> {
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
              answer[widget.titleId].detailTitle.length * 36, // chua responsive
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.transparent),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Stack(
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
                  Container(
                    height:
                        (36 * state.answers[widget.titleId].detailTitle.length)
                            .toDouble(),
                    child: Column(
                      children: List.generate(
                        answer[widget.titleId].detailTitle.length,
                        (index) => Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: RadioListTile(
                              autofocus: true,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                color: Palette.textColor,
                              )),
                              fillColor: WidgetStateColor.resolveWith(
                                  (states) => Palette.textColor),
                              activeColor: Palette.textColor,
                              title: TitleText(
                                text: state
                                    .answers[widget.titleId].detailTitle[index],
                                fontWeight: FontWeight.w600,
                                size: 14,
                                color: Palette.text,
                              ),
                              groupValue: state.answers[widget.titleId].data,
                              value: state
                                  .answers[widget.titleId].detailTitle[index],
                              onChanged: (value) => context
                                  .read<NhatKyCubit>()
                                  .setRadioValue(
                                      widget.titleId, index, state.luongkinh),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: NhatKyButton(textButton: 'Xác nhận'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
