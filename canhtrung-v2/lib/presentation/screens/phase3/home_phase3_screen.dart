// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/constant/bmi_baby.dart';
import 'package:flutter_ovumb_app_version1/data/enum/blog_type.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_home3.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_launch_url.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_phattrien.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/choan.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/phattriencon.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/trieuchung.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/logic/upgrade/upgrade_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_phase3_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_circle.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/baby/baby_add_widget.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/home_phase3_disconnect.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/hutsua/hut_sua_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/kichsua/kich_sua_qrcode.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/suckhoe_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/baby/baby_update_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/widgets/home3_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/widgets/home3_container.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/widgets/home3_rectangle.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/main_store_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/constant/link.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/shimmer/home3_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kmenu_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/avatar_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/remove_baby_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/home/home_half_container.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/network_image.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/home/home_full_container.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_ovumb_app_version1/services/notification/fcm_notification_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePhase3Scren extends StatefulWidget {
  static const routeName = 'home3-screen';
  const HomePhase3Scren({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePhase3Scren> createState() => _HomePhase3ScrenState();
}

class _HomePhase3ScrenState extends State<HomePhase3Scren> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int countDown = 0;

  @override
  void initState() {
    FcmNotificationService().registerTopic(PhaseEnum.sua);
    UpgraderLogic().checkVersion(context: context, dayNextRequest: 2);
    context.read<MilkBloc>().add(CheckBabyExistEvent());
    super.initState();
  }

  String _buildBMItext(Con? con, PhatTrienCon? phatTrienCon) {
    if (con != null) {
      if (phatTrienCon != null) {
        if (phatTrienCon.canNang != null && phatTrienCon.chieuCao != null) {
          int index = BMIBaby.evaluateBMI(
              con, BMIBaby.calculateBMI(phatTrienCon) ?? 0.0);
          return dataPhatTrienChiTiet[index].thetrang;
        }
      }
    }
    return '- - - - -';
  }

  String _buildChoAntext(List<ChoAn> choAn) {
    double totalGam = 0;
    double totalMl = 0;
    choAn.forEach((e) {
      if (e.maLoaiChoAn != 4) {
        totalMl += e.trongLuong;
      } else {
        totalGam += e.trongLuong;
      }
    });

    return '${totalMl.round()}ml-${totalGam.round()}gam';
  }

  String _buildTrieuChungtext(TrieuChung? trieuChung) {
    if (trieuChung == null) return '- - - - -';
    return trieuChung.dauHieu!.split(';')[0];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var statusHeight = MediaQuery.of(context).viewPadding.top;
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Stack(
          children: [
            SizedBox(
              height: size.height * 0.25 + statusHeight,
              width: context.width,
              child: Image.asset(
                Imgs.phase4HeaderBg,
                fit: BoxFit.cover,
              ),
            ),
            Scaffold(
              key: scaffoldKey,
              endDrawer: GlobalDrawer(
                size: size,
                scaffoldKey: scaffoldKey,
              ),
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    onPressed: () => context.pushNamed(
                      MainStoreScreen.routeName,
                      arguments: true,
                    ),
                    icon: Image.asset(
                      IconApp.shop,
                      scale: 4,
                      color: Colors.white,
                    ),
                  ),
                  kMenuButton(
                    context,
                    onTap: () => scaffoldKey.currentState!.openEndDrawer(),
                  ),
                ],
              ),
              body: BlocConsumer<MilkBloc, MilkState>(
                buildWhen: (previous, current) {
                  if (current.isLoading == LoadingStatus.begin &&
                      previous.isLoading != LoadingStatus.begin) {
                    LoadingCircle().show(context: context);
                  } else {
                    LoadingCircle().hide();
                  }
                  return true;
                },
                listener: (context, state) {
                  if (state.message != null) {
                    showToast(context, state.message ?? '');
                  }
                },
                builder: (context, state) {
                  if (state.status == LoadedStatus.disconnect) {
                    return HomePhase3DisconnectScreen(
                      onTap: () {
                        context.read<MilkBloc>().add(CheckBabyExistEvent());
                      },
                    );
                  } else {
                    if (state.isLoading == LoadingStatus.all) {
                      return getShimmer(Home3Shimmer());
                    } else {
                      if (state.babies.isEmpty) {
                        return BabyAddWidget();
                      }
                      Con? con = state.currentBaby;
                      PhatTrienCon? phatTrienCon = state.phatTrienCon.isNotEmpty
                          ? state.phatTrienCon.first
                          : null;
                      TrieuChung? trieuChung = state.trieuChung.isNotEmpty
                          ? state.trieuChung.first
                          : null;

                      return Padding(
                        padding: EdgeInsets.only(
                          left: 0,
                          right: 0,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  _header(size, con, phatTrienCon, trieuChung),
                                  10.verticalSpace,
                                  _tabbar(size, state),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                physics: const ClampingScrollPhysics(),
                                children: [
                                  Container(
                                    height: 230.h,
                                    width: size.width,
                                    margin: EdgeInsets.symmetric(
                                      vertical: 24,
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Home3Container(
                                          callback: () {
                                            context.pushNamed(
                                                KichSuaQRCode.routeName);
                                          },
                                          image: home3Box[0].image,
                                          text1: 'Cẩm nang',
                                          text2: 'Kích sữa & Lợi sữa',
                                          text3:
                                              'Bộ tài liệu kích sữa khoa học dành riêng cho mẹ',
                                          textButton: 'Đọc ngay ',
                                          color: Color(0xffFE7347),
                                        ),
                                        24.horizontalSpace,
                                        Home3Container(
                                          callback: () => context.pushNamed(
                                            HutSuaScreen.routeName,
                                            arguments: con,
                                          ),
                                          image: home3Box[1].image,
                                          text1: 'Tham gia',
                                          text2: 'Hành trình\nkích sữa',
                                          text3: 'Bổ sung lượng sữa hút của mẹ',
                                          textButton: 'Bắt đầu ',
                                          color: rose400,
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: HomeFullContainer(
                                        image: 'assets/images/sua.png',
                                        title:
                                            'Kích sữa_Lợi sữa & Chăm sóc trẻ sơ sinh',
                                        sub:
                                            'Tham gia cộng đồng gần 100.000 mẹ bỉm đang nuôi con bằng sữa mẹ!',
                                        textColor: rose400,
                                        fromColor: Colors.white,
                                        toColor: Colors.white,
                                        directFrom: Alignment.bottomCenter,
                                        directTo: Alignment.topCenter,
                                        shadow: BoxShadow(
                                          color: grey200.withOpacity(0.7),
                                          blurRadius: 3,
                                          spreadRadius: 1,
                                          offset: Offset(0, 0),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      await LaunchUrl.web(
                                        context: context,
                                        maLink: maKichSua,
                                        tenLink: linkKichSua,
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 20,
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                BlogPhase3Screen.routeName,
                                                arguments: BlogType.quanhe,
                                              );
                                            },
                                            child: HomeHalfContainer(
                                              gradientFrom: Color(0xff3988FF),
                                              gradientTo: Color(0xff84C4FE),
                                              title:
                                                  'Quan hệ an toàn\nsau sinh',
                                              sub: 'Tìm hiểu ngay',
                                              image:
                                                  'assets/images/doctor1.png',
                                              beginGradient: Alignment.topLeft,
                                              endGradient:
                                                  Alignment.bottomRight,
                                            ),
                                          ),
                                        ),
                                        20.horizontalSpace,
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                BlogPhase3Screen.routeName,
                                                arguments: BlogType.biquyet,
                                              );
                                            },
                                            child: HomeHalfContainer(
                                              gradientFrom: Color(0xffFE7347),
                                              gradientTo: Color(0xffFFB74A),
                                              title:
                                                  'Bí quyết chăm\ncon khoa học',
                                              sub: 'Tìm hiểu ngay',
                                              image: 'assets/images/sua2.png',
                                              beginGradient: Alignment.topLeft,
                                              endGradient:
                                                  Alignment.bottomRight,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  50.verticalSpace,
                                  IconButton(
                                    icon: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/trash.png',
                                          scale: 3,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Xóa thông tin bé',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: rose500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: con != null
                                        ? () async {
                                            bool? check =
                                                await removeBabyDialog(
                                                    context, con.ten);
                                            if (check == true) {
                                              context.read<MilkBloc>().add(
                                                  DeleteBabyEvent(con: con));
                                            }
                                          }
                                        : null,
                                  ),
                                  100.verticalSpace,
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _header(
    Size size,
    Con? con,
    PhatTrienCon? phatTrienCon,
    TrieuChung? trieuChung,
  ) =>
      Container(
        alignment: Alignment.topLeft,
        height: 92,
        width: size.width,
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              alignment: Alignment.topLeft,
              width: size.width * 0.25,
              decoration: BoxDecoration(
                color: rose100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: rose300),
              ),
              child: networkImageWithCached(
                size: Size(size.width * 0.25, size.width * 0.25),
                url: con?.avatar,
                borderRadius: 14,
                placeholder:
                    defaultAvatar(Size(size.width * 0.25, size.width * 0.25)),
                onTap: () => showAvatarDialog(context, image: con?.avatar),
              ),
            ),
            SizedBox(width: size.width * 0.03),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 30,
                    width: size.width * 0.58,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleText(
                          text: con?.ten ?? '',
                          fontWeight: FontWeight.w700,
                          size: 18,
                          color: whiteColor,
                        ),
                        IconButton(
                          icon: Image.asset(
                            'assets/images/pen.png',
                            scale: 2,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              BabyUpdateScreen.routeName,
                              arguments: con,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //color: Colors.blue,
                    height: 62,
                    width: size.width * 0.58,
                    child: Row(
                      children: [
                        Home3Rectangle(
                          title: home3Infor[0].title,
                          text: phatTrienCon != null
                              ? phatTrienCon.chieuCao
                              : null,
                          subText: home3Infor[0].detail,
                        ),
                        Home3Rectangle(
                          title: home3Infor[1].title,
                          text: phatTrienCon != null
                              ? phatTrienCon.canNang
                              : null,
                          subText: home3Infor[1].detail,
                        ),
                        Home3Rectangle(
                          title: home3Infor[2].title,
                          text: con?.gioiTinh ?? '',
                          subText: '',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  _tabbar(Size size, MilkState state) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        height: 160,
        width: size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 12,
              offset: Offset(1, 5),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      SucKhoeScreen.routeName,
                      arguments: {
                        'con': state.babies.first,
                        'index': 0,
                      },
                    );
                  },
                  child: Home3Button(
                    image: home3List[0].image,
                    title: home3List[0].title,
                    subTitle: _buildChoAntext(state.choAn),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SucKhoeScreen.routeName,
                    arguments: {
                      'con': state.babies.first,
                      'index': 1,
                    },
                  );
                },
                child: Home3Button(
                  image: home3List[1].image,
                  title: home3List[1].title,
                  subTitle: _buildBMItext(
                      state.currentBaby,
                      state.phatTrienCon.isNotEmpty
                          ? state.phatTrienCon.first
                          : null),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SucKhoeScreen.routeName,
                    arguments: {
                      'con': state.babies.first,
                      'index': 2,
                    },
                  );
                },
                child: Home3Button(
                  image: home3List[2].image,
                  title: home3List[2].title,
                  subTitle: _buildTrieuChungtext(state.trieuChung.isNotEmpty
                      ? state.trieuChung.first
                      : null),
                ),
              ),
            ),
          ],
        ),
      );
}
