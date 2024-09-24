// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/handle/choan_chart.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/hutsua/hut_sua_widget.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kmenu_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';

class HutSuaScreen extends StatefulWidget {
  static const routeName = 'hut-sua-screen';
  final Con con;
  HutSuaScreen({
    Key? key,
    required this.con,
  }) : super(key: key);

  @override
  State<HutSuaScreen> createState() => _HutSuaScreenState();
}

class _HutSuaScreenState extends State<HutSuaScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    context.read<MilkBloc>().add(GetHutSuaEvent(date: DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfffafafa),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
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
                        Navigator.pop(context);
                      },
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
              child: BlocConsumer<MilkBloc, MilkState>(
                listener: (context, state) {
                  if (state.popContext) {
                    context.pop();
                  }
                },
                builder: (context, state) {
                  return HutSuaWidget(
                    chartDataHistory:
                        ChoanChart().handleDataHutSua(state.hutSua),
                    chartDataByDay:
                        ChoanChart().handleDataHutSuaByDay(state.hutSuaByDay),
                    hutSua: state.hutSuaByDay,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
