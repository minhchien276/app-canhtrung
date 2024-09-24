// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/constant/bmi_baby.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_phattrien.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/phattrien/phattrien_arrow.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class PhatTrienChiTiet extends StatefulWidget {
  static const routeName = 'phattrien-chitiet-screen';
  PhatTrienChiTiet({
    Key? key,
  }) : super(key: key);

  @override
  State<PhatTrienChiTiet> createState() => _PhatTrienChiTietState();
}

class _PhatTrienChiTietState extends State<PhatTrienChiTiet> {
  List<BorderRadiusGeometry?> radius = [
    BorderRadius.only(
      topLeft: Radius.circular(10),
      bottomLeft: Radius.circular(10),
    ),
    null,
    null,
    null,
    BorderRadius.only(
      topRight: Radius.circular(10),
      bottomRight: Radius.circular(10),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<MilkBloc, MilkState>(
      builder: (context, state) {
        double? bmi = BMIBaby.calculateBMI(
            state.phatTrienCon.isNotEmpty ? state.phatTrienCon.first : null);
        return Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(top: 30),
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              bmi != null
                  ? Container(
                      height: 455,
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      padding: EdgeInsets.only(top: 30),
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.05),
                          TitleText(
                            text: 'Điểm Thể Trạng Của Bé:',
                            fontWeight: FontWeight.w400,
                            size: 24,
                            color: grey500,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                bmi.ceil().toString(),
                                style: TextStyle(
                                  fontSize: 96,
                                  fontWeight: FontWeight.w700,
                                  foreground: Paint()
                                    ..shader = LinearGradient(
                                      colors: <Color>[
                                        Color(0xffF63D68),
                                        rose300,
                                        // Color(0xffC9687A),
                                      ],
                                    ).createShader(
                                        Rect.fromLTWH(0.0, 0.0, 400.0, 100.0)),
                                ),
                              ),
                            ),
                          ),
                          TitleText(
                            text: 'kg/\u33A1',
                            fontWeight: FontWeight.w500,
                            size: 20,
                            color: grey500,
                          ),
                          SizedBox(height: size.height * 0.05),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      5,
                                      (index) => PhattrienArrow(
                                        color:
                                            dataPhatTrienChiTiet[index].color,
                                        type: BMIBaby.evaluateBMI(
                                            state.currentBaby, bmi),
                                        index: index,
                                        borderRadius: radius[index],
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TitleText(
                                          text: 'Thể trạng của bé ở mức:',
                                          fontWeight: FontWeight.w400,
                                          size: 14,
                                          color: grey700,
                                        ),
                                        SizedBox(width: 6),
                                        TitleText(
                                          text: dataPhatTrienChiTiet[
                                                  BMIBaby.evaluateBMI(
                                                      state.currentBaby, bmi)]
                                              .thetrang,
                                          fontWeight: FontWeight.w700,
                                          size: 14,
                                          color: dataPhatTrienChiTiet[
                                                  BMIBaby.evaluateBMI(
                                                      state.currentBaby, bmi)]
                                              .color,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 450,
                      child: Center(
                        child: TitleText(
                          text: 'Chưa có dữ liệu',
                          fontWeight: FontWeight.w400,
                          size: 24,
                          color: grey500,
                        ),
                      ),
                    ),
              Expanded(
                flex: 6,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(top: 30),
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: const ButtonStyle(
                          overlayColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          shadowColor:
                              WidgetStatePropertyAll(Colors.transparent),
                        ),
                        child: TitleText(
                          text: 'Quay lại',
                          fontWeight: FontWeight.w600,
                          size: 16,
                          color: rose500,
                        ),
                        onPressed: () {
                          context
                              .read<MilkBloc>()
                              .add(SwitchPhatTrienEvent(index: 0));
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        alignment: Alignment.center,
                        height: 50,
                        width: size.width * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              rose400,
                              rose600,
                            ],
                          ),
                        ),
                        child: SizedBox(
                          width: size.width,
                          child: ElevatedButton(
                            style: const ButtonStyle(
                              overlayColor:
                                  WidgetStatePropertyAll(Colors.transparent),
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.transparent),
                              shadowColor:
                                  WidgetStatePropertyAll(Colors.transparent),
                            ),
                            child: TitleText(
                              text: 'Xác nhận',
                              fontWeight: FontWeight.w600,
                              size: 16,
                              color: rose25,
                            ),
                            onPressed: () {
                              context
                                  .read<MilkBloc>()
                                  .add(SwitchPhatTrienEvent(index: 0));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

//   {}   []
class TheTrang {
  String thetrang;
  TheTrang(this.thetrang);
}

List<TheTrang> thetrangList = [
  TheTrang('Bình thường'),
];
