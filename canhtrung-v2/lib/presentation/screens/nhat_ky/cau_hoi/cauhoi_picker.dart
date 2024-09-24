// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_nhatky.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_cubit.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/nhatky_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class CauHoiPicker extends StatefulWidget {
  final int titleId;
  CauHoiPicker({
    Key? key,
    required this.titleId,
  }) : super(key: key);

  @override
  State<CauHoiPicker> createState() => _CauHoiPickerState();
}

class _CauHoiPickerState extends State<CauHoiPicker> {
  late FixedExtentScrollController _controller;
  late FixedExtentScrollController _controllerDouble;
  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController();
    _controllerDouble = FixedExtentScrollController();
  }

  initValue(NhatKyState state) {
    if (state.answers[0].data != null) {
      int temp1 = int.parse(state.answers[0].data[0]);
      int temp2 = int.parse(state.answers[0].data[1]);
      _controller = FixedExtentScrollController(initialItem: temp1 - 35);
      _controllerDouble = FixedExtentScrollController(initialItem: temp2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = context.watch<NhatKyCubit>().state;
    initValue(state);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.transparent),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
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
              const Divider(color: Palette.textColor, height: 0),
              //phần cuộn chọn
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 120,
                      child: Container(
                        color: Palette.textColor.withOpacity(0.2),
                        width: size.width,
                        height: 50,
                      ),
                    ),
                    SizedBox(
                      //color: Colors.greenAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                            child: ListWheelScrollView.useDelegate(
                              controller: _controller,
                              itemExtent: 50,
                              //perspective: 0.005,
                              diameterRatio: 1.2,
                              physics: const FixedExtentScrollPhysics(),
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 6,
                                builder: (context, index) {
                                  return DetailsPickerIntNumber(
                                    intNumber: index,
                                  );
                                },
                              ),
                              onSelectedItemChanged: (value1) {
                                int res = value1 + 35;
                                context.read<NhatKyCubit>().setPickerValue(
                                    res.toString(),
                                    widget.titleId,
                                    0,
                                    state.luongkinh);
                              },
                            ),
                          ),
                          const SizedBox(width: 50),
                          SizedBox(
                            width: 70,
                            child: ListWheelScrollView.useDelegate(
                                controller: _controllerDouble,
                                itemExtent: 50,
                                perspective: 0.005,
                                diameterRatio: 1.2,
                                physics: const FixedExtentScrollPhysics(),
                                childDelegate: ListWheelChildBuilderDelegate(
                                  childCount: 10,
                                  builder: (context, index) {
                                    return DetailsPickerDoubleNumber(
                                      doubleNumber: index,
                                    );
                                  },
                                ),
                                onSelectedItemChanged: (value) {
                                  context.read<NhatKyCubit>().setPickerValue(
                                      value.toString(),
                                      widget.titleId,
                                      1,
                                      state.luongkinh);
                                }),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      height: 100,
                      child: Container(
                        height: 50,
                        width: size.width,
                        //color: rose600.withOpacity(0.1),
                        decoration: BoxDecoration(
                          // color: Colors.white
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(1),
                              Colors.white.withOpacity(0.2),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -1,
                      height: 100,
                      child: Container(
                        height: 50,
                        width: size.width,
                        //color: rose600.withOpacity(0.1),
                        decoration: BoxDecoration(
                          //color: Colors.red
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.white.withOpacity(1),
                              Colors.white.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              NhatKyButton(textButton: 'Xác nhận'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
