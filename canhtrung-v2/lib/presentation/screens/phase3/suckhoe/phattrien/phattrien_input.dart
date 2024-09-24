// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/constant/bmi_baby.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_phattrien.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/phattriencon.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/home_phase3_chart.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/phattrien/phattrien.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/phattrien/phattrien_chart.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/phattrien/phattrien_drag.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class PhatTrienInput extends StatefulWidget {
  PhatTrienInput({
    Key? key,
  }) : super(key: key);

  @override
  State<PhatTrienInput> createState() => _PhatTrienInputState();
}

class _PhatTrienInputState extends State<PhatTrienInput> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _listenController = TextEditingController();
  TextEditingController _dateController =
      TextEditingController(text: DateTime.now().toString());
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  bool isSave = false;
  bool showHistory = false;
  final StreamController<bool> _swapButtonStream = StreamController.broadcast();
  List<List<String>> titles = [
    ['Nhập dữ liệu', 'Lịch sử phát triển'],
    ['Lịch sử phát triển', 'Hiện tại'],
  ];

  @override
  void initState() {
    _weightController = TextEditingController(text: '11');
    _heightController = TextEditingController(text: '100');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<MilkBloc, MilkState>(
      builder: (context, state) {
        List<ChartData> _weightChartData = [];
        List<ChartData> _heightChartData = [];
        if (state.phatTrienCon.isNotEmpty) {
          _weightController = TextEditingController(
              text: state.phatTrienCon.first.canNang != null
                  ? state.phatTrienCon.first.canNang.toString()
                  : '');
          _heightController = TextEditingController(
              text: state.phatTrienCon.first.chieuCao != null
                  ? state.phatTrienCon.first.chieuCao.toString()
                  : '');
          int index = state.phatTrienCon.length;
          for (int i = 0; i < state.phatTrienCon.length; i++) {
            _weightChartData.add(ChartData(
                index.toString(),
                state.phatTrienCon[i].canNang ?? 0,
                state.phatTrienCon[i].thoiGian));
            _heightChartData.add(ChartData(
                index.toString(),
                state.phatTrienCon[i].chieuCao ?? 0,
                state.phatTrienCon[i].thoiGian));
            index--;
          }
        }
        return Padding(
          padding: const EdgeInsets.only(left: 24),
          child: ListView(
            padding: EdgeInsets.only(top: 30),
            physics: const ClampingScrollPhysics(),
            children: [
              Container(
                alignment: Alignment.topLeft,
                height: 250,
                width: size.width,
                color: Colors.transparent,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      PhatTrienChart(
                        title: 'Cân nặng',
                        color: rose400,
                        chartData: _weightChartData.reversed.toList(),
                        maxValue: 20,
                        dateController: _dateController,
                        con: state.currentBaby,
                        donVi: 'kg',
                      ),
                      const SizedBox(width: 30),
                      PhatTrienChart(
                        title: 'Chiều cao',
                        color: violet400,
                        chartData: _heightChartData.reversed.toList(),
                        maxValue: 150,
                        dateController: _dateController,
                        con: state.currentBaby,
                        donVi: 'cm',
                      ),
                    ],
                  ),
                ),
              ),
              /////
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 10, right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleText(
                      text: titles[showHistory ? 1 : 0][0],
                      fontWeight: FontWeight.w600,
                      size: 16,
                      color: grey700,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          showHistory = !showHistory;
                        });
                      },
                      child: TitleText(
                        text: titles[showHistory ? 1 : 0][1],
                        fontWeight: FontWeight.w500,
                        size: 14,
                        color: rose400,
                      ),
                    ),
                  ],
                ),
              ),
              if (state.currentBaby != null) ...[
                StreamBuilder<bool>(
                  stream: _swapButtonStream.stream,
                  builder: (context, snap) {
                    return SizedBox(
                      child: showHistory
                          ? HomePhase3Chart(
                              phatTrienCon: state.phatTrienCon,
                              bmi: BMIBaby.calculateBMI(
                                      state.phatTrienCon.isNotEmpty
                                          ? state.phatTrienCon.first
                                          : null)
                                  .toString(),
                              listenController: _listenController,
                              maCon: state.currentBaby!.id,
                            )
                          : Container(
                              height: 400,
                              child: Column(
                                children: [
                                  PhattrienDrag(
                                    dataPhatTrien: dataPhatTrien[0],
                                    activeColor: rose600,
                                    normalColor: rose400,
                                    controller: _weightController,
                                    swapButtonStream: _swapButtonStream,
                                  ),
                                  PhattrienDrag(
                                    dataPhatTrien: dataPhatTrien[1],
                                    activeColor: violet600,
                                    normalColor: violet400,
                                    controller: _heightController,
                                    swapButtonStream: _swapButtonStream,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 24, top: 30),
                                    child: KSubmitButton(
                                      size: Size(size.width, 50),
                                      text: snap.hasData
                                          ? 'Xác nhận'
                                          : 'Kiểm tra thể trạng',
                                      onTap: () async {
                                        num? _weight = num.tryParse(
                                            _weightController.text.trim());
                                        num? _height = num.tryParse(
                                            _heightController.text.trim());
                                        if (snap.hasData) {
                                          context
                                              .read<MilkBloc>()
                                              .add(InsertPhattrienEvent(
                                                phatTrienCon: PhatTrienCon(
                                                  maCon: state.currentBaby!.id,
                                                  canNang: _weight,
                                                  chieuCao: _height,
                                                  thoiGian: DateTime.parse(
                                                      _dateController.text),
                                                ),
                                              ));
                                        } else {
                                          context.read<MilkBloc>().add(
                                              SwitchPhatTrienEvent(index: 1));
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
