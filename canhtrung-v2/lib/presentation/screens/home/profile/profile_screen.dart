// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_launch_url.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/kinhnguyet_v2/kinhnguyet_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_state.dart';
import 'package:flutter_ovumb_app_version1/logic/bmi/bmi_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/FAQ/faq_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/profile/profile_edit_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/reminder/reminder_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_guide_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/profile/profile_update_kn_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/constant/link.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/klogout_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kmenu_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/avatar_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/network_image.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profile-screen';
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ProfileScreen({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _kinhnguyet = KinhNguyetRepositoryV2();

  final buttons = [
    ['assets/icons/hand_holding_heart_icon.png', 'Thông tin sức khỏe'],
    ['assets/icons/bell_icon.png', 'Nhắc nhở quan trọng'],
    ['assets/icons/interrogation_icon.png', 'Câu hỏi thường gặp'],
    ['assets/icons/marquee_icon.png', 'Hướng dẫn Test'],
  ];

  handleButtonPressed(int index) async {
    switch (index) {
      case 0:
        KinhNguyet? current = await _kinhnguyet.localGetKN(trangThai: 1);
        context.pushNamed(ProfileUpdateKNScreen.routeName, arguments: current);
        break;
      case 1:
        context.pushNamed(ReminderScreen.routeName);
        break;
      case 2:
        context.pushNamed(FAQScreen.routeName);
        break;
      case 3:
        context.pushNamed(TestGuideScreen.routeName);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BuildText(
          text: 'Thông Tin Cá Nhân',
          style: 17.text600,
          color: rose500,
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        elevation: 3,
        actions: [
          kMenuButton(
            context,
            color: rose400,
            onTap: () => widget.scaffoldKey.currentState!.openEndDrawer(),
          ),
        ],
      ),
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state.user != null) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _buildHeader(state.user!),
                      24.verticalSpace,
                      _buildUserInfo(state.user!),
                      20.verticalSpace,
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(height: 1, color: grey300),
                      ),
                      20.verticalSpace,
                      _buildActions(state.user!),
                      20.verticalSpace,
                      KLogoutButton(),
                      20.verticalSpace,
                    ],
                  ),
                ),
              ),
            );
          }
          return const Loading();
        },
      ),
    );
  }

  _buildHeader(NguoiDung user) {
    return Row(
      children: [
        networkImageWithCached(
          size: Size(50.h, 50.h),
          url: user.avatar,
          borderRadius: 1000,
          boxBorder: Border.all(color: rose200, width: 2),
          placeholder: defaultAvatar(Size(50.h, 50.h)),
          onTap: () => showAvatarDialog(context, image: user.avatar),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuildText(
                  text: 'Xin Chào',
                  style: 16.text400,
                  color: grey700,
                ),
                BuildText(
                  text: user.tenNguoiDung,
                  style: 20.text700,
                  color: grey700,
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () =>
              context.pushNamed(ProfileEditScreen.routeName, arguments: user),
          icon: Image.asset(
            'assets/icons/edit_icon.png',
            scale: 3,
          ),
        ),
      ],
    );
  }

  _buildUserInfo(NguoiDung user) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            rose400,
            rose300,
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 30.w),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildText(
                      text: 'Cân nặng',
                      style: 12.text600,
                      color: whiteColor,
                    ),
                    BuildText(
                      text: (user.canNang ?? '--').toString() + 'kg',
                      style: 12.text300,
                      color: whiteColor,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildText(
                      text: 'Chiều cao',
                      style: 12.text600,
                      color: whiteColor,
                    ),
                    BuildText(
                      text: (user.chieuCao ?? '--').toString() + 'cm',
                      style: 12.text300,
                      color: whiteColor,
                    ),
                  ],
                ),
              ],
            ),
            30.horizontalSpace,
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    height: 50.h,
                    child: const VerticalDivider(color: Colors.white, width: 3),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                BuildText(
                                  text: 'BMI',
                                  style: 18.text700,
                                  color: whiteColor,
                                ),
                                6.horizontalSpace,
                                InkWell(
                                  onTap: () async => await LaunchUrl.webLink(
                                      context: context, link: linkBMI),
                                  child: BuildText(
                                    text: 'Chỉ số BMI',
                                    style: 12.text300,
                                    color: whiteColor,
                                    textDecoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                            BuildText(
                              text: (BMI.calculateBMI(
                                        user.canNang,
                                        user.chieuCao,
                                      ) ??
                                      '--')
                                  .toString(),
                              style: 12.text300,
                              color: whiteColor,
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Đánh giá: ',
                                  style:
                                      12.text700.copyWith(color: whiteColor)),
                              TextSpan(
                                  text: BMI
                                      .evaluateBMI(BMI.calculateBMI(
                                          user.canNang, user.chieuCao))
                                      .result,
                                  style:
                                      12.text400.copyWith(color: whiteColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildActions(NguoiDung user) {
    return Column(
      children: List.generate(
        buttons.length,
        (index) => InkWell(
          onTap: () => handleButtonPressed(index),
          child: Ink(
            padding: EdgeInsets.only(bottom: 14.h),
            height: 64.h,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: grey300, width: 1)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(
                            buttons[index][0],
                            scale: 3,
                          ),
                          20.horizontalSpace,
                          Expanded(
                            child: BuildText(
                              text: buttons[index][1],
                              style: 16.text600,
                              color: grey700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      IconApp.next,
                      alignment: Alignment.centerRight,
                      scale: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
