// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/chat/chat_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/synchrozied_v2/synchrozied_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/logic/upgrade/upgrade_logic.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:flutter_ovumb_app_version1/logic/ads/ads.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_event.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/calendar/calendar_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/chart/chart_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/profile/profile_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';
import '../../utils/color.dart';
import '../../widgets/home/home_tabbar.dart';
import 'home_screen.dart';

//màn hình main chính
class MainScreen extends StatefulWidget {
  static const String routeName = 'home-screen';
  final NguoiDung nguoiDung;
  const MainScreen({
    Key? key,
    required this.nguoiDung,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _sync = SynchroziedRepositoryV2();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentTab = 0;
  int index = -1;
  int countDown = 0;
  bool isShowAds = false;

  double left = 0;
  double top = 200;
  double spSize = 80;
  bool supportClick = false;
  final PageStorageBucket bucket = PageStorageBucket();
  final chatRepository = ChatRepository();

  @override
  void initState() {
    _sync.syncKinhNguyetWhenPassed();
    if (!isShowAds) {
      isShowAds = true;
      showAds(
        context: context,
        isToday: true,
        type: 0,
      );
    }

    UpgraderLogic().checkVersion(context: context, dayNextRequest: 2);
    onChangedTab(0);
    // chatRepository.sendMessage(
    //   MessageModel(
    //     id: 1,
    //     index: 1,
    //     text:
    //         'Chào Hiệp! Mời bạn bấm vào các nút bên dưới để khám phá các tính năng mà mình hỗ trợ nhé!',
    //     questions: ovumbCardData,
    //     senderType: SenderType.ovumb,
    //   ),
    // );
    super.initState();
  }

  //Widget currentScreen =  Home1(scaffoldKey: scaffoldKey,);
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final List<Widget> screens = [
      HomeScreen(phase: widget.nguoiDung.phase!),
      ChartScreen(),
      CalendarScreen(scaffoldKey: scaffoldKey),
      ProfileScreen(scaffoldKey: scaffoldKey),
    ];
    return PopScope(
      onPopInvoked: (bool didPop) {
        if (countDown == 1) {
          countDown = 0;
          SystemNavigator.pop();
        } else {
          showToast(context, 'Ấn lần nữa để THOÁT');
          countDown++;
        }
        Future.delayed(Duration(seconds: 2), () {
          countDown = 0;
        });
        return;
      },
      child: Scaffold(
        key: scaffoldKey,
        endDrawer: GlobalDrawer(
          size: screenSize,
          scaffoldKey: scaffoldKey,
        ),
        backgroundColor: whiteColor,
        body: Stack(
          children: [
            ShowCaseWidget(
              enableAutoScroll: true,
              builder: Builder(
                builder: (context) => screens[index],
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: HomeTabbar(
                index: index,
                phase: widget.nguoiDung.phase!,
                onChangedTab: onChangedTab,
              ),
            ),
            // Positioned(
            //   left: left,
            //   top: top,
            //   child: GestureDetector(
            //     onPanEnd: (details) {
            //       if (left > screenSize.width / 2) {
            //         left = screenSize.width - spSize;
            //       } else {
            //         left = 0;
            //       }

            //       if (top > screenSize.height - spSize) {
            //         top = screenSize.height - spSize;
            //       }
            //       setState(() {});
            //     },
            //     onPanUpdate: (details) {
            //       left = max(0, left + details.delta.dx);
            //       top = max(0, top + details.delta.dy);
            //       setState(() {});
            //     },
            //     child: InkWell(
            //       onTap: () {
            //         supportClick = true;
            //         setState(() {});
            //       },
            //       child: Container(
            //         height: spSize,
            //         width: spSize,
            //         decoration: BoxDecoration(
            //           image: DecorationImage(
            //             image: AssetImage(IconApp.support),
            //           ),
            //           borderRadius: BorderRadius.circular(100),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // if (supportClick) ...[
            //   Positioned(
            //     bottom: 0,
            //     child: InkWell(
            //       onTap: () {
            //         supportClick = false;
            //         setState(() {});
            //       },
            //       child: Container(
            //         height: screenSize.height,
            //         width: screenSize.width,
            //         color: Colors.black26,
            //         child: Stack(
            //           children: [
            //             Positioned(
            //               right: 50,
            //               top: screenSize.height * 0.2 - 75,
            //               child: Container(
            //                 height: 60,
            //                 width: 60,
            //                 decoration: BoxDecoration(
            //                   color: Colors.white,
            //                   borderRadius: BorderRadius.circular(100),
            //                   image: DecorationImage(
            //                     image: AssetImage(IconApp.support),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             Positioned(
            //               right: 60,
            //               top: screenSize.height * 0.2 - 15,
            //               child: CustomPaint(
            //                 painter: TrianglePainter(
            //                   strokeColor: Colors.white,
            //                   strokeWidth: 10,
            //                   paintingStyle: PaintingStyle.fill,
            //                 ),
            //                 child: Container(
            //                   height: 26,
            //                   width: 36,
            //                 ),
            //               ),
            //             ),
            //             Positioned(
            //               bottom: 0,
            //               child: InkWell(
            //                 onTap: () {},
            //                 child: Container(
            //                   height: screenSize.height * 0.8,
            //                   width: screenSize.width,
            //                   color: grey200,
            //                   padding: EdgeInsets.symmetric(
            //                       horizontal: 10, vertical: 10),
            //                   child: Column(
            //                     children: [
            //                       Row(
            //                         children: [
            //                           Image.asset(
            //                             IconApp.support,
            //                             height: 40,
            //                             width: 40,
            //                           ),
            //                           const SizedBox(width: 10),
            //                           TitleText(
            //                             text: 'Trợ lý ảo OvumB',
            //                             fontWeight: FontWeight.w700,
            //                             size: 14,
            //                             color: grey700,
            //                           ),
            //                         ],
            //                       ),
            //                       Expanded(
            //                         child: StreamBuilder<List<MessageModel>>(
            //                           stream: chatRepository.chatList(),
            //                           builder: (context, snapshot) {
            //                             if (snapshot.hasData &&
            //                                 snapshot.data != null) {
            //                               var data = snapshot.data;
            //                               return ListView.builder(
            //                                 physics:
            //                                     const ClampingScrollPhysics(),
            //                                 itemCount: data!.length,
            //                                 itemBuilder: (context, index) {
            //                                   return data[index].senderType ==
            //                                           SenderType.ovumb
            //                                       ? OvumbCard(
            //                                           message: data[index])
            //                                       : UserCard(
            //                                           message: data[index]);
            //                                 },
            //                               );
            //                             }
            //                             return const SizedBox();
            //                           },
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ],
          ],
        ),
      ),
    );
  }

  void onChangedTab(int index) {
    if (this.index != index) {
      setState(() {
        this.index = index;
      });
      switch (index) {
        case 0:
          context.read<MainBloc>().add(HomeEvent());
          break;
        case 1:
          context.read<MainBloc>().add(ChartEvent(context));
          break;
        case 2:
          context
              .read<MainBloc>()
              .add(CalendarEvent(id: widget.nguoiDung.maNguoiDung));
          break;
        case 3:
          context
              .read<MainBloc>()
              .add(ProfileEvent(id: widget.nguoiDung.maNguoiDung));
          break;
        default:
          break;
      }
    }
  }

  openTheDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
