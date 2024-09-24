// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/validator/register_validator.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kloader_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/datetime/datetime_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/form/text_input_field.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';

class BabyAddScreen extends StatefulWidget {
  static const routeName = 'baby-add-screen';
  BabyAddScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BabyAddScreen> createState() => _BabyAddScreenState();
}

class _BabyAddScreenState extends State<BabyAddScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  DateTime? _datePicker;
  bool isMale = true;
  DateTimePickerWiget _pickerWiget = DateTimePickerWiget();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            height: size.height * 0.2,
            child: Image.asset(
              'assets/images/bg_phase4_2.png',
              fit: BoxFit.cover,
            ),
          ),
          BlocConsumer<MilkBloc, MilkState>(
            listener: (context, state) {
              if (state.event == MilkEventName.rAdd) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.12),
                      height: 120,
                      width: 120,
                      child: Image.asset(
                        'assets/images/avatar.png',
                        fit: BoxFit.contain,
                        scale: 3,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        children: [
                          24.verticalSpace,
                          SizedBox(
                            child: Column(
                              children: [
                                TextInputField(
                                  name: 'Họ và tên',
                                  iconUrl: 'assets/icons/user_unactive.png',
                                  controller: _nameController,
                                ),
                                const SizedBox(height: 24),
                                GestureDetector(
                                  onTap: () async {
                                    DateTime? picker =
                                        await _pickerWiget.selectDate(
                                      context,
                                      firstDate: DateTime.now()
                                          .subtract(Duration(days: 1700)),
                                      initDate: _datePicker ?? DateTime.now(),
                                      lastDate: DateTime.now(),
                                    );
                                    if (picker != null) {
                                      String formattedDate =
                                          DateFormat("dd/MM/yyyy")
                                              .format(picker);
                                      setState(() {
                                        _datePicker = picker;
                                        _dateController.text = formattedDate
                                            .toString()
                                            .split(' ')[0];
                                      });
                                    }
                                  },
                                  child: TextInputField(
                                    name: 'Ngày sinh',
                                    iconUrl:
                                        'assets/icons/calendar_unactive.png',
                                    controller: _dateController,
                                    enabled: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          24.verticalSpace,
                          Container(
                            height: 50,
                            width: size.width,
                            //color: Colors.amber,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Image.asset(
                                      'assets/images/sex.png',
                                      scale: 3,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Giới tính của bé',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: rose400,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 35),
                                  height: 45,
                                  width: 150,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: [
                                        !isMale ? rose500 : Color(0xff7BA0FF),
                                        !isMale ? rose300 : Color(0xff4168F2),
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: 6,
                                          bottom: 6,
                                          left: 6,
                                        ),
                                        width: 65,
                                        decoration: BoxDecoration(
                                          color: isMale
                                              ? Colors.white
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(31),
                                        ),
                                        child: IconButton(
                                          icon: Text(
                                            'Nam',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: !isMale
                                                  ? Colors.white
                                                  : Color(0xff4168f2),
                                            ),
                                          ),
                                          onPressed: () {
                                            isMale = !isMale;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          top: 6,
                                          bottom: 6,
                                          right: 6,
                                        ),
                                        width: 65,
                                        decoration: BoxDecoration(
                                          color: !isMale
                                              ? Colors.white
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(31),
                                        ),
                                        child: IconButton(
                                          icon: Text(
                                            'Nữ',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: !isMale
                                                  ? rose400
                                                  : Colors.white,
                                            ),
                                          ),
                                          onPressed: () {
                                            isMale = !isMale;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          80.verticalSpace,
                          KLoaderButton(
                            onTap: () {
                              String? check = babyUpdateValidator([
                                _nameController,
                                _dateController,
                              ]);
                              if (check == null) {
                                context.read<MilkBloc>().add(
                                      AddBabyEvent(
                                        con: Con(
                                          id: 0,
                                          ten: _nameController.text.trim(),
                                          ngaySinh: _datePicker!,
                                          gioiTinh: isMale ? 'Nam' : 'Nữ',
                                        ),
                                        event: MilkEventName.rAdd,
                                      ),
                                    );
                              } else {
                                showToast(context, check);
                              }
                            },
                            size: Size(size.width, 50),
                            text: 'Tiếp tục',
                            isLoading: state.isLoading == LoadingStatus.begin,
                          ),
                          if (state.babies.isNotEmpty) ...[
                            TextButton(
                              child: Text(
                                'Quay lại',
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: rose400,
                                    decoration: TextDecoration.underline,
                                    decorationColor: rose400),
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// [] {}
class ThongTinBe {
  TextEditingController ten;
  TextEditingController ngaysinh;
  String gioitinh;
  ThongTinBe(
    this.ten,
    this.ngaysinh,
    this.gioitinh,
  );
}

List<ThongTinBe> thongTinBe = [
  ThongTinBe(
    TextEditingController(text: 'Tên bé'),
    TextEditingController(),
    'Không',
  ),
];
