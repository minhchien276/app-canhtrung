// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_choan.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/phattrien/phattrien.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/trieuchung/trieuchung.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kmenu_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class SucKhoeScreen extends StatefulWidget {
  static const routeName = 'suc-khoe-screen';
  final int index;
  const SucKhoeScreen({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<SucKhoeScreen> createState() => _SucKhoeScreenState();
}

class _SucKhoeScreenState extends State<SucKhoeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> tabs = [
    Tab(
      child: TitleText(
        text: dataChoAn[0].title1,
        fontWeight: FontWeight.w600,
        size: 12,
        maxLines: 1,
      ),
    ),
    Tab(
      child: TitleText(
        text: dataChoAn[1].title1,
        fontWeight: FontWeight.w600,
        size: 12,
        maxLines: 1,
      ),
    ),
    Tab(
      child: TitleText(
        text: dataChoAn[2].title1,
        fontWeight: FontWeight.w600,
        size: 12,
        maxLines: 1,
      ),
    ),
  ];

  @override
  void initState() {
    tabController = TabController(
        length: tabs.length, vsync: this, initialIndex: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
              length: tabs.length,
              child: Builder(builder: (BuildContext context) {
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      height: 55,
                      decoration: BoxDecoration(
                        color: grey100,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
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
                        labelColor: grey700,
                        indicatorColor: whiteColor,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: tabs,
                        onTap: (value) {},
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<MilkBloc, MilkState>(
                        builder: (context, state) {
                          return TabBarView(
                            controller: tabController,
                            children: [
                              ChoAnScreen(con: state.currentBaby),
                              PhatTrien(
                                widgetId: 1,
                                con: state.currentBaby,
                                phatTrienCon: state.phatTrienCon,
                              ),
                              TrieuChungScreen(
                                con: state.currentBaby,
                                trieuChung: state.trieuChung.isNotEmpty
                                    ? state.trieuChung.first
                                    : null,
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
