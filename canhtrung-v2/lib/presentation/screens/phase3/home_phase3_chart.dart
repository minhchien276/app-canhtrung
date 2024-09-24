// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/enum/choan_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/phattriencon.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_timeline.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/bieudo_widget.dart';

class HomePhase3Chart extends StatelessWidget {
  final List<PhatTrienCon> phatTrienCon;
  final String bmi;
  TextEditingController listenController;
  final int maCon;
  HomePhase3Chart({
    Key? key,
    required this.phatTrienCon,
    required this.listenController,
    required this.maCon,
    required this.bmi,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double listHeight = phatTrienCon.length * 80;
    double maxHeight = 200 + listHeight;

    return SizedBox(
      height: maxHeight,
      child: ListView(
        padding: const EdgeInsets.only(top: 0),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            height: 110,
            margin: const EdgeInsets.only(right: 25),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(1, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  width: size.width,
                  height: 100,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BieuDoWidget(
                          title: 'Cân nặng',
                          number: phatTrienCon.isNotEmpty
                              ? phatTrienCon.first.canNang
                              : null,
                          descripble: 'kg',
                        ),
                        VerticalDivider(color: grey300, thickness: 1),
                        BieuDoWidget(
                          title: 'Chiều cao',
                          number: phatTrienCon.isNotEmpty
                              ? phatTrienCon.first.chieuCao
                              : null,
                          descripble: 'cm',
                        ),
                        VerticalDivider(color: grey300, thickness: 1),
                        BieuDoWidget(
                          title: 'BMI',
                          number: bmi == '' ? null : double.tryParse(bmi),
                          descripble: 'kg/m2',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              right: 24,
            ),
            height: listHeight,
            width: size.width,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: phatTrienCon.length,
              itemBuilder: (context, index) {
                return ChoAnTimeline(
                  maCon: maCon,
                  choAnEnum: ChoAnEnum.phattrien,
                  time: 'Tháng ${phatTrienCon.length - index}',
                  ml: null,
                  index: index,
                  date: phatTrienCon[index].thoiGian,
                  last: (phatTrienCon.length - 1) == index,
                  canNang: phatTrienCon[index].canNang,
                  chieuCao: phatTrienCon[index].chieuCao,
                  timelines: [
                    TimelineDetail(
                        text: '${phatTrienCon[index].canNang.toString()} kg'),
                    TimelineDetail(
                        text: '${phatTrienCon[index].chieuCao.toString()} cm'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
