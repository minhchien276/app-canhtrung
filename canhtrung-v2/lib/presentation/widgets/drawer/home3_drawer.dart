// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_ovumb_app_version1/data/constant/choose_phase.dart';
// import 'package:flutter_ovumb_app_version1/data/constant/constant.dart';
// import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
// import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
// import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
// import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
// import 'package:flutter_ovumb_app_version1/data/models/other/model_launch_url.dart';
// import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
// import 'package:flutter_ovumb_app_version1/logic/bloc/login/auth_bloc.dart';
// import 'package:flutter_ovumb_app_version1/logic/bloc/login/auth_event.dart';
// import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
// import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
// import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
// import 'package:flutter_ovumb_app_version1/presentation/screens/home/main_screen.dart';
// import 'package:flutter_ovumb_app_version1/presentation/screens/home/profile/widgets/profile_modal.dart';
// import 'package:flutter_ovumb_app_version1/presentation/screens/password/change_password_screen.dart';
// import 'package:flutter_ovumb_app_version1/presentation/screens/phase2/phase2_initial_screen.dart';
// import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/baby/baby_add_screen.dart';
// import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/home_phase3_screen.dart';
// import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/widgets/home3_baby_logo.dart';
// import 'package:flutter_ovumb_app_version1/presentation/screens/store/main_store_screen.dart';
// import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
// import 'package:flutter_ovumb_app_version1/presentation/utils/constant/link.dart';
// import 'package:flutter_ovumb_app_version1/presentation/utils/primary_font.dart';
// import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/transfer_phase_dialog.dart';
// import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/drawer_bottom_sheet_phase3.dart';
// import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/drawer_button_custom.dart';
// import 'package:flutter_ovumb_app_version1/presentation/widgets/gridview_drawer.dart';
// import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
// import 'package:flutter_ovumb_app_version1/router/router.dart';

// //drawer kéo ra kéo vào dùng cho mọi màn hình
// class Home3Drawer extends StatefulWidget {
//   const Home3Drawer({
//     Key? key,
//     required this.size,
//     required this.scaffoldKey,
//   }) : super(key: key);

//   final Size size;
//   final GlobalKey<ScaffoldState> scaffoldKey;

//   @override
//   State<Home3Drawer> createState() => _Home3DrawerState();
// }

// class _Home3DrawerState extends State<Home3Drawer> {
//   final _prefs = SharedPreferencesService();
//   final _local = LocalRepository();
//   NguoiDung? nguoiDung;

//   @override
//   void initState() {
//     super.initState();
//     getNguoiDung();
//   }

//   Future<NguoiDung> getNguoiDung() async {
//     final id = await SharedPreferencesService().id ?? '';
//     nguoiDung = await _local.getNguoiDung(id);
//     return nguoiDung!;
//   }

//   bool checkPhase(int phase, int currentPhase) {
//     return phase == currentPhase;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MediaQuery(
//       data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
//       child: Drawer(
//         width: widget.size.width * 0.8,
//         backgroundColor: whiteColor,
//         child: DrawerHeader(
//           padding: EdgeInsets.zero,
//           margin: EdgeInsets.zero,
//           child: FutureBuilder<NguoiDung>(
//             future: getNguoiDung(),
//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
//                 return ListView(
//                   children: [
//                     Container(
//                       height: 140,
//                       decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                           colors: [
//                             rose500,
//                             rose400,
//                           ],
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 24),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Image.asset(
//                                   'assets/images/logo_main.png',
//                                   color: whiteColor,
//                                   scale: 3,
//                                 ),
//                                 IconButton(
//                                   onPressed: () => widget
//                                       .scaffoldKey.currentState!
//                                       .closeEndDrawer(),
//                                   icon: Image.asset(
//                                     'assets/icons/x_icon.png',
//                                     scale: 3,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             TitleText(
//                               text:
//                                   'Xin chào,\n${snapshot.data!.tenNguoiDung} ',
//                               fontWeight: FontWeight.w700,
//                               size: 18,
//                               color: whiteColor,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 130,
//                       padding: EdgeInsets.only(left: 24, right: 24, top: 10),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TitleText(
//                             text: 'Quản lý bé',
//                             fontWeight: FontWeight.w600,
//                             size: 16,
//                             color: greyText,
//                           ),
//                           const SizedBox(height: 8),
//                           Expanded(
//                             child: BlocBuilder<MilkBloc, MilkState>(
//                               builder: (context, state) {
//                                 List<Con> listCon = state.babies;
//                                 return Row(
//                                   children: [
//                                     Expanded(
//                                       child: ListView.builder(
//                                         itemCount: listCon.length,
//                                         scrollDirection: Axis.horizontal,
//                                         itemBuilder: (context, index) {
//                                           return InkWell(
//                                             onTap: () async {
//                                               context.read<MilkBloc>().add(
//                                                   SwitchBabyEvent(
//                                                       con: listCon[index]));
//                                             },
//                                             child: Home3BabyLogo(
//                                               con: listCon[index],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                     if (listCon.length < 3) ...[
//                                       InkWell(
//                                         onTap: () {
//                                           widget.scaffoldKey.currentState!
//                                               .closeEndDrawer();
//                                           if (listCon.length != 0) {
//                                             Navigator.pushNamed(context,
//                                                 BabyAddScreen.routeName);
//                                           }
//                                         },
//                                         child: Container(
//                                           height: 35,
//                                           width: 120,
//                                           decoration: BoxDecoration(
//                                             color: rose50,
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                           ),
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Image.asset(
//                                                 'assets/icons/plus.png',
//                                                 scale: 4,
//                                                 color: Color(0xffFD6F8E),
//                                               ),
//                                               Text(
//                                                 ' Thêm bé',
//                                                 style: TextStyle(
//                                                   color: Color(0xffFD6F8E),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       height: 220,
//                       child: GridView.count(
//                         primary: false,
//                         shrinkWrap: true,
//                         physics: NeverScrollableScrollPhysics(),
//                         childAspectRatio: 14 / 9,
//                         padding: const EdgeInsets.all(24),
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10,
//                         crossAxisCount: 2,
//                         children: [
//                           InkWell(
//                             onTap: () async {
//                               if (snapshot.data!.phase! == 3) {
//                                 drawerShowBottomSheetPhase3(context,
//                                     phase: 1, title: TITILE_DRAWER_PHASE1);
//                               } else if (snapshot.data!.phase! == 4) {
//                                 final check = await transferPhaseDialog(
//                                     context, TITILE_DRAWER_PHASE1);
//                                 if (check == true) {
//                                   await _local.updatePhase(1);
//                                   context.goName(MainScreen.routeName,
//                                       arguments: nguoiDung);
//                                 }
//                               } else if (!checkPhase(
//                                   1, snapshot.data!.phase!)) {
//                                 final check = await transferPhaseDialog(
//                                     context, TITILE_DRAWER_PHASE1);
//                                 if (check == true) {
//                                   await _local.updatePhase(1);
//                                   context.read<AuthBloc>().add(
//                                       AuthSwitchPhase(phase: PhaseEnum.trung));
//                                   context.goName(MainScreen.routeName,
//                                       arguments: nguoiDung);
//                                 }
//                               }
//                             },
//                             child: GridviewDrawer(
//                               text1: choosePhase[0].title,
//                               text2: choosePhase[0].subTitle,
//                               imageUrl: 'assets/images/choose_image2.png',
//                               fromColor: rose500,
//                               toColor: rose400,
//                               isSelected: checkPhase(1, nguoiDung!.phase!),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               if (snapshot.data!.phase! == 3) {
//                                 drawerShowBottomSheetPhase3(context,
//                                     phase: 2, title: TITILE_DRAWER_PHASE2);
//                               } else if (snapshot.data!.phase! == 4) {
//                                 final check = await transferPhaseDialog(
//                                     context, TITILE_DRAWER_PHASE2);
//                                 if (check == true) {
//                                   await _local.updatePhase(2);
//                                   context.goName(MainScreen.routeName,
//                                       arguments: nguoiDung);
//                                 }
//                               } else if (!checkPhase(
//                                   2, snapshot.data!.phase!)) {
//                                 final check = await transferPhaseDialog(
//                                     context, TITILE_DRAWER_PHASE2);
//                                 if (check == true) {
//                                   await _local.updatePhase(2);
//                                   context.read<AuthBloc>().add(
//                                       AuthSwitchPhase(phase: PhaseEnum.antoan));
//                                   context.goName(MainScreen.routeName,
//                                       arguments: nguoiDung);
//                                 }
//                               }
//                             },
//                             child: GridviewDrawer(
//                               text1: choosePhase[1].title,
//                               text2: choosePhase[1].subTitle,
//                               imageUrl: 'assets/images/choose_image1.png',
//                               fromColor: violet500,
//                               toColor: violet400,
//                               isSelected: checkPhase(2, snapshot.data!.phase!),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               if (snapshot.data!.phase! == 3) {
//                                 drawerShowBottomSheetPhase3(context,
//                                     phase: 3, title: TITILE_DRAWER_PHASE3);
//                               } else if (!checkPhase(
//                                   4, snapshot.data!.phase!)) {
//                                 final check = await transferPhaseDialog(
//                                     context, TITILE_DRAWER_PHASE4);
//                                 if (check == true) {
//                                   await _local.updatePhase(4);
//                                   Navigator.pushNamedAndRemoveUntil(
//                                     context,
//                                     HomePhase3Scren.routeName,
//                                     (route) => false,
//                                   );
//                                 }
//                               }
//                             },
//                             child: GridviewDrawer(
//                               text1: choosePhase[2].title,
//                               text2: choosePhase[2].subTitle,
//                               imageUrl: 'assets/images/choose_image4.png',
//                               fromColor: blue500,
//                               toColor: blue300,
//                               isSelected: checkPhase(4, snapshot.data!.phase!),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: () async {
//                               if (!checkPhase(3, snapshot.data!.phase!)) {
//                                 final check = await transferPhaseDialog(
//                                     context, TITILE_DRAWER_PHASE3);
//                                 if (check == true) {
//                                   await _local.updatePhase(3);
//                                   final user =
//                                       await _local.getNguoiDung(_prefs.id!);
//                                   Navigator.pushNamed(
//                                     context,
//                                     Phase2InitialScreen.routeName,
//                                     arguments: {
//                                       'phase': user.phase,
//                                     },
//                                   );
//                                 }
//                               }
//                             },
//                             child: GridviewDrawer(
//                               text1: choosePhase[3].title,
//                               text2: choosePhase[3].subTitle,
//                               imageUrl: 'assets/images/choose_image3.png',
//                               fromColor: green500,
//                               toColor: green300,
//                               isSelected: checkPhase(3, snapshot.data!.phase!),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       height: 280,
//                       child: Column(
//                         children: [
//                           DrawerButtonCustom(
//                             icon: 'assets/stores/cart.png',
//                             title: 'Cửa hàng OvumB',
//                             onTap: () async {
//                               Navigator.pushNamed(
//                                 context,
//                                 MainStoreScreen.routeName,
//                                 arguments: true,
//                               );
//                             },
//                           ),
//                           if (snapshot.data!.phase != 5) ...[
//                             DrawerButtonCustom(
//                               icon: 'assets/icons/drawer_share_icon.png',
//                               title: 'Cộng đồng OvumB',
//                               onTap: () async {
//                                 Navigator.of(context).pop();
//                                 await LaunchUrl.web(
//                                   context: context,
//                                   maLink: maLinkOvumbCommunity,
//                                   tenLink: linkOvumbCommunity,
//                                 );
//                               },
//                             ),
//                           ],
//                           DrawerButtonCustom(
//                             icon: 'assets/icons/drawer_lock_icon.png',
//                             title: 'Thay đổi mật khẩu',
//                             onTap: () {
//                               Navigator.pushNamed(
//                                   context, ChangePasswordScreen.routeName);
//                             },
//                           ),
//                           DrawerButtonCustom(
//                             icon: 'assets/icons/drawer_contact_icon.png',
//                             title: 'Hỗ trợ kỹ thuật',
//                             onTap: () async {
//                               Navigator.of(context).pop();
//                               await LaunchUrl.webLink(
//                                 context: context,
//                                 link: linkSupport,
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     // const SizedBox(
//                     //   height: 100,
//                     // ),
//                     Container(
//                       height: 50,
//                       child: InkWell(
//                         onTap: () => showLogoutModal(context),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               'assets/icons/sign_out_icon.png',
//                               scale: 3,
//                             ),
//                             const SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               'Đăng xuất',
//                               style: PrimaryFont.semibold(
//                                 14,
//                                 FontWeight.w600,
//                               ).copyWith(
//                                 color: rose400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // const SizedBox(
//                     //   height: 100,
//                     // ),
//                   ],
//                 );
//               } else {
//                 return const SizedBox();
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
