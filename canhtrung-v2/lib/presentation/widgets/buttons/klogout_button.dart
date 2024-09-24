import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/modals/logout_modal.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KLogoutButton extends StatelessWidget {
  const KLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showLogoutModal(context),
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/sign_out_icon.png', scale: 3),
          10.horizontalSpace,
          BuildText(
            text: 'Đăng xuất',
            style: 14.text600,
            color: rose400,
          ),
        ],
      ),
    );
  }
}
