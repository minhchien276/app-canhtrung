// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_initial_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_ovumb_app_version1/services/permission/permission.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

//Tabbar của phầm home
class HomeTabbar extends StatefulWidget {
  final int index;
  final int phase;
  final ValueChanged<int> onChangedTab;
  const HomeTabbar({
    Key? key,
    required this.index,
    required this.phase,
    required this.onChangedTab,
  }) : super(key: key);

  @override
  State<HomeTabbar> createState() => _HomeTabbarState();
}

class _HomeTabbarState extends State<HomeTabbar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _permission = PermissionHandler();

    List<String> activeImgs = [
      'assets/icons/home_active.png',
      'assets/icons/chart_active.png',
      'assets/icons/calendar_active.png',
      'assets/icons/user_active.png',
    ];

    List<String> unactiveImgs = [
      'assets/icons/home_unactive.png',
      'assets/icons/chart_unactive.png',
      'assets/icons/calendar_unactive.png',
      'assets/icons/user_unactive.png',
    ];

    return Container(
      height: 85.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 70.h,
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 10,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _item(
                  activeImg: activeImgs[0],
                  unactiveImg: unactiveImgs[0],
                  isAcitve: widget.index == 0,
                  onTap: () => widget.onChangedTab(0),
                ),
                _item(
                  activeImg: activeImgs[1],
                  unactiveImg: unactiveImgs[1],
                  isAcitve: widget.index == 1,
                  onTap: () => widget.onChangedTab(1),
                ),
                Container(
                  width: size.width * 0.24,
                ),
                _item(
                  activeImg: activeImgs[2],
                  unactiveImg: unactiveImgs[2],
                  isAcitve: widget.index == 2,
                  onTap: () => widget.onChangedTab(2),
                ),
                _item(
                  activeImg: activeImgs[3],
                  unactiveImg: unactiveImgs[3],
                  isAcitve: widget.index == 3,
                  onTap: () => widget.onChangedTab(3),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: InkWell(
              onTap: () async {
                if (widget.phase == 5) {
                  showToast(
                      context, 'Tính năng không phù hợp với độ tuổi của bạn');
                } else {
                  try {
                    await _permission.cameraRequest(context);
                    if (!context.mounted) return;
                    context.pushNamed(TestInitialScreen.routeName);
                  } catch (e) {
                    showSettingDialog(context, e.toString());
                  }
                }
              },
              child: Image.asset(
                IconApp.scan,
                fit: BoxFit.contain,
                scale: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item({
    required bool isAcitve,
    required String activeImg,
    required String unactiveImg,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 10.h),
            child: Image.asset(
              isAcitve ? activeImg : unactiveImg,
              fit: BoxFit.fitWidth,
              scale: 2.8,
            ),
          ),
        ),
      ),
    );
  }
}

void showSettingDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text("Thông báo"),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: const Text(
            'Hủy',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text(
            "Cài đặt",
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () {
            Navigator.pop(context);
            openAppSettings();
          },
        )
      ],
    ),
  );
}
