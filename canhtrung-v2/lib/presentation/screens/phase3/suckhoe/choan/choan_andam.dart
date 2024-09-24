// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/choan_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_choan.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/choan.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_history.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/datetime/datetime_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChoAnAnDam extends StatefulWidget {
  int widgetId;
  ChoAnAnDam({
    Key? key,
    required this.widgetId,
  }) : super(key: key);

  @override
  State<ChoAnAnDam> createState() => _ChoAnAnDamState();
}

class _ChoAnAnDamState extends State<ChoAnAnDam> {
  late int value = 0;
  String loaiThucPham = '';
  TimeOfDay timeMilk =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  DateTime dateMilk = DateTime.now();
  bool checkTimeChange = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    sound[0].player.stop();
    super.initState();
  }

  double? _totalAnDam() {
    try {
      double total = 0;
      for (int i = 0; i < 6; i++) {
        if (dataAnDam[i].controller.text != '') {
          total += int.parse(dataAnDam[i].controller.text);
          loaiThucPham += dataAnDam[i].title + ';';
        }
      }
      return total;
    } catch (e) {
      return null;
    }
  }

  void _resetData() {
    for (int i = 0; i < 6; i++) {
      dataAnDam[i].controller.text = '';
    }
  }

  double? _validator() {
    double? total = _totalAnDam();
    if (total != null) {
      if (total != 0) {
        if (total > 1000) {
          showToast(context, 'Khuyến cáo tổng số gam không nên vượt quá 1000g');
        } else {
          return total;
        }
      } else {
        showToast(context, 'Bạn chưa nhập trọng lượng');
      }
    } else {
      showToast(context, 'Không được nhập kí tự. Vui lòng nhập lại');
    }
    return null;
  }

  handleNextPressed(MilkState state) {
    double? total = _validator();
    if (total != null) {
      context.read<MilkBloc>().add(InsertChoAnEvent(
            choAn: ChoAn(
              maLoaiChoAn: getMaChoAn(ChoAnEnum.andam),
              maCon: state.currentBaby?.id ?? 0,
              trongLuong: total,
              lanChoAn: state.choAn.length + 1,
              thoiGian: dateMilk,
              ngayTao: dateMilk,
              loaiThucPham: loaiThucPham,
            ),
          ));
    }
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
        if (state.choAnEnum == ChoAnEnum.andam) {
          return ChoAnHistory();
        }
        return Container(
          height: size.height,
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            padding: const EdgeInsets.only(top: 30),
            physics: const ClampingScrollPhysics(),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataNhapDuLieu[2].title,
                    style: TextStyle(
                      color: grey700,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    dataNhapDuLieu[2].descripble,
                    style: TextStyle(
                      color: grey400,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              14.verticalSpace,
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: 70,
                      child: Row(
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
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      choAnEnum: ChoAnEnum.andam,
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
                    ),
                    Expanded(
                      child: GridView.count(
                        padding: EdgeInsets.only(top: 0),
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        children: List.generate(
                          dataAnDam.length,
                          (index) {
                            return Center(
                              child: InkWell(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  dataAnDam[index].image),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: value == index
                                                    ? rose400
                                                    : Colors.transparent),
                                          ),
                                        ),
                                        Positioned(
                                          left: dataAnDam[index]
                                                  .controller
                                                  .text
                                                  .isEmpty
                                              ? 41
                                              : 30,
                                          top: 42,
                                          child: dataAnDam[index]
                                                  .controller
                                                  .text
                                                  .isEmpty
                                              ? Image.asset(
                                                  'assets/images/add11.png',
                                                  scale: 4,
                                                )
                                              : Container(
                                                  alignment: Alignment.center,
                                                  height: 19,
                                                  width: 28,
                                                  decoration: BoxDecoration(
                                                      color: rose25,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Text(
                                                    dataAnDam[index]
                                                            .controller
                                                            .text +
                                                        'g',
                                                    style: TextStyle(
                                                      color: rose400,
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      dataAnDam[index].title,
                                      style: TextStyle(
                                        color: grey700,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  value = index;
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 55,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(31),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage(dataAnDam[value].image),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                Flexible(
                                  child: TitleText(
                                    text: dataAnDam[value].title,
                                    fontWeight: FontWeight.w500,
                                    size: 14,
                                    color: grey700,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Flexible(
                                  child: IconButton(
                                    iconSize: 5,
                                    icon: Image.asset(
                                      'assets/images/trash.png',
                                      scale: 3,
                                    ),
                                    onPressed: () {
                                      dataAnDam.remove(dataAnDam[value].image);
                                      dataAnDam.remove(
                                          dataAnDam[value].controller.text);
                                      dataAnDam.remove(dataAnDam[value].title);
                                      dataAnDam.remove(dataAnDam[value].index);
                                      dataAnDam.remove(dataAnDam[value].gram);
                                      dataAnDam.remove(dataAnDam[value].isAdd);
                                      dataAnDam[value].controller.text = '';
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 120,
                              height: 50,
                              decoration: BoxDecoration(
                                color: grey100,
                                borderRadius: BorderRadius.circular(31),
                              ),
                              child: TextFormField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter
                                      .digitsOnly // Chỉ cho phép nhập số
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Vui lòng không nhập kí tự';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.grey,
                                controller: dataAnDam[value].controller,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  iconColor: grey700,
                                ),
                                onTapOutside: (event) {
                                  FocusScope.of(context).requestFocus(
                                    new FocusNode(),
                                  );
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

List<int> listChartAnDam = [0, 0, 0, 0, 0, 0, 0];
