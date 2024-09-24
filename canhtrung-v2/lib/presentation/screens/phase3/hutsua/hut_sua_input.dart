// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_choan.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/hutsua.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_bubinh_input.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kmenu_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/datetime/datetime_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HutSuaInput extends StatefulWidget {
  static const routeName = 'hut-sua-input';
  const HutSuaInput({
    Key? key,
  }) : super(key: key);

  @override
  State<HutSuaInput> createState() => _HutSuaInputState();
}

class _HutSuaInputState extends State<HutSuaInput> {
  DateTime date = DateTime.now();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  List<Color> colors = [violet500, rose400];
  List<Color> suaColors = [violet100, rose50];

  int index = 0;

  TimeOfDay timeMilk =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  DateTime dateMilk = DateTime.now();

  _resetData() {
    dataKichSua[0].value = 0;
    dataKichSua[1].value = 0;
    dataKichSua[0].controller.text = '0';
    dataKichSua[1].controller.text = '0';
  }

  handleNextPressed(MilkState state, DateTime date) {
    double vuTrai = double.parse(dataKichSua[1].controller.text);
    double vuPhai = double.parse(dataKichSua[0].controller.text);
    if (vuTrai != 0 || vuPhai != 0) {
      context.read<MilkBloc>().add(InsertHutSuaEvent(
              hutSua: HutSua(
            lanChoAn: state.hutSuaByDay.length + 1,
            vuTrai: vuTrai,
            vuPhai: vuPhai,
            thoiGian: date,
            ngayTao: date,
          )));
    } else {
      showToast(
          context, 'Lượng sữa hiện tại đang là 0ml. Vui lòng thêm lượng sữa');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xffFAFAFA),
      key: scaffoldKey,
      endDrawer: GlobalDrawer(
        size: size,
        scaffoldKey: scaffoldKey,
      ),
      body: BlocConsumer<MilkBloc, MilkState>(
        listener: (context, state) {
          if (state.message != null && state.status == LoadedStatus.succes) {
            _resetData();
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Positioned(
                top: 0,
                height: size.height * 0.25,
                width: size.width,
                child: Image.asset(
                  'assets/images/bg_phase4_3.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).viewPadding.top,
                child: SizedBox(
                  height: kToolbarHeight,
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      kBackButton(
                        context,
                        color: Colors.white,
                      ),
                      TitleText(
                        text: 'Hành Trình Kích Sữa',
                        fontWeight: FontWeight.w600,
                        size: 18,
                        color: rose25,
                      ),
                      kMenuButton(
                        context,
                        onTap: () => scaffoldKey.currentState!.openEndDrawer(),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: size.height * 0.29,
                ),
                decoration: BoxDecoration(color: Colors.transparent),
                child: Container(
                  height: size.height,
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: ListView(
                    padding: const EdgeInsets.only(top: 0),
                    physics: const ClampingScrollPhysics(),
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
                                  'Hút sữa cho mẹ',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: grey700,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                4.verticalSpace,
                                Text(
                                  'Kéo ngưỡng sữa trong bình dưới bằng với ngưỡng sữa khi hút',
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
                                  //nút hiện tại và chart
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
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
                                  //nút hiện tại và chart

                                  //binh sua
                                  Container(
                                    height: 255,
                                    color: Colors.transparent,
                                    child: ChoAnBuBunhInput(
                                      widgetId: index,
                                      colors: colors,
                                      suaColors: suaColors,
                                      images: [
                                        'assets/images/bottle2.png',
                                        'assets/images/bottle3.png'
                                      ],
                                      dataBuBinh: dataKichSua,
                                    ),
                                  ),
                                  //button

                                  Container(
                                    height: 60,
                                    margin: EdgeInsets.only(
                                      top: 5,
                                      bottom: 10,
                                      left: 10,
                                      right: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: suaColors[index],
                                      borderRadius: BorderRadius.circular(31),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                              color: index == 0
                                                  ? colors[0]
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(31),
                                            ),
                                            child: IconButton(
                                              icon: Text(
                                                dataKichSua[0].title,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: index == 0
                                                        ? Colors.white
                                                        : colors[1]),
                                              ),
                                              onPressed: () {
                                                index = 0;
                                                dataKichSua[0].isClick = true;
                                                dataKichSua[1].isClick = false;
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
                                              color: index == 1
                                                  ? colors[1]
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(31),
                                            ),
                                            child: IconButton(
                                              icon: Text(
                                                dataKichSua[1].title,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: index == 1
                                                        ? Colors.white
                                                        : colors[0]),
                                              ),
                                              onPressed: () {
                                                index = 1;
                                                dataKichSua[1].isClick = true;
                                                dataKichSua[0].isClick = false;
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
                        onTap: () => handleNextPressed(state, dateMilk),
                      ),
                      50.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
