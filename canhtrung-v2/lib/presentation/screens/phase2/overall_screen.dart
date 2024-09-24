import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/synchrozied_v2/synchrozied_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/logic/upgrade/upgrade_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/main_store_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/services/notification/fcm_notification_service.dart';
import '../../widgets/drawer/global_drawer.dart';
import 'body_overall_screen.dart';

class OverallScreen extends StatefulWidget {
  static const routeName = 'overall-screen';
  final int widgetId;
  final DateTime ngayDuSinh;
  const OverallScreen({
    super.key,
    required this.widgetId,
    required this.ngayDuSinh,
  });

  @override
  State<OverallScreen> createState() => _OverallScreenState();
}

class _OverallScreenState extends State<OverallScreen> {
  bool isCheckButton = false; // true => show button Chi tiet
  bool isShowDetail = false;
  int selectedIndex = 0;
  final _sycn = SynchroziedRepositoryV2();

  @override
  void initState() {
    super.initState();
    _sycn.synchroziedAll(context);
    UpgraderLogic().checkVersion(context: context, dayNextRequest: 2);
    FcmNotificationService().registerTopic(PhaseEnum.thai);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
      child: Scaffold(
        key: scaffoldKey,
        endDrawer: GlobalDrawer(
          size: screenSize,
          scaffoldKey: scaffoldKey,
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Image.asset(
            ImageApp.logoAppbar,
            scale: 3,
          ),
          centerTitle: true,
          leading: const Text(''),
          backgroundColor: whiteColor,
          shadowColor: whiteColor,
          bottomOpacity: 0.1,
          elevation: 3,
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(
                context,
                MainStoreScreen.routeName,
                arguments: true,
              ),
              icon: Image.asset(
                'assets/stores/shop.png',
                scale: 4,
                color: Color(0xffFD6F8E),
              ),
            ),
            IconButton(
              onPressed: () => scaffoldKey.currentState!.openEndDrawer(),
              icon: Image.asset(
                'assets/icons/right_home_icon.png',
                scale: 3,
              ),
            ),
          ],
        ),
        body: BodyOverall(
          widgetId: 0,
          ngayDuSinh: widget.ngayDuSinh,
          clickId: 0,
        ),
      ),
    );
  }
}

