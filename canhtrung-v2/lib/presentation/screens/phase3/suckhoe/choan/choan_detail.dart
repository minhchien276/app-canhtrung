// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/enum/choan_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_choan.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_andam.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_bubinh.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_bume.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kmenu_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class ChoAnDetail extends StatefulWidget {
  static const routeName = 'nav-screen';
  int widgetId;
  int clickId;
  ChoAnDetail({
    Key? key,
    required this.widgetId,
    required this.clickId,
  }) : super(key: key);

  @override
  State<ChoAnDetail> createState() => _ChoAnDetailState();
}

class _ChoAnDetailState extends State<ChoAnDetail>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController tabController = TabController(
    length: 3,
    vsync: this,
    initialIndex: dataChoAn[widget.widgetId].id,
  );
  Color color = Colors.transparent;

  List<Widget> tabs = [
    Tab(
      child: TitleText(
        text: dataChoAn[0].title2,
        fontWeight: FontWeight.w600,
        size: 12,
        maxLines: 1,
      ),
    ),
    Tab(
      child: TitleText(
        text: dataChoAn[1].title2,
        fontWeight: FontWeight.w600,
        size: 12,
        maxLines: 1,
      ),
    ),
    Tab(
      child: TitleText(
        text: dataChoAn[3].title2,
        fontWeight: FontWeight.w600,
        size: 12,
        maxLines: 1,
      ),
    ),
  ];

  @override
  void initState() {
    color = dataChoAn[widget.widgetId].color;
    tabController.addListener(() {
      if (tabController.index == 0) {
        color = dataChoAn[0].color;
      }
      if (tabController.index == 1) {
        color = dataChoAn[1].color;
      }
      if (tabController.index == 2) {
        color = dataChoAn[3].color;
      }
      setState(() {});
    });
    super.initState();
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
      body: Stack(
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
                    onTap: () {
                      sound[0].player.stop();
                      sound[0].player.setVolume(0);
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                  ),
                  TitleText(
                    text: 'Sức Khỏe Bé Yêu',
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
            width: size.width,
            margin: EdgeInsets.only(
              top: size.height * 0.2,
            ),
            decoration: BoxDecoration(color: Colors.transparent),
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  //button
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    height: 55,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TabBar(
                      controller: tabController,
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.all(6),
                      unselectedLabelColor: grey400,
                      labelColor: whiteColor,
                      indicatorColor: whiteColor,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: color,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: tabs,
                      onTap: (value) {
                        sound[0].isPlaying = true;
                      },
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        ChoAnBuMe(
                          type: ChoAnEnum.bume,
                        ),
                        ChoAnBuBinh(
                          isShow: true,
                          widgetId: widget.clickId,
                          onSwitch: (index) {
                            setState(() {
                              widget.clickId = index;
                            });
                          },
                        ),
                        ChoAnAnDam(
                          widgetId: 3,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
