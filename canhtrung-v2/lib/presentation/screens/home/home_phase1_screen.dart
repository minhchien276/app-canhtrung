// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_launch_url.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/calendar/calendar_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/synchrozied_v2/synchrozied_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/widgets/home_phase1_widgets.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/widgets/home_showcase.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/nhatky_screen_v2.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/constant/link.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/home/home_calendar_phase1.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_ovumb_app_version1/services/notification/fcm_notification_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_ovumb_app_version1/data/constant/constant.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/calendar/calendar_day.dart';
import 'package:flutter_ovumb_app_version1/data/models/calendar/ckkn_display.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/cau_hoi.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_event.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_manage_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/tu_van/tuvan1_screen.dart';

class HomePhase1Screen extends StatefulWidget {
  final NguoiDung nguoiDung;
  final List<CauHoi> listCauHoi;
  final int age;
  const HomePhase1Screen({
    Key? key,
    required this.nguoiDung,
    required this.listCauHoi,
    required this.age,
  }) : super(key: key);

  @override
  State<HomePhase1Screen> createState() => _HomePhase1ScreenState();
}

class _HomePhase1ScreenState extends State<HomePhase1Screen> {
  final _sync = SynchroziedRepositoryV2();
  final _calendar = CalendarRepositoryV2();
  final _prefs = SharedPreferencesService();

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  final GlobalKey _six = GlobalKey();
  bool _showCaseView = true;

  @override
  void initState() {
    FcmNotificationService().registerTopic(PhaseEnum.trung);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 500));
      ShowCaseWidget.of(context)
          .startShowCase([_one, _two, _three, _four, _five, _six]);
    });
    _checkShowCaseView();
    super.initState();
  }

  void _checkShowCaseView() async {
    bool showCaseView = await _prefs.showCase ?? true;
    setState(() {
      _showCaseView = showCaseView;
    });
    Future.delayed(Duration(seconds: 10), () async {
      await _prefs.setShowCaseView(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _showCaseView
                      ? InkWell(
                          onTap: () async {
                            await LaunchUrl.web(
                              context: context,
                              tenLink: linkSinhConTrai,
                              maLink: maLinkSinhConTrai,
                            );
                          },
                          child: HomeShowcase(
                            currentKey: _one,
                            nextKey: _two,
                            text: SHOW_CASE2[0],
                            container: containerHoiConTrai,
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            await LaunchUrl.web(
                              context: context,
                              tenLink: linkSinhConTrai,
                              maLink: maLinkSinhConTrai,
                            );
                          },
                          child: containerHoiConTrai,
                        ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: InkWell(
                    child: HomeShowcase(
                      currentKey: _two,
                      nextKey: _three,
                      text: SHOW_CASE2[1],
                      container: containerHoiConGai,
                    ),
                    onTap: () async {
                      await LaunchUrl.web(
                        context: context,
                        tenLink: linkSinhConGai,
                        maLink: maLinkSinhConGai,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // ///ontap screen nhat ky
          InkWell(
            child: HomeShowcase(
              currentKey: _three,
              nextKey: _four,
              text: SHOW_CASE2[2],
              container: containerNhatKy,
              isFull: true,
            ),
            onTap: () => context.pushNamed(NhatkyScreenV2.routeName,
                arguments: DateTime.now().formatStartDate()),
          ),
          10.verticalSpace,
          HomeShowcase(
            currentKey: _four,
            nextKey: _five,
            text: SHOW_CASE2[3],
            container: Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: StreamBuilder<CalendarDay>(
                stream: _calendar.streamData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    CKKNDisplay ckknDisplay = getCKKNDisplay(
                      snapshot.data!.currentKinhNguyet,
                      snapshot.data!.futureKinhNguyet,
                      1,
                    );

                    return OfflineBuilder(
                      connectivityBuilder: (
                        BuildContext context,
                        ConnectivityResult connectivity,
                        Widget child,
                      ) {
                        _sync.synchroziedAll(context);
                        return HomeCalendarPhase1(
                          listCalendar: snapshot.data!,
                          ckknDisplay: ckknDisplay,
                          listCauHoi: widget.listCauHoi,
                          nguoiDung: widget.nguoiDung,
                        );
                      },
                      child: const SizedBox(),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            isFull: true,
          ),

          10.verticalSpace,
          InkWell(
            child: HomeShowcase(
              currentKey: _five,
              nextKey: _six,
              text: SHOW_CASE2[4],
              container: containerQuanLyQueTest,
              isFull: true,
            ),
            onTap: () {
              context.pushNamed(TestManageScreen.routeName);
              context.read<TestBloc>().add(TestCheckEvent());
            },
          ),
          10.verticalSpace,
          InkWell(
            child: HomeShowcase(
              currentKey: _six,
              text: SHOW_CASE2[5],
              container: containerKienThucSinhSan,
              isFull: true,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Tuvan1Screen(
                    widgetId: 0,
                    phase: 2,
                    maNguoiDung: widget.nguoiDung.maNguoiDung,
                  ),
                ),
              );
            },
          ),
          200.verticalSpace,
        ],
      ),
    );
  }
}
