// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_event.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase2/ngaydusinh_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// màn hình chọn que test
class Phase2InitialScreen extends StatefulWidget {
  static const routeName = 'phase2-initial-screen';
  final int? phase;
  const Phase2InitialScreen({
    Key? key,
    this.phase,
  }) : super(key: key);

  @override
  State<Phase2InitialScreen> createState() => _Phase2InitialScreenState();
}

class _Phase2InitialScreenState extends State<Phase2InitialScreen> {
  final _prefs = SharedPreferencesService();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            children: [
              70.verticalSpace,
              Image.asset('assets/images/mom.png'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BuildText(
                    text: 'Xin chúc mừng!',
                    style: 24.text700,
                    color: rose500,
                    textAlign: TextAlign.center,
                  ),
                  10.verticalSpace,
                  BuildText(
                    text: 'Chào mừng con tới với cuộc đời này',
                    style: 18.text600,
                    color: greyText,
                    textAlign: TextAlign.center,
                  ),
                  6.verticalSpace,
                  BuildText(
                    text:
                        'OvumB sẽ đồng hành trong 9 tháng thai kì cùng sinh linh bé bỏng của bạn, cung cấp các kiến thức hữu ích cho sức khỏe của bạn',
                    style: 14.text400,
                    color: greyText,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Expanded(child: const SizedBox()),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: KSubmitButton(
                        size: Size(context.width, 50.h),
                        text: 'Quay lại',
                        bgColor: whiteColor,
                        border: BorderSide(
                          color: Palette.title,
                        ),
                        textColor: Palette.title,
                        onTap: () async {
                          context
                              .read<AuthBloc>()
                              .add(AuthSwitchPhase(context));
                          await LocalRepository().updatePhase(widget.phase!);
                          context.pop();
                        },
                      ),
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: KSubmitButton(
                        size: Size(context.width, 50.h),
                        text: 'Tiếp theo',
                        bgColor: Palette.title,
                        textColor: whiteColor,
                        onTap: () {
                          String maNguoiDung = _prefs.id ?? '';
                          context.pushNamed(
                            NgayDuSinhScreen.routeName,
                            arguments: {
                              'maNguoiDung': maNguoiDung,
                              'phase': widget.phase ?? 2,
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
