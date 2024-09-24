// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_event.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_ovumb_app_version1/data/constant/choose_phase.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

// Phần grid view
class GridviewDrawer extends StatelessWidget {
  final int index;
  final bool isActive;
  final NguoiDung user;
  const GridviewDrawer({
    Key? key,
    required this.index,
    required this.isActive,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    handleSwitchPressed({
      required ChoosePhase phaseSelected,
      required NguoiDung user,
      required String titlePopup,
    }) async {
      context.read<AuthBloc>().add(
          AuthSwitchPhase(context, phaseSelected: phaseSelected, user: user));
    }

    return InkWell(
      onTap: () => handleSwitchPressed(
        phaseSelected: choosePhase[index],
        user: user,
        titlePopup: choosePhase[index].title,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  choosePhase[index].fromColor,
                  choosePhase[index].toColor,
                ],
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildText(
                        text: choosePhase[index].title,
                        style: 9.text700,
                        color: whiteColor,
                      ),
                      BuildText(
                        text: choosePhase[index].subTitle,
                        style: 9.text500,
                        color: whiteColor,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.asset(
                      choosePhase[index].imageUrl,
                      scale: 3,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isActive
              ? Positioned(
                  right: 6,
                  top: 6,
                  child: Image.asset(
                    IconApp.activePhase,
                    scale: 3,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
