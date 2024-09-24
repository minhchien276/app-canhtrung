// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_timeline.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/datetime/datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:flutter_ovumb_app_version1/data/enum/choan_enum.dart';
import 'package:flutter_ovumb_app_version1/data/handle/choan_chart.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/choan.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/bieudo_widget.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class ChoAnHistory extends StatefulWidget {
  static const routeName = 'choan-history-screen';
  const ChoAnHistory({
    Key? key,
  }) : super(key: key);

  @override
  State<ChoAnHistory> createState() => _ChoAnHistoryState();
}

class _ChoAnHistoryState extends State<ChoAnHistory> {
  double maxValue = 100;
  DateTime? date = DateTime.now();
  DateTimePickerWiget _pickerWiget = DateTimePickerWiget();

  String _buildTime(DateTime date) {
    DateFormat format = DateFormat('HH:mm');
    return format.format(date);
  }

  List<TimelineDetail> _buildTimeline(ChoAn choAn, ChoAnEnum choAnEnum) {
    if (choAnEnum == ChoAnEnum.bume) {
      List<TimelineDetail> timelines = [];
      if (choAn.vuTrai != null && choAn.vuTrai != 0) {
        timelines.add(TimelineDetail(text: 'Ngực trái'));
      }
      if (choAn.vuPhai != null && choAn.vuPhai != 0) {
        timelines.add(TimelineDetail(text: 'Ngực phải'));
      }
      return timelines;
    } else if (choAnEnum == ChoAnEnum.suacongthuc) {
      return [TimelineDetail(text: choAn.tenLoaiChoAn!)];
    } else if (choAnEnum == ChoAnEnum.andam) {
      List<TimelineDetail> timelines = [];
      List<String> list = choAn.loaiThucPham!.split(';');
      list.forEach((e) {
        if (e != '') {
          timelines.add(TimelineDetail(text: e));
        }
      });
      return timelines;
    }
    return [];
  }

  List<String> _buildDonVi(ChoAnEnum choAnEnum) {
    return choAnEnum == ChoAnEnum.andam ? ['g', 'g/lần'] : ['ml', 'ml/lần'];
  }

  void _fetchHistoryByDate(DateTime date, ChoAnEnum choAnEnum) {
    if (choAnEnum == ChoAnEnum.bume) {
      context.read<MilkBloc>().add(
            GetChoAnHistoryEvent(
              choAnEnum: ChoAnEnum.bume,
              date: date,
              maLoaiChoAn: [getMaChoAn(ChoAnEnum.bume)],
            ),
          );
    } else if (choAnEnum == ChoAnEnum.suacongthuc) {
      context.read<MilkBloc>().add(
            GetChoAnHistoryEvent(
              choAnEnum: ChoAnEnum.suacongthuc,
              date: date,
              maLoaiChoAn: [
                getMaChoAn(ChoAnEnum.suacongthuc),
                getMaChoAn(ChoAnEnum.suame),
              ],
            ),
          );
    } else if (choAnEnum == ChoAnEnum.andam) {
      context.read<MilkBloc>().add(
            GetChoAnHistoryEvent(
              choAnEnum: ChoAnEnum.andam,
              date: date,
              maLoaiChoAn: [
                getMaChoAn(ChoAnEnum.andam),
              ],
            ),
          );
    }
  }

  int _parseMinutes(num value) {
    int minutes = value.toInt() * 10;
    int m = (minutes / 60).round();
    return m;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<MilkBloc, MilkState>(
      builder: (context, state) {
        return Container(
          width: size.width,
          height: size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(top: 30),
              children: [
                _chart(size, state),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleText(
                      text: 'Lịch sử cho ăn',
                      fontWeight: FontWeight.w600,
                      size: 16,
                      color: grey700,
                    ),
                    InkWell(
                      onTap: () async {
                        date = await _pickerWiget.selectDate(
                          context,
                          initDate: date != null ? date! : DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(Duration(days: 1000)),
                          lastDate: DateTime.now(),
                        );
                        setState(() {});
                        if (date != null) {
                          _fetchHistoryByDate(
                              date!.formatStartDate(), state.choAnEnum);
                        }
                      },
                      child: TitleText(
                        text: date != null
                            ? (checkTheSameDay(date!, DateTime.now())
                                ? 'Hôm nay'
                                : convertDateTime(date!))
                            : 'Hôm nay',
                        fontWeight: FontWeight.w500,
                        size: 14,
                        color: rose400,
                      ),
                    ),
                  ],
                ),
                14.verticalSpace,
                _history(state, size)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chart(
    Size size,
    MilkState state,
  ) =>
      Container(
        height: 230,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleText(
                                text: 'Lịch sử cho ăn',
                                fontWeight: FontWeight.w500,
                                size: 14),
                            Row(
                              children: [
                                TitleText(
                                    text: 'Số ngày (ml-gam)',
                                    fontWeight: FontWeight.w500,
                                    color: grey400,
                                    size: 10),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 9,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          width: 40,
                          height: 40,
                          child: IconButton(
                            icon: Image.asset(
                              'assets/icons/settings.png',
                              scale: 2.5,
                            ),
                            onPressed: () => context
                                .read<MilkBloc>()
                                .add(BackChoAnInputEvent()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 170,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  axisLine: AxisLine(width: 0),
                  majorTickLines: MajorTickLines(width: 0),
                  minorTickLines: MinorTickLines(width: 0, size: 0),
                  minorGridLines:
                      MinorGridLines(width: 0, color: Colors.transparent),
                  majorGridLines: MajorGridLines(width: 0),
                  axisLabelFormatter: (AxisLabelRenderDetails args) {
                    late String text;
                    late TextStyle textStyle;
                    text = '${args.text}';
                    textStyle = TextStyle(
                      color: grey400,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    );
                    return ChartAxisLabel(text, textStyle);
                  },
                  arrangeByIndex: false,
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  opposedPosition: false,
                  majorGridLines: MajorGridLines(width: 0),
                  axisLine: AxisLine(width: 0),
                  majorTickLines: MajorTickLines(width: 0),
                  minorTickLines: MinorTickLines(width: 0, size: 0),
                  minorGridLines:
                      MinorGridLines(width: 0, color: Colors.transparent),
                ),
                axes: [
                  NumericAxis(
                    majorGridLines: MajorGridLines(width: 0),
                    name: 'yAxis',
                    opposedPosition: true,
                  )
                ],
                series: <ChartSeries<ChartDataChoAn, String>>[
                  ColumnSeries<ChartDataChoAn, String>(
                    width: 0.1,
                    borderRadius: BorderRadius.circular(4),
                    dataSource: state.chartDataChoAn,
                    xValueMapper: (ChartDataChoAn data, _) => data.x,
                    yValueMapper: (ChartDataChoAn data, _) => data.y,
                    pointColorMapper: (ChartDataChoAn data, _) => data.color,
                    dataLabelMapper: (datum, index) =>
                        state.chartDataChoAn[index].y.toString(),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(
                        fontSize: 8,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: grey500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _history(
    MilkState state,
    Size size,
  ) =>
      SizedBox(
        height: state.choAnHistory.length * 100 + 200,
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              height: 110,
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
                          Expanded(
                            child: BieuDoWidget(
                              title: 'Số lần',
                              number: state.choAnHistory.length,
                              descripble: 'lần',
                            ),
                          ),
                          VerticalDivider(color: grey300, thickness: 1),
                          Expanded(
                            child: BieuDoWidget(
                              title: 'Tổng',
                              number: ChoanChart().getTotal(
                                  state.choAnHistory, state.choAnEnum),
                              descripble: _buildDonVi(state.choAnEnum)[0],
                            ),
                          ),
                          VerticalDivider(color: grey300, thickness: 1),
                          Expanded(
                            child: BieuDoWidget(
                              title: 'Trung bình',
                              number: ChoanChart().getAverage(
                                  state.choAnHistory, state.choAnEnum),
                              descripble: _buildDonVi(state.choAnEnum)[1],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: state.choAnHistory.length * 100,
              width: size.width,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.choAnHistory.length,
                itemBuilder: (context, index) {
                  ChoAn ca = state.choAnHistory[index];
                  return ChoAnTimeline(
                    maCon: state.currentBaby!.id,
                    choAnEnum: state.choAnEnum,
                    time: _buildTime(ca.thoiGian!),
                    ml: ca.maLoaiChoAn == 1
                        ? _parseMinutes(ca.trongLuong)
                        : ca.trongLuong.toInt(),
                    choAn: ca,
                    index: index,
                    last: state.choAnHistory.length - 1 == index,
                    timelines: _buildTimeline(ca, state.choAnEnum),
                    date: date,
                  );
                },
              ),
            ),
          ],
        ),
      );
}
