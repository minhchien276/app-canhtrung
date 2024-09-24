// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/validator/register_validator.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/gallery_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_handler.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kloader_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/datetime/datetime_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/form/text_input_field.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/home/home_tabbar.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/network_image.dart';
import 'package:flutter_ovumb_app_version1/services/permission/permission.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';

class BabyUpdateScreen extends StatefulWidget {
  static const routeName = 'thongtin-update-screen';
  final Con con;
  BabyUpdateScreen({
    Key? key,
    required this.con,
  }) : super(key: key);

  @override
  State<BabyUpdateScreen> createState() => _BabyUpdateScreenState();
}

class _BabyUpdateScreenState extends State<BabyUpdateScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime? _datePicker;
  bool isMale = true;
  File? avatar;
  DateTimePickerWiget _pickerWiget = DateTimePickerWiget();

  @override
  void initState() {
    _nameController.text = widget.con.ten;
    _dateController.text = DateFormat("dd/MM/yyyy").format(widget.con.ngaySinh);
    _datePicker = widget.con.ngaySinh;
    isMale = widget.con.gioiTinh == 'Nam' ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      endDrawer: GlobalDrawer(
        size: size,
        scaffoldKey: scaffoldKey,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 2,
        leading: kBackButton(context),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => scaffoldKey.currentState!.openEndDrawer(),
            icon: Image.asset(
              'assets/buttons/menu.png',
              scale: 3,
              color: rose400,
            ),
          ),
        ],
        title: TitleText(
          text: 'Thông Tin Bé Yêu',
          fontWeight: FontWeight.w600,
          size: 18,
          color: rose500,
        ),
      ),
      body: BlocBuilder<MilkBloc, MilkState>(
        builder: (context, state) {
          return Container(
            height: size.height,
            width: size.width,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                50.verticalSpace,
                SizedBox(
                  height: 110.h,
                  width: 110.h,
                  child: FittedBox(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        networkImageWithCached(
                          size: Size(100.h, 100.h),
                          url: state.currentBaby?.avatar,
                          borderRadius: 1000,
                          boxBorder: Border.all(color: rose200, width: 4),
                          placeholder: defaultAvatar(Size(100.h, 100.h)),
                          file: avatar,
                        ),
                        Positioned(
                          bottom: -5.h,
                          right: -5.h,
                          child: IconButton(
                            onPressed: () async {
                              try {
                                final check =
                                    await PermissionHandler.photoRequest();
                                if (check) {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor:
                                        Colors.white.withOpacity(0),
                                    barrierColor: Colors.black38,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(8),
                                      ),
                                    ),
                                    builder: (context) {
                                      return PhotoPickerScrenn();
                                    },
                                  ).then((image) async {
                                    if (image != null) {
                                      avatar = await resizeImage(image, 1000);
                                      setState(() {});
                                    }
                                  });
                                }
                              } catch (e) {
                                showSettingDialog(context, e.toString());
                              }
                            },
                            icon: Image.asset(
                              IconApp.edit,
                              scale: 3.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                50.verticalSpace,
                SizedBox(
                  child: Column(
                    children: [
                      TextInputField(
                        name: 'Họ và tên',
                        iconUrl: 'assets/icons/user_unactive.png',
                        controller: _nameController,
                      ),
                      24.verticalSpace,
                      GestureDetector(
                        onTap: () async {
                          DateTime? picker = await _pickerWiget.selectDate(
                            context,
                            initDate: _datePicker ?? DateTime.now(),
                            firstDate:
                                DateTime.now().subtract(Duration(days: 1700)),
                            lastDate: DateTime.now(),
                          );
                          if (picker != null) {
                            String formattedDate =
                                DateFormat("dd/MM/yyyy").format(picker);
                            setState(() {
                              _datePicker = picker;
                              _dateController.text =
                                  formattedDate.toString().split(' ')[0];
                            });
                          }
                        },
                        child: TextInputField(
                          name: 'Ngày sinh',
                          iconUrl: 'assets/icons/calendar_unactive.png',
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
                          10.horizontalSpace,
                          Image.asset(
                            'assets/images/sex.png',
                            scale: 3,
                          ),
                          10.horizontalSpace,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                top: 6,
                                bottom: 6,
                                left: 6,
                              ),
                              width: 65,
                              decoration: BoxDecoration(
                                color:
                                    isMale ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(31),
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
                                color:
                                    !isMale ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(31),
                              ),
                              child: IconButton(
                                icon: Text(
                                  'Nữ',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: !isMale ? rose400 : Colors.white,
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
                120.verticalSpace,
                KLoaderButton(
                  onTap: () {
                    String? check = babyUpdateValidator([
                      _nameController,
                      _dateController,
                    ]);
                    if (check == null) {
                      context.read<MilkBloc>().add(UpdateBabyEvent(
                          con: Con(
                            id: widget.con.id,
                            ten: _nameController.text.trim(),
                            ngaySinh: _datePicker!,
                            gioiTinh: isMale ? 'Nam' : 'Nữ',
                          ),
                          avatar: avatar));
                    } else {
                      showToast(context, check);
                    }
                  },
                  size: Size(size.width, 50),
                  text: 'Cập nhật',
                  isLoading: state.isLoading == LoadingStatus.begin,
                ),
                50.verticalSpace,
              ],
            ),
          );
        },
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
