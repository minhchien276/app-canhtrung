// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/calendar/calendar_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_state.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/home_phase1_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/home_phase2_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/home_teenage_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/main_store_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/shimmer/home_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kmenu_button.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home-screen';
  final int phase;
  const HomeScreen({
    Key? key,
    required this.phase,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _calendar = CalendarRepositoryV2();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Image.asset(
          widget.phase == 5 ? ImageApp.logoVTNAppbar : ImageApp.logoAppbar,
          scale: 3,
        ),
        centerTitle: true,
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(
              MainStoreScreen.routeName,
              arguments: true,
            ),
            icon: Image.asset(
              IconApp.shop,
              scale: 4,
              color: Color(0xffFD6F8E),
            ),
          ),
          kMenuButton(
            context,
            onTap: () => Scaffold.of(context).openEndDrawer(),
            color: Color(0xffFD6F8E),
          ),
        ],
      ),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state.user != null) {
            NguoiDung user = state.user!;
            PhaseEnum phase = PhaseEnum.getPhase(user.phase);
            _calendar.getCalendarData();
            if (phase == PhaseEnum.trung) {
              return HomePhase1Screen(
                nguoiDung: user,
                listCauHoi: state.listCauHoi,
                age: getAge(user.namSinh),
              );
            } else if (phase == PhaseEnum.antoan) {
              return HomePhase2Screen(
                nguoiDung: user,
                listCauHoi: state.listCauHoi,
              );
            } else if (phase == PhaseEnum.vithanhnien) {
              return HomeTeenageScreen(
                nguoiDung: user,
                listCauHoi: state.listCauHoi,
                age: getAge(user.namSinh),
              );
            }
          }
          return getShimmer(HomeShimmer());
        },
      ),
    );
  }
}
