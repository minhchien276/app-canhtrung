// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/constant/choose_phase.dart';
import 'package:flutter_ovumb_app_version1/data/enum/age_enum.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_launch_url.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_state.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/reminder/reminder_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/password/change_password_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/baby/baby_add_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/widgets/home3_baby_logo.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/main_store_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/constant/link.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/klogout_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/drawer_button_custom.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/gridview_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//drawer kéo ra kéo vào dùng cho mọi màn hình
class GlobalDrawer extends StatefulWidget {
  const GlobalDrawer({
    Key? key,
    required this.size,
    required this.scaffoldKey,
  }) : super(key: key);

  final Size size;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<GlobalDrawer> createState() => _GlobalDrawerState();
}

class _GlobalDrawerState extends State<GlobalDrawer> {
  @override
  void initState() {
    context.read<AuthBloc>().add(AuthOpenDrawer());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: context.width * 0.8,
      backgroundColor: whiteColor,
      child: DrawerHeader(
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthStateLogged) {
              final user = state.user;
              return ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  _buildHeader(user),
                  if (PhaseEnum.getPhase(user.phase) == PhaseEnum.sua) ...[
                    _buildBaby(),
                  ],
                  _buildGridPhase(user),
                  10.verticalSpace,
                  _buildListTile(user),
                  20.verticalSpace,
                  KLogoutButton(),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  _buildHeader(NguoiDung user) {
    return Container(
      height: 140.h,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            rose500,
            rose400,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  Imgs.ovumbText,
                  color: whiteColor,
                  scale: 4,
                ),
                IconButton(
                  onPressed: () =>
                      widget.scaffoldKey.currentState!.closeEndDrawer(),
                  icon: Image.asset(
                    IconApp.close,
                    scale: 3,
                  ),
                ),
              ],
            ),
            20.verticalSpace,
            Expanded(
              child: BuildText(
                text: 'Xin chào,\n${user.tenNguoiDung} ',
                style: 16.text700,
                color: whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildGridPhase(NguoiDung user) {
    return AgeEnum.toEnum(user.namSinh) == AgeEnum.adults
        ? Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GridviewDrawer(
                        index: 0,
                        user: user,
                        isActive: PhaseEnum.getPhase(user.phase) ==
                            choosePhase[0].type,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GridviewDrawer(
                        index: 1,
                        user: user,
                        isActive: PhaseEnum.getPhase(user.phase) ==
                            choosePhase[1].type,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.w),
                Row(
                  children: [
                    Expanded(
                      child: GridviewDrawer(
                        index: 2,
                        user: user,
                        isActive: PhaseEnum.getPhase(user.phase) ==
                            choosePhase[2].type,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GridviewDrawer(
                        index: 3,
                        user: user,
                        isActive: PhaseEnum.getPhase(user.phase) ==
                            choosePhase[3].type,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : InkWell(
            onTap: () async {
              await LaunchUrl.web(
                context: context,
                tenLink: linkRenoil,
                maLink: maRenoil,
              );
            },
            child: Image.asset(Imgs.renoil, scale: 3),
          );
  }

  _buildListTile(NguoiDung user) {
    return Column(
      children: [
        DrawerButtonCustom(
          icon: IconApp.cart,
          title: 'Cửa hàng OvumB',
          onTap: () =>
              context.pushNamed(MainStoreScreen.routeName, arguments: true),
        ),
        if (PhaseEnum.getPhase(user.phase) != PhaseEnum.vithanhnien) ...[
          DrawerButtonCustom(
            icon: IconApp.share,
            title: 'Cộng đồng OvumB',
            onTap: () async {
              context.pop();
              await LaunchUrl.web(
                context: context,
                maLink: maLinkOvumbCommunity,
                tenLink: linkOvumbCommunity,
              );
            },
          ),
        ],
        DrawerButtonCustom(
          icon: IconApp.lock,
          title: 'Thay đổi mật khẩu',
          onTap: () => context.pushNamed(ChangePasswordScreen.routeName),
        ),
        DrawerButtonCustom(
          icon: IconApp.call,
          title: 'Hỗ trợ kỹ thuật',
          onTap: () async {
            context.pop();
            await LaunchUrl.webLink(
              context: context,
              link: linkSupport,
            );
          },
        ),
        DrawerButtonCustom(
          icon: IconApp.bellRounded,
          title: 'Nhắc nhở quan trọng',
          onTap: () => context.pushNamed(ReminderScreen.routeName),
        ),
      ],
    );
  }

  _buildBaby() {
    return Container(
      height: 130,
      padding: EdgeInsets.only(left: 24, right: 24, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            text: 'Quản lý bé',
            fontWeight: FontWeight.w600,
            size: 16,
            color: greyText,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<MilkBloc, MilkState>(
              builder: (context, state) {
                List<Con> listCon = state.babies;
                return Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: listCon.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              context
                                  .read<MilkBloc>()
                                  .add(SwitchBabyEvent(con: listCon[index]));
                            },
                            child: Home3BabyLogo(
                              con: listCon[index],
                            ),
                          );
                        },
                      ),
                    ),
                    if (listCon.length < 3) ...[
                      InkWell(
                        onTap: () {
                          widget.scaffoldKey.currentState!.closeEndDrawer();
                          if (listCon.length != 0) {
                            Navigator.pushNamed(
                                context, BabyAddScreen.routeName);
                          }
                        },
                        child: Container(
                          height: 35,
                          width: 120,
                          decoration: BoxDecoration(
                            color: rose50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/plus.png',
                                scale: 4,
                                color: Color(0xffFD6F8E),
                              ),
                              Text(
                                ' Thêm bé',
                                style: TextStyle(
                                  color: Color(0xffFD6F8E),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

switchPhaseBottomSheet(
  BuildContext context, {
  required int phase,
  required String title,
  required VoidCallback onTap,
}) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(26),
      ),
    ),
    isScrollControlled: true,
    barrierColor: grey900.withOpacity(0.4),
    context: context,
    builder: (context) {
      return ModalBottomDrawer(
        phase: 1,
        title: title,
        onTap: onTap,
      );
    },
  );
}

class ModalBottomDrawer extends StatelessWidget {
  final int phase;
  final String title;
  final VoidCallback onTap;
  const ModalBottomDrawer({
    Key? key,
    required this.phase,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 24.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BuildText(
              text: 'Lưu ý',
              style: 18.text700,
              color: rose500,
            ),
            20.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 70.w),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      'Sau khi thao tác xóa hồ sơ thai kỳ của bạn thì tính năng ',
                  style: 14.text400.copyWith(color: grey700),
                  children: [
                    TextSpan(
                      text: title,
                      style: 14.text600.copyWith(color: grey700),
                      children: [
                        TextSpan(
                            text: ' sẽ bắt đầu',
                            style: 14.text400.copyWith(color: grey700)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                KSubmitButton(
                  size: Size(context.width * 0.4, 50.h),
                  text: 'Quay lại',
                  bgColor: rose25,
                  textColor: rose400,
                  onTap: () => context.pop(),
                ),
                KSubmitButton(
                  size: Size(context.width * 0.4, 50.h),
                  text: 'Xóa thai kỳ',
                  bgColor: rose500,
                  textColor: whiteColor,
                  onTap: onTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
