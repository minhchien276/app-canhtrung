import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_nhatky.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_cubit.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/nhatky_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class LuongKinhRadio extends StatelessWidget {
  const LuongKinhRadio({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NhatKyCubit, NhatKyState>(
      builder: (context, state) {
        return MediaQuery(
          data:
              MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              height: 320, // chua responsive
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: TitleText(
                          text: questionLuongKinh.title.toString(),
                          fontWeight: FontWeight.w600,
                          size: 18,
                          color: Palette.textColor,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      //    data[widget.titleId].title.toString(),
                      const Divider(color: Palette.textColor, height: 0),
                      SizedBox(
                        height: (36 * state.listLuongkinh.detailTitle.length)
                            .toDouble(),
                        child: Column(
                          children: List.generate(
                            state.listLuongkinh.detailTitle.length,
                            (index) => Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 20),
                                child: RadioListTile<String>(
                                  autofocus: true,
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: Palette.textColor,
                                  fillColor: WidgetStateColor.resolveWith(
                                      (states) => Palette.textColor),
                                  title: TitleText(
                                    text:
                                        state.listLuongkinh.detailTitle[index],
                                    fontWeight: FontWeight.w600,
                                    size: 14,
                                    color: Palette.text,
                                  ),
                                  tileColor: Colors
                                      .transparent, // Màu nền của RadioListTile
                                  selectedTileColor: Colors
                                      .transparent, // Màu nền của RadioListTile khi được chọn
                                  groupValue: state.luongkinh,
                                  value: state.listLuongkinh.detailTitle[index],
                                  onChanged: (value) => context
                                      .read<NhatKyCubit>()
                                      .setLuongKinh(value),
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
      },
    );
  }
}
