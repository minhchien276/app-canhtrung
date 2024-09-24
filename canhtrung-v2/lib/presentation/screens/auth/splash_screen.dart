import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/age_enum.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/step/choose_home_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/main_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_logo.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/welcome_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase2/phase2_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/home_phase3_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/step/question_main_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/toast_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = 'splash-screen';
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<AuthBloc>().add(AuthCheckLoggedEvent());
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading == true) {
          LoadingLogo().show(context: context);
        } else {
          LoadingLogo().hide();
        }
        if (state is AuthFailureState) {
          context.showErrorToast(state.error ?? '');
        } else if (state is AuthStateLogout) {
          context.pushNamed(WelcomeScreen.routeName);
        } else if (state is AuthStateLogged) {
          if (state.phase.isMainPhase()) {
            context.goName(MainScreen.routeName, arguments: state.user);
          } else if (state.phase == PhaseEnum.thai) {
            context.goName(Phase2Screen.routeName,
                arguments: {'nguoiDung': state.user, 'phase': null});
          } else if (state.phase == PhaseEnum.sua) {
            context.goName(HomePhase3Scren.routeName);
          }
        } else if (state is AuthStateLoggedNotInfor) {
          if (state.phase == PhaseEnum.vithanhnien ||
              state.ageEnum == AgeEnum.teenage ||
              state.phase != PhaseEnum.none) {
            context.pushNamed(QuestionMainScreen.routeName,
                arguments: state.phase);
          } else {
            context.pushNamed(ChooseHomeScreen.routeName);
          }
        }
      },
      listenWhen: (previousState, currentState) {
        return previousState != currentState;
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: Palette.background,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 100.w),
              child: Image.asset(Imgs.ovumbText),
            ),
          ],
        ),
      ),
    );
  }
}
