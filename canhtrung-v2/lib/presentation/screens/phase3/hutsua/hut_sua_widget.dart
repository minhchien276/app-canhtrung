// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/hutsua/hut_sua_input.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_timeline.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/datetime/datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_ovumb_app_version1/data/enum/choan_enum.dart';
import 'package:flutter_ovumb_app_version1/data/handle/choan_chart.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/hutsua.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/bieudo_widget.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class HutSuaWidget extends StatefulWidget {
  final List<ChartDataChoAn> chartDataHistory;
  final List<ChartDataChoAn> chartDataByDay;
  final List<HutSua> hutSua;
  const HutSuaWidget({
    Key? key,
    required this.chartDataHistory,
    required this.chartDataByDay,
    required this.hutSua,
  }) : super(key: key);

  @override
  State<HutSuaWidget> createState() => _HutSuaWidgetState();
}

class _HutSuaWidgetState extends State<HutSuaWidget> {
  DateTime? date = DateTime.now();
  bool isSwapChart = false;
  DateTimePickerWiget _pickerWiget = DateTimePickerWiget();
  final player = AudioPlayer();
  bool isPlay = true;
  Guide? guide;

  String _buildTime(DateTime date) {
    DateFormat format = DateFormat('HH:mm');
    return format.format(date);
  }

  List<TimelineDetail> _buildTimeline(HutSua hutSua) {
    List<TimelineDetail> timelines = [];
    if (hutSua.vuTrai != null && hutSua.vuTrai != 0) {
      timelines.add(TimelineDetail(text: 'Ngực trái'));
    }
    if (hutSua.vuPhai != null && hutSua.vuPhai != 0) {
      timelines.add(TimelineDetail(text: 'Ngực phải'));
    }
    return timelines;
  }

  @override
  void initState() {
    context.read<MilkBloc>().add(GetBumeLinkEvent());
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _initialMP3(Guide? value) async {
    if (guide == null && value != null) {
      guide = value;
      await player.play(UrlSource(guide!.link_video));
      player.setVolume(1);
    }
  }

  void _pause() {
    player.pause();
  }

  void _resume() {
    player.resume();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<MilkBloc, MilkState>(
      listener: (context, state) {
        if (state.bumeLink != null) {
          _initialMP3(state.bumeLink);
        }
      },
      child: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(top: 0),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 230,
              width: size.width,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đồ thị hút sữa',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  isSwapChart
                                      ? Text(
                                          '${widget.chartDataHistory.length} ngày hút sữa (ml/ngày)',
                                          style: TextStyle(
                                            color: grey400,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : Text(
                                          '${widget.chartDataByDay.length} lần hút sữa (ml/lần)',
                                          style: TextStyle(
                                            color: grey400,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
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
                                    'assets/icons/swap_icon.png',
                                    scale: 2.5,
                                  ),
                                  onPressed: () {
                                    isSwapChart = !isSwapChart;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 170,
                    color: Colors.transparent,
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 10,
                      right: 10,
                    ),
                    child: SfCartesianChart(
                      tooltipBehavior: !isSwapChart
                          ? TooltipBehavior(
                              enable: true,
                              builder: (data, point, series, pointIndex,
                                  seriesIndex) {
                                return Container(
                                  padding: const EdgeInsets.all(6),
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    children: [
                                      TitleText(
                                        text: widget
                                                .chartDataByDay[pointIndex].y
                                                .toString() +
                                            'ml',
                                        fontWeight: FontWeight.w700,
                                        size: 11,
                                        color: whiteColor,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Divider(
                                          height: 6,
                                          color: whiteColor,
                                        ),
                                      ),
                                      TitleText(
                                        text: _buildTime(widget
                                            .chartDataByDay[pointIndex].date!),
                                        fontWeight: FontWeight.w700,
                                        size: 11,
                                        color: whiteColor,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : null,
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
                          dataSource: isSwapChart
                              ? widget.chartDataHistory
                              : widget.chartDataByDay,
                          xValueMapper: (ChartDataChoAn data, _) => data.x,
                          yValueMapper: (ChartDataChoAn data, _) => data.y,
                          pointColorMapper: (ChartDataChoAn data, _) =>
                              data.color,
                          dataLabelMapper: (datum, index) => isSwapChart
                              ? widget.chartDataHistory[index].y
                                  .toInt()
                                  .toString()
                              : widget.chartDataByDay[index].y
                                  .toInt()
                                  .toString(),
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
            ),
            20.verticalSpace,
            SizedBox(
              height: widget.hutSua.length * 100 + 300,
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nhập dữ liệu',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: grey700,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          isPlay
                              ? 'assets/images/volume.png'
                              : 'assets/images/mute.png',
                          scale: 5,
                          color: rose400,
                        ),
                        onPressed: () {
                          if (isPlay) {
                            _pause();
                            isPlay = !isPlay;
                          } else {
                            _resume();
                            isPlay = !isPlay;
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: widget.hutSua.length * 100 + 300,
                    child: ListView(
                      padding: const EdgeInsets.only(top: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              HutSuaInput.routeName,
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 80,
                                    width: size.width * 0.05,
                                    decoration: BoxDecoration(
                                      color: rose400,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25),
                                        bottomLeft: Radius.circular(25),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 20),
                                            height: 80,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TitleText(
                                                  text: 'Hút sữa cho mẹ',
                                                  fontWeight: FontWeight.w600,
                                                  size: 14,
                                                  color: grey700,
                                                ),
                                                SizedBox(height: 2),
                                                TitleText(
                                                  text: 'Ngực trái, ngực phải',
                                                  fontWeight: FontWeight.w400,
                                                  size: 12,
                                                  color: grey400,
                                                ),
                                                SizedBox(height: 2),
                                                TitleText(
                                                  text:
                                                      'Khoảng ${ChoanChart().getTotalHutSua(widget.hutSua) ?? 0}ml sữa',
                                                  fontWeight: FontWeight.w400,
                                                  size: 12,
                                                  color: grey400,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 14),
                                          child: Image.asset(
                                            'assets/buttons/add.png',
                                            scale: 4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        20.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TitleText(
                              text: 'Lịch sử hút sữa',
                              fontWeight: FontWeight.w600,
                              size: 16,
                              color: grey700,
                            ),
                            InkWell(
                              onTap: () async {
                                date = await _pickerWiget.selectDate(
                                  context,
                                  initDate:
                                      date != null ? date! : DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(Duration(days: 1000)),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 1000)),
                                );
                                if (date != null) {
                                  context
                                      .read<MilkBloc>()
                                      .add(GetHutSuaHistoryEvent(date: date!));
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: BieuDoWidget(
                                          title: 'Số lần',
                                          number: widget.hutSua.length,
                                          descripble: 'Lần',
                                        ),
                                      ),
                                      VerticalDivider(
                                          color: grey300, thickness: 1),
                                      Expanded(
                                        child: BieuDoWidget(
                                          title: 'Tổng',
                                          number: ChoanChart()
                                              .getTotalHutSua(widget.hutSua),
                                          descripble: 'ml',
                                        ),
                                      ),
                                      VerticalDivider(
                                          color: grey300, thickness: 1),
                                      Expanded(
                                        child: BieuDoWidget(
                                          title: 'Trung bình',
                                          number: ChoanChart()
                                              .getAverageHutSua(widget.hutSua),
                                          descripble: 'ml/lần',
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
                          height: widget.hutSua.length * 100,
                          width: size.width,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.hutSua.length,
                            itemBuilder: (context, index) {
                              HutSua hs = widget.hutSua[index];
                              return ChoAnTimeline(
                                maCon: 0,
                                choAnEnum: ChoAnEnum.hutsua,
                                time: _buildTime(hs.thoiGian!),
                                ml: ChoanChart().getTotalHutSua([hs]),
                                index: index,
                                last: widget.hutSua.length - 1 == index,
                                hutSua: hs,
                                timelines: _buildTimeline(hs),
                                date: date,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
