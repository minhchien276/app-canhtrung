// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_nhatky.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/luong_kinh/luongkinh_radio.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';

class LuongKinhButtonData extends StatelessWidget {
  final NhatKyState state;
  const LuongKinhButtonData({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [
            rose500,
            rose300,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Palette.textColor.withOpacity(0.7),
            barrierColor: rose300.withOpacity(0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(32),
              ),
            ),
            context: context,
            builder: (context) {
              return LuongKinhRadio();
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        state.luongkinh != null
                            ? questionLuongKinh.title
                            : 'Chu kỳ kinh',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: 'Inter'),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 30,
                        child: Container(
                          height: 25,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: whiteColor),
                          ),
                          child: Text(
                            state.luongkinh ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.asset(
                  'assets/icons/next_button.png',
                  scale: 3,
                  color: whiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
