// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/choan_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_choan.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/choan.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_history.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_bubinh_input.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/datetime/datetime_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChoAnBuBinh extends StatefulWidget {
  final int widgetId;
  bool isShow;
  final Function(int) onSwitch;
  ChoAnBuBinh({
    Key? key,
    required this.widgetId,
    required this.isShow,
    required this.onSwitch,
  }) : super(key: key);

  @override
  State<ChoAnBuBinh> createState() => _ChoAnBuBinhState();
}

class _ChoAnBuBinhState extends State<ChoAnBuBinh>
    with TickerProviderStateMixin {
  List<int> a = [0];
  List<int> b = [0];
  int value = 0;
  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: widget.widgetId,
  );
  Color color = Colors.transparent;
  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  late int index;
  TimeOfDay timeMilk =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  DateTime dateMilk = DateTime.now();
  bool checkTimeChange = false;

  @override
  void initState() {
    index = widget.widgetId;
    dataBuBinh[0].controller = TextEditingController(text: '0');
    dataBuBinh[1].controller = TextEditingController(text: '0');
    sound[0].player.stop();
    super.initState();
  }

  @override
  void dispose() {
    dataBuBinh[0].value = 0;
    dataBuBinh[1].value = 0;
    dataBuBinh[0].controller.dispose();
    dataBuBinh[1].controller.dispose();
    super.dispose();
  }

  handleNextPressed(MilkState state) {
    num luongSua = num.tryParse(dataBuBinh[index].controller.text)!;
    ChoAnEnum type =
        widget.widgetId == 1 ? ChoAnEnum.suacongthuc : ChoAnEnum.suame;
    if (luongSua != 0) {
      if (luongSua > 600) {
        showToast(context,
            'Lượng sữa hiện tại đang vượt quá 600ml. Vui lòng nhập lại lượng sữa');
      } else {
        context.read<MilkBloc>().add(InsertChoAnEvent(
              choAn: ChoAn(
                  maLoaiChoAn: getMaChoAn(type),
                  maCon: state.currentBaby?.id ?? 0,
                  trongLuong: luongSua,
                  lanChoAn: state.choAn.length + 1,
                  thoiGian: dateMilk,
                  ngayTao: dateMilk),
            ));
      }
    } else {
      showToast(
          context, 'Lượng sữa hiện tại đang là 0ml. Vui lòng thêm lượng sữa');
    }
  }

  _resetData() {
    checkTimeChange = false;
    dataBuBinh[index].value = 0;
    dataBuBinh[index].controller.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<MilkBloc, MilkState>(
      listener: (context, state) {
        if (state.message != null && state.status == LoadedStatus.succes) {
          _resetData();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state.choAnEnum == ChoAnEnum.suacongthuc ||
            state.choAnEnum == ChoAnEnum.suame) {
          return ChoAnHistory();
        }
        return Container(
          height: size.height,
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            padding: const EdgeInsets.only(top: 30),
            physics: ClampingScrollPhysics(),
            children: [
              Container(
                height: 480,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataNhapDuLieu[1].title,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: grey700,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          dataNhapDuLieu[1].descripble,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: grey400,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                  onTap: () async {
                                    showDateTimePicker(
                                      context,
                                      initDate: dateMilk,
                                      onChange: (value) {
                                        setState(() {
                                          dateMilk = value;
                                        });
                                      },
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    margin: EdgeInsets.all(10.h),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.w),
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/images/lich123.png',
                                          scale: 2.5,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          dateMilk.formatDateTime(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            color: grey400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10.h),
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
                                    'assets/images/chart.png',
                                    scale: 2.5,
                                  ),
                                  onPressed: () => context.read<MilkBloc>().add(
                                        GetChoAnHistoryEvent(
                                          choAnEnum: ChoAnEnum.suacongthuc,
                                          date: DateTime.now(),
                                          maLoaiChoAn: [
                                            getMaChoAn(ChoAnEnum.andam),
                                          ],
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 255,
                            color: Colors.transparent,
                            child: ChoAnBuBunhInput(
                              widgetId: index,
                              colors: [
                                Color(0xFF7490F3),
                                Color(0xFF7490F3),
                                Color(0xffF7B262)
                              ],
                              suaColors: [
                                Color(0xffE8EDFF),
                                Color(0xffE8EDFF),
                                Color(0xffFFF6E8),
                              ],
                              images: [
                                'assets/images/bottle.png',
                                'assets/images/bottle1.png'
                              ],
                              dataBuBinh: dataBuBinh,
                            ),
                          ),
                          Container(
                            height: 60,
                            margin: EdgeInsets.only(
                              top: 5,
                              bottom: 10,
                              left: 10,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              color: index == 1
                                  ? Color(0xffE8EDFF)
                                  : Color(0xffFFF6E8),
                              borderRadius: BorderRadius.circular(31),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 6,
                                      bottom: 6,
                                      left: 6,
                                      right: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: index == 1
                                          ? Color(0xFF7490F3)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(31),
                                    ),
                                    child: IconButton(
                                      icon: Text(
                                        dataBuBinh[0].title,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: index == 1
                                                ? Colors.white
                                                : Color(0xffF7B262)),
                                      ),
                                      onPressed: () {
                                        index = 1;
                                        dataBuBinh[1].isClick = true;
                                        dataBuBinh[2].isClick = false;
                                        dataBuBinh[2].value = 0;
                                        dataBuBinh[2].controller.text = '0';
                                        widget.onSwitch(index);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      top: 6,
                                      bottom: 6,
                                      left: 6,
                                      right: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: index == 2
                                          ? Color(0xffF7B262)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(31),
                                    ),
                                    child: IconButton(
                                      icon: Text(
                                        dataBuBinh[1].title,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: index == 2
                                                ? Colors.white
                                                : Color(0xFF7490F3)),
                                      ),
                                      onPressed: () {
                                        index = 2;
                                        dataBuBinh[2].isClick = true;
                                        dataBuBinh[1].isClick = false;
                                        dataBuBinh[1].value = 0;
                                        dataBuBinh[1].controller.text = '0';
                                        widget.onSwitch(index);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              50.verticalSpace,
              KSubmitButton(
                size: Size(size.width, 50),
                text: 'Hoàn tất',
                onTap: () => handleNextPressed(state),
              ),
              50.verticalSpace
            ],
          ),
        );
      },
    );
  }
}

List<int> listChartSuaCongThuc = [0, 0, 0, 0, 0, 0, 0];
List<int> listChartSuaMe = [0, 0, 0, 0, 0, 0, 0];
