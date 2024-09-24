import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/luong_kinh/luongkinh_radio.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';

class LuongKinhButtonEmpty extends StatelessWidget {
  const LuongKinhButtonEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Chu kỳ kinh',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          fontFamily: 'Inter'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Thông tin chu kỳ kinh của bạn chưa được hoàn thành',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Image.asset(
                    'assets/icons/next_button.png',
                    scale: 3,
                    color: whiteColor,
                  ), //neu
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
