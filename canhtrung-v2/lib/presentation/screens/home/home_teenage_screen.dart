// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_launch_url.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/calendar/calendar_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/synchrozied_v2/synchrozied_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/widgets/home_phase1_widgets.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/widgets/home_showcase.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/nhatky_screen_v2.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/tu_van/giao_duc_gioi_tinh_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/constant/link.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
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
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/home/home_calendar_phase2.dart';

class HomeTeenageScreen extends StatefulWidget {
  final NguoiDung nguoiDung;
  final List<CauHoi> listCauHoi;
  final int age;
  const HomeTeenageScreen({
    Key? key,
    required this.nguoiDung,
    required this.listCauHoi,
    required this.age,
  }) : super(key: key);

  @override
  State<HomeTeenageScreen> createState() => _HomeTeenageScreenState();
}

class _HomeTeenageScreenState extends State<HomeTeenageScreen> {
  final _sync = SynchroziedRepositoryV2();
  final _calendar = CalendarRepositoryV2();
  final _prefs = SharedPreferencesService();

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();
  bool _showCaseView = true;

  @override
  void initState() {
    FcmNotificationService().registerTopic(PhaseEnum.vithanhnien);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 500));
      ShowCaseWidget.of(context)
          .startShowCase([_one, _two, _three, _four, _five]);
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
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _showCaseView
                      ? InkWell(
                          onTap: () async {
                            await LaunchUrl.web(
                              context: context,
                              tenLink: linkLinkBiQuyetDa,
                              maLink: maLinkBiQuyetDa,
                            );
                          },
                          child: HomeShowcase(
                            currentKey: _one,
                            nextKey: _two,
                            text: SHOW_CASE3[0],
                            container: containerBiQuyet,
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            await LaunchUrl.web(
                              context: context,
                              tenLink: linkLinkBiQuyetDa,
                              maLink: maLinkBiQuyetDa,
                            );
                          },
                          child: containerBiQuyet,
                        ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: InkWell(
                    child: HomeShowcase(
                      currentKey: _two,
                      nextKey: _three,
                      text: SHOW_CASE3[1],
                      container: containerGDGT,
                    ),
                    onTap: () async {
                      context.pushNamed(
                        GiaoDucGioiTinhScreen.routeName,
                        arguments: widget.nguoiDung.maNguoiDung,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            child: HomeShowcase(
              currentKey: _three,
              nextKey: _four,
              text: SHOW_CASE3[2],
              container: containerNhatKy,
            ),
            onTap: () async {
              context.pushNamed(
                NhatkyScreenV2.routeName,
                arguments: DateTime.now().formatStartDate(),
              );
            },
          ),
          10.verticalSpace,
          InkWell(
            child: HomeShowcase(
              currentKey: _four,
              nextKey: _five,
              text: SHOW_CASE3[3],
              container: Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: StreamBuilder<CalendarDay>(
                  stream: _calendar.streamData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      CKKNDisplay ckknDisplay = getCKKNDisplay(
                        snapshot.data!.currentKinhNguyet,
                        snapshot.data!.futureKinhNguyet,
                        5,
                      );

                      return OfflineBuilder(
                        connectivityBuilder: (
                          BuildContext context,
                          ConnectivityResult connectivity,
                          Widget child,
                        ) {
                          _sync.synchroziedAll(context);
                          return HomeCalendarPhase2(
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
            ),
          ),
          10.verticalSpace,
          InkWell(
            child: HomeShowcase(
              currentKey: _five,
              text: SHOW_CASE3[4],
              container: containerMeoHayTuoiDayThi,
            ),
            onTap: () {
              context.pushNamed(BlogScreen.routeName, arguments: 3);
            },
          ),
          200.verticalSpace,
        ],
      ),
    );
  }
}
