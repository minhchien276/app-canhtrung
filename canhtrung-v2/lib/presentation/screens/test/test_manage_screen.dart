import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_test.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/qrcode/qrcode.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/main_store_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/connect_error_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/shimmer/test_manage_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kmenu_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/test/test_circular_percent.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestManageScreen extends StatefulWidget {
  static const routeName = 'test-manage-screen';
  const TestManageScreen({
    super.key,
  });

  @override
  State<TestManageScreen> createState() => _TestState();
}

class _TestState extends State<TestManageScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 0;

  @override
  void initState() {
    context.read<TestBloc>().add(TestCheckEvent());
    super.initState();
  }

  void onChangedTab(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      endDrawer: GlobalDrawer(
        size: screenSize,
        scaffoldKey: scaffoldKey,
      ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: BuildText(
          text: 'Quản Lý Que Test',
          style: 17.text600,
          color: rose500,
        ),
        centerTitle: true,
        leading: kBackButton(context),
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        elevation: 0,
        actions: [
          kMenuButton(context,
              onTap: () => scaffoldKey.currentState!.openEndDrawer())
        ],
      ),
      body: BlocBuilder<TestBloc, TestState>(
        builder: (context, state) {
          if (state.isLoading) return getShimmer(TestManageShimmer());
          if (state.status == LoadedStatus.disconnect)
            return ConnectErrorScreen(
                onTap: () => context.read<TestBloc>().add(TestCheckEvent()));
          return ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Container(
                height: context.height,
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: Container(
                        width: context.width,
                        height: 260.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              rose500,
                              rose300,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              30.verticalSpace,
                              BuildText(
                                text: 'Bổ sung lượt test',
                                style: 18.text700,
                                color: Colors.white,
                              ),
                              10.verticalSpace,
                              BuildText(
                                text:
                                    'Quét mã trên hộp để thêm lượt Test\nBổ sung thêm que nếu que của bạn đã hết nhé!',
                                style: 14.text400,
                                color: Colors.white,
                              ),
                              20.verticalSpace,
                              KSubmitButton(
                                size: Size(context.width, 50.h),
                                text: 'Quét mã QR',
                                bgColor: whiteColor,
                                textColor: rose500,
                                icon: IconApp.qr,
                                borderRadius: 12,
                                onTap: () =>
                                    context.pushNamed(QRCodeScreen.routeName),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 220.h,
                      left: 20.w,
                      right: 20.w,
                      child: Container(
                        width: screenSize.width,
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              //spreadRadius: 1,
                              offset: Offset(2, 3),
                              color: Colors.grey.withOpacity(0.25),
                              blurRadius: 9.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 20.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BuildText(
                                text: 'Số lần Test của bạn',
                                style: 16.text700,
                                color: Palette.text,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: _buildCircleWidget(state),
                                    ),
                                    SizedBox(
                                      width: 90.w,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: _buildText(0),
                                          ),
                                          6.verticalSpace,
                                          Expanded(
                                            child: _buildText(1),
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
                      ),
                    ),
                    Positioned(
                      top: 330.h,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 120.h),
                            padding: EdgeInsets.only(left: 20.w),
                            height: screenSize.height * 0.04,
                            width: screenSize.width,
                            //color: Colors.green,
                            child: BuildText(
                              text: 'Mua thêm Que',
                              style: 16.text700,
                              color: Palette.text,
                            ),
                          ),
                          10.verticalSpace,
                          Container(
                            height: 240.h,
                            padding: EdgeInsets.only(left: 20.w),
                            width: screenSize.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: dataTest.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () => context.pushNamed(
                                    MainStoreScreen.routeName,
                                    arguments: true,
                                  ),
                                  child: Container(
                                    height: 220.h,
                                    margin: EdgeInsets.only(
                                        right: 16, top: 10.h, bottom: 10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xffffe4e8),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          height: 150.h,
                                          width: 70.w,
                                          child: Image.asset(
                                            dataTest[index].imageAsset,
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                                color: whiteColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                    spreadRadius: 2,
                                                    offset: Offset(0, 2),
                                                    color: Colors.grey
                                                        .withOpacity(0.15),
                                                    blurRadius: 7.0,
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                )),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: BuildText(
                                                        text: dataTest[index]
                                                            .name,
                                                        style: 12.text500,
                                                        color: Palette.text,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: BuildText(
                                                        text: dataTest[index]
                                                            .price,
                                                        style: 14.text500,
                                                        color:
                                                            Palette.textColor,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                10.horizontalSpace,
                                                Container(
                                                  height: 20,
                                                  width: 20,
                                                  decoration: BoxDecoration(
                                                    color: Palette.textColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  child: Image.asset(
                                                      IconApp.arrow,
                                                      scale: 3),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildCircleWidget(TestState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TestCircularPercent(
            conlai: state.quanLyQueTest?.soLuongQueTrung ?? 0,
            tong: state.quanLyQueTest?.tongQueTrung ?? 0,
            index: 0,
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: TestCircularPercent(
            conlai: state.quanLyQueTest?.soLuongQueThai ?? 0,
            tong: state.quanLyQueTest?.tongQueThai ?? 0,
            index: 1,
          ),
        ),
      ],
    );
  }

  _buildText(int index) {
    return Row(
      children: [
        Container(
          height: 16.h,
          width: 16.h,
          decoration: BoxDecoration(
            //color: Colors.green,
            borderRadius: BorderRadius.circular(20),
            gradient: dataTestPercent[index].progressColor,
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BuildText(
                text: dataTestNote[index].title,
                style: 11.text400,
              ),
              2.verticalSpace,
              BuildText(
                text: dataTestNote[index].describe,
                style: 11.text700,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
