// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/test_result_enum.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/toast_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kmenu_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/chart/chart_history_item.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_ovumb_app_version1/logic/chart/chart_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/chart/chart_history_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/shimmer/chart_shimmer.dart';
import 'chart_landscape_screen.dart';

// màn hỉnh hiển thị biểu đồ dọc
class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  late Map<String, List<ChartLHData>> data;
  int currentIndex = 0;
  late List<String> keys;
  late List<List<ChartLHData>> values;
  bool hadInitData = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double heightChart = 300.h;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: [
            BuildText(
              text: 'Biểu đồ',
              style: 17.text600,
              color: rose500,
            ),
            10.horizontalSpace,
            IconButton(
              onPressed: () => context.pushNamed(
                ChartLandscapeScreen.routeName,
                arguments: data,
              ),
              icon: Image.asset(IconApp.rotate),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        elevation: 3,
        actions: [
          kMenuButton(
            context,
            onTap: () => Scaffold.of(context).openEndDrawer(),
            color: rose400,
          ),
        ],
      ),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state.isLoading) {
            return getShimmer(ChartShimmer());
          }
          if (!hadInitData) {
            data = state.ketQuaTest;
            if (data.isNotEmpty) {
              keys = state.ketQuaTest.keys.toList().reversed.toList();
              values = state.ketQuaTest.values.toList().reversed.toList();
            } else {
              keys = [];
              values = [];
            }
            hadInitData = true;
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                20.verticalSpace,
                _buildChart(size, heightChart),
                40.verticalSpace,
                if (data.isNotEmpty) ...[
                  _buildPeriodDropdown(),
                  20.verticalSpace,
                ],
                _buildHistory(state.ketQuaTest),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildChart(
    Size size,
    double heightChart,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      decoration: BoxDecoration(
        color: violet50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Center(
            child: BuildText(
              text: 'Biểu đồ tăng sinh nồng độ LH',
              style: 14.text700,
              color: grey700,
            ),
          ),
          20.verticalSpace,
          Stack(
            children: [
              Positioned(
                right: 0,
                child: SizedBox(
                  height: heightChart,
                  width: size.width * 0.8,
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                          ),
                          color: violet300,
                        ),
                        height: heightChart * aspectDatdinh,
                      ),
                      Container(
                        color: violet200,
                        height: heightChart * aspectCao,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                          ),
                          color: violet100,
                        ),
                        height: heightChart * aspectThap,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: SizedBox(
                  height: heightChart,
                  width: context.width * 0.87,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: heightChart * aspectDatdinh,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: BuildText(
                            text: 'ĐẠT\nĐỈNH',
                            style: 10.text700,
                            color: grey700,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: heightChart * aspectCao,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: BuildText(
                            text: 'CAO',
                            style: 10.text700,
                            color: grey700,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        height: heightChart * aspectThap,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: BuildText(
                            text: 'THẤP',
                            style: 10.text700,
                            color: grey700,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 25,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: BuildText(
                              text: 'Ngày',
                              style: 10.text700,
                              color: grey500,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: heightChart + 10.h,
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  onZooming: (zoomingArgs) {},
                  onTooltipRender: (tooltipArgs) {},
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    builder: (data, point, series, pointIndex, seriesIndex) {
                      return tooltipPicker(
                          values[currentIndex].isNotEmpty
                              ? values[currentIndex]
                              : [],
                          pointIndex);
                    },
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: true,
                    minimum: 0,
                    maximum: 80,
                    interval: 80,
                    labelStyle: 12.text600.copyWith(color: Colors.transparent),
                    majorGridLines: const MajorGridLines(width: 0),
                    axisLine: const AxisLine(width: 0),
                  ),
                  primaryXAxis: CategoryAxis(
                    isVisible: true,
                    arrangeByIndex: true,
                    //labelPlacement: LabelPlacement.onTicks,
                    autoScrollingMode: AutoScrollingMode.end,
                    //isInversed: true,
                    autoScrollingDelta: 10,
                    axisBorderType: AxisBorderType.withoutTopAndBottom,
                    majorGridLines: const MajorGridLines(width: 0),
                    axisLine: const AxisLine(width: 0),
                    labelStyle: 10.text600.copyWith(color: grey500),
                  ),
                  series: <CartesianSeries>[
                    LineSeries<ChartLHData, String>(
                      dataSource: values.isNotEmpty ? values[currentIndex] : [],
                      xValueMapper: (ChartLHData data, _) => data.x,
                      yValueMapper: (ChartLHData data, _) => data.y,
                      // Renders the marker
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        borderColor: violet600,
                        height: 8,
                        width: 8,
                        borderWidth: 1.5,
                      ),
                      dataLabelSettings: DataLabelSettings(
                        isVisible: false,
                        labelAlignment: ChartDataLabelAlignment.top,
                        textStyle: 12.text500.copyWith(color: violet600),
                      ),
                      dashArray: [1, 3],
                      color: violet600,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildPeriodDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BuildText(
          text: 'Chu kỳ: ',
          style: 16.text700,
          color: grey700,
        ),
        6.verticalSpace,
        SizedBox(
          height: 50.h,
          width: 270.w,
          child: Center(
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
              value: keys[currentIndex],
              style: TextStyle(overflow: TextOverflow.ellipsis),
              items: keys
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        children: [
                          BuildText(
                            text: item,
                            style: 12.text600,
                            color: keys[currentIndex] == item
                                ? violet600
                                : grey400,
                          )
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
        ),
      ],
    );
  }

  _buildHistory(Map<String, List<ChartLHData>> ketQuaTest) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: BuildText(
            text: 'Lịch sử Test',
            style: 18.text700,
            color: grey700,
          ),
          trailing: TextButton(
            style: const ButtonStyle(
                overlayColor: WidgetStatePropertyAll(Colors.transparent)),
            onPressed: () {
              if (ketQuaTest.isEmpty) {
                context.showToast('Bạn chưa có kết quả Test nào');
              } else {
                context.pushNamed(ChartHistoryScreen.routeName,
                    arguments: ketQuaTest);
              }
            },
            child: BuildText(
              text: 'Xem thêm',
              style: 12.text400,
              color: violet500,
            ),
          ),
        ),
        SizedBox(
          height: 35.h,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: violet500,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: BuildText(
                      text: 'Ngày',
                      style: 12.text600,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: BuildText(
                    text: 'Giờ',
                    style: 12.text600,
                    color: grey700,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: BuildText(
                    text: 'Giá trị LH',
                    style: 12.text600,
                    color: grey700,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: BuildText(
                    text: 'Lần Test',
                    style: 12.text600,
                    color: grey700,
                  ),
                ),
              ),
            ],
          ),
        ),
        10.verticalSpace,
        Container(
          color: whiteColor,
          height: 200.h,
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.isNotEmpty ? values[currentIndex].length : 0,
            itemBuilder: (context, index) {
              return ChartHistoryItem(
                ketQuaTest: values[currentIndex][index],
                index: index + 1,
              );
            },
          ),
        ),
        100.verticalSpace,
      ],
    );
  }
}

Widget tooltipPicker(List<ChartLHData> data, int index) => Container(
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
            text: checkLH(data[index].y),
            fontWeight: FontWeight.w700,
            size: 11,
            color: whiteColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Divider(
              height: 6,
              color: whiteColor,
            ),
          ),
          Row(
            children: [
              ClipOval(
                child: Container(
                  height: 10,
                  width: 10,
                  color: buildDot(data[index].y),
                ),
              ),
              const SizedBox(width: 4),
              TitleText(
                text: data[index].x,
                fontWeight: FontWeight.w600,
                size: 11,
                color: whiteColor,
              ),
              TitleText(
                text: ' - ',
                fontWeight: FontWeight.w600,
                size: 11,
                color: whiteColor,
              ),
              TitleText(
                text: data[index].time.toTime(),
                fontWeight: FontWeight.w600,
                size: 11,
                color: whiteColor,
              ),
            ],
          ),
        ],
      ),
    );

//model dữ liệu biểu đồ trục x,y
class ChartLHData {
  ChartLHData(
    this.x,
    this.y,
    this.time,
  );
  final String x;
  final int y;
  final DateTime time;
}

class ChartPeriod {
  final DateTime begin;
  final DateTime end;
  final String period;
  ChartPeriod({
    required this.begin,
    required this.end,
    required this.period,
  });
}
