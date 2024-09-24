// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../utils/color.dart';
import '../../widgets/title_text.dart';
import 'chart_screen.dart';

// màn hỉnh hiển thị biểu đồ ngang
// ignore: must_be_immutable
class ChartLandscapeScreen extends StatefulWidget {
  static const routeName = 'chart-screen-landscape';
  Map<String, List<ChartLHData>> data;
  ChartLandscapeScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ChartLandscapeScreen> createState() => _ChartLandscapeScreenState();
}

class _ChartLandscapeScreenState extends State<ChartLandscapeScreen> {
  late List<String> keys;
  late List<List<ChartLHData>> values;
  int currentIndex = 0;

  @override
  void initState() {
    setLandscapeOrientation();
    keys = widget.data.keys.toList().reversed.toList();
    values = widget.data.values.toList().reversed.toList();
    super.initState();
  }

  @override
  void dispose() {
    setPortraitOrientation();
    super.dispose();
  }

  // String _parseDate(DateTime time) {
  //   return '${time.day}/${time.month}';
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double heightChart = size.height * 0.8;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Biểu đồ',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ).copyWith(
              color: rose500,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        elevation: 3,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Image.asset(
              'assets/icons/x_icon.png',
              color: rose500,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 20),
              Container(
                height: heightChart,
                width: size.width,
                decoration: BoxDecoration(
                  color: violet50,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: TitleText(
                        text: 'Biểu đồ tăng sinh nồng độ LH',
                        fontWeight: FontWeight.w700,
                        size: 14,
                        color: grey700,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Stack(
                      children: [
                        Positioned(
                          right: 0,
                          left: 40,
                          child: SizedBox(
                            height: heightChart,
                            width: size.width,
                            child: Column(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                    ),
                                    color: violet300,
                                  ),
                                  height: heightChart * 0.31,
                                ),
                                Container(
                                  color: violet200,
                                  height: heightChart * 0.0875,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    color: violet100,
                                  ),
                                  height: heightChart * 0.30250,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          child: Container(
                            height: heightChart,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: heightChart * 0.31,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'ĐẠT\nĐỈNH',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: heightChart * 0.0875,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'CAO',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: heightChart * 0.30250,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'THẤP',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 25,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Ngày',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        color: grey500,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: SizedBox(
                            height: heightChart * 0.8,
                            //width: size.width * 0.9,
                            child: SfCartesianChart(
                              plotAreaBorderWidth: 0,
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                                builder: (data, point, series, pointIndex,
                                    seriesIndex) {
                                  return tooltipPicker(
                                      values[currentIndex], pointIndex);
                                },
                              ),
                              primaryYAxis: NumericAxis(
                                isVisible: false,
                                minimum: 0,
                                maximum: 80,
                                interval: 20,
                                labelStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ).copyWith(color: grey500),
                                majorGridLines: const MajorGridLines(width: 0),
                                axisLine: const AxisLine(width: 0),
                              ),
                              primaryXAxis: CategoryAxis(
                                arrangeByIndex: true,
                                autoScrollingMode: AutoScrollingMode.end,
                                autoScrollingDelta: 30,
                                majorGridLines: const MajorGridLines(width: 0),
                                axisLine: const AxisLine(width: 0),
                                labelStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ).copyWith(color: grey500),
                              ),
                              series: <CartesianSeries>[
                                LineSeries<ChartLHData, String>(
                                  dataSource: values.isNotEmpty
                                      ? values[currentIndex]
                                      : [],
                                  xValueMapper: (ChartLHData data, _) => data.x,
                                  yValueMapper: (ChartLHData data, _) => data.y,
                                  // Renders the marker
                                  markerSettings: const MarkerSettings(
                                    isVisible: true,
                                    borderColor: violet600,
                                    height: 8,
                                    width: 8,
                                  ),
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: false,
                                    labelAlignment: ChartDataLabelAlignment.top,
                                    textStyle: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ).copyWith(color: violet600),
                                  ),
                                  dashArray: [5, 5],
                                  color: violet600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (widget.data.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TitleText(
                      text: 'Chu kỳ: ',
                      fontWeight: FontWeight.w700,
                      size: 16,
                      color: grey700,
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      height: 50,
                      width: 260,
                      child: DropdownButtonFormField2<String>(
                        buttonStyleData: ButtonStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: 50,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          maxHeight: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        isExpanded: true,
                        value: keys[currentIndex],
                        items: keys
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                child: Row(
                                  children: [
                                    TitleText(
                                      text: item,
                                      fontWeight: FontWeight.w600,
                                      size: 14,
                                      color: keys[currentIndex] == item
                                          ? violet600
                                          : grey400,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (item) {
                          setState(() {
                            for (int i = 0; i < keys.length; i++) {
                              if (keys[i] == item) {
                                currentIndex = i;
                              }
                            }
                          });
                        },
                        onMenuStateChange: (isOpen) {},
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: violet600,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: violet600,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: grey300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// Chuyển sang chế độ xoay ngang
void setLandscapeOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

// Trở lại chế độ màn hình bình thường
void setPortraitOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
