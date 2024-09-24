// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/calendar/calendar_day.dart';
import 'package:flutter_ovumb_app_version1/data/models/calendar/ckkn.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/calendar/calendar_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/synchrozied_v2/synchrozied_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_state.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/calendar/calendar_builder1_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/calendar/calendar_builder2_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog_calendar.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

// màn hình hiển thị lịch
class CalendarScreen extends StatefulWidget {
  static const routeName = 'calendar-screen';
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CalendarScreen({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late List<CKKN> listCKKN;
  late DateTime now;
  late int phase;
  final _calendar = CalendarRepositoryV2();
  final _sync = SynchroziedRepositoryV2();

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _getPhase();
  }

  void _getPhase() async {
    final maNguoiDung = await SharedPreferencesService().id ?? '';
    final user = await LocalRepository().getNguoiDung(maNguoiDung);
    phase = user.phase!;
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.center,
          child: Text(
            'Lịch',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ).copyWith(
              color: rose500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
        title: BuildText(
          text: 'Ngày ${convertDateTime(DateTime.now())}',
          style: 17.text600,
          color: grey700,
        ),
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        elevation: 3,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/chu_thich_icon.png',
              scale: 3,
            ),
            onPressed: () {
              if (phase == 2) {
                dialogBuilder(context, screenSize);
              } else if (phase == 1) {
                dialogBuilder1(context, screenSize);
              } else {
                dialogBuilder2(context, screenSize);
              }
            },
            //onPressed: () => adsDialog(context, screenSize),
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/right_home_icon.png',
              scale: 3,
            ),
            onPressed: () => widget.scaffoldKey.currentState!.openEndDrawer(),
          ),
        ],
      ),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state.user != null) {
            if (state.user!.phase == 1) {
              _calendar.getCalendarData();
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24, left: 24),
                  child: StreamBuilder<CalendarDay>(
                    stream: _calendar.streamData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        DateTime firstDay = snapshot.data!.listKinh.first;
                        DateTime lastDay = snapshot.data!.listTrung.last;
                        final listRange = getMonthDateRange(firstDay, lastDay);
                        return OfflineBuilder(
                          connectivityBuilder: (
                            BuildContext context,
                            ConnectivityResult connectivity,
                            Widget child,
                          ) {
                            //khi có mạng kiểm tra đồng bộ dữ liệu
                            _sync.synchroziedAll(context);
                            return CalendarBuild1Screen(
                              nguoiDung: state.user!,
                              listCalendar: snapshot.data!,
                              listCauHoi: state.listCauHoi,
                              listRange: listRange,
                            );
                          },
                          child: const SizedBox(),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              );
            } else {
              _calendar.getCalendarData();
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24, left: 24),
                  child: StreamBuilder<CalendarDay>(
                    stream: _calendar.streamData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        DateTime firstDay = snapshot.data!.listKinh.first;
                        DateTime lastDay = snapshot.data!.listTrung.last;
                        final listRange = getMonthDateRange(firstDay, lastDay);
                        return OfflineBuilder(
                          connectivityBuilder: (
                            BuildContext context,
                            ConnectivityResult connectivity,
                            Widget child,
                          ) {
                            //khi có mạng kiểm tra đồng bộ dữ liệu
                            _sync.synchroziedAll(context);
                            return CalendarBuild2Screen(
                              nguoiDung: state.user!,
                              listCalendar: snapshot.data!,
                              listCauHoi: state.listCauHoi,
                              listRange: listRange,
                            );
                          },
                          child: const SizedBox(),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }
}
