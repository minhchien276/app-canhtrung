import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/age_enum.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/cau_hoi.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/auth_v2/auth_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/kinhnguyet_v2/kinhnguyet_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/server/server_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/synchrozied_v2/synchrozied_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/thaiki_v2/thaiki_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/validator/validator.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_state.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_v2.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/splash_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/step/question_main_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/main_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase2/phase2_initial_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/home_phase3_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/toast_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/transfer_phase_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_ovumb_app_version1/services/exception.dart';
import 'package:flutter_ovumb_app_version1/services/notification/fcm_notification_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateInitial(isLoading: false)) {
    on<AuthCheckLoggedEvent>(_onCheckLogged);
    on<AuthLoginEvent>(_onLogin);
    on<AuthEventRegister>(_onRegister);
    on<AuthResetPasswordEvent>(_onResetPassword);
    on<AuthEventInsertKinhNguyet>(_onSaveUserData);
    on<AuthEventLogout>(_onLogout);
    on<AuthSwitchPhase>(_onSwitchPhase);
    on<AuthChoosePhaseEvent>(_onChoosePhase);
    on<AuthOpenDrawer>(_onOpenDrawer);
  }

  final _server = ServerRepository();
  final _local = LocalRepository();
  final _auth = AuthRepositoryV2();
  final _syncV2 = SynchroziedRepositoryV2();
  final _knV2 = KinhNguyetRepositoryV2();
  final _prefs = SharedPreferencesService();
  final _thai = ThaiKiRepositoryV2();
  final _fcm = FcmNotificationService();

  //check user has logged
  _onCheckLogged(
    AuthCheckLoggedEvent event,
    Emitter<AuthState> emit,
  ) async {
    String? userId = await _prefs.id;
    if (userId != null) {
      final user = await _local.getNguoiDung(userId);
      final ageEnum = AgeEnum.toEnum(user.namSinh);
      final phase = PhaseEnum.getPhase(user.phase);
      final synchronized = await _prefs.synchronized;

      // check has data
      if (synchronized || !phase.mustSaveData()) {
        emit(AuthStateLogged(user: user, phase: phase));
      } else {
        emit(AuthStateLoggedNotInfor(ageEnum: ageEnum, phase: phase));
      }
    } else {
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthStateLogout());
    }
  }

  //login
  _onLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (Validator.isEmpty([event.taiKhoan, event.matKhau])) {
        emit(AuthStateLoading(isLoading: true));
        final res = await _auth.login(
          taiKhoan: event.taiKhoan,
          matKhau: event.matKhau,
        );

        await _local.insertCauHoi(listCauHoi: listCauHoi);
        String? id = await _prefs.id;

        if (res.isOk && id != null) {
          bool syncedDataToLocal = await _syncV2.syncAllToLocal(res.data);
          final user = await _local.getNguoiDung(id);
          if (syncedDataToLocal) {
            await _prefs.setSync(true);
            event.context.showSuccessToast('Đăng nhập thành công');
            emit(AuthStateLogged(
                user: user, phase: PhaseEnum.getPhase(user.phase)));
          } else {
            final ageEnum = AgeEnum.toEnum(user.namSinh);
            emit(AuthStateLoggedNotInfor(
              ageEnum: ageEnum,
              phase: PhaseEnum.getPhase(user.phase),
            ));
          }
        } else {
          emit(AuthFailureState(error: res.status.message));
        }
      } else {
        event.context.showToast('Vui lòng điền đầy đủ thông tin');
      }
    } on DioException catch (e) {
      emit(AuthFailureState(error: e.messageTr));
    }
  }

  //register
  _onRegister(
    AuthEventRegister event,
    Emitter<AuthState> emit,
  ) async {
    try {
      String? validator = Validator.register(event);
      if (validator == null) {
        emit(AuthStateLoading(isLoading: true));
        final res = await _auth.register(
          phone: event.phone,
          password: event.password,
          name: event.name,
          email: event.email,
          dob: event.dob,
        );
        if (res.isOk) {
          emit(
            AuthRegisterSuccessState(
                phone: event.phone, password: event.password),
          );
        } else {
          emit(AuthFailureState(error: res.status.message));
        }
      } else {
        event.context.showToast(validator);
      }
    } on DioException catch (e) {
      emit(AuthFailureState(error: e.messageTr));
    }
  }

  //reset password
  _onResetPassword(
    AuthResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      String? validator = Validator.resetPwd(event.email);
      if (validator == null) {
        emit(AuthStateLoading(isLoading: true));
        final res = await _auth.resetPassword(email: event.email);
        if (res.isOk) {
          emit(AuthStateResetPaswordSuccess(isLoading: false));
        } else {
          emit(AuthFailureState(error: res.status.message));
        }
      } else {
        event.context.showToast(validator);
      }
    } on DioException catch (e) {
      emit(AuthFailureState(error: e.messageTr));
    }
  }

  //save data
  _onSaveUserData(
    AuthEventInsertKinhNguyet event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (Validator.isEmpty(
          [event.cknn, event.ckdn, event.snck, event.ngayBatDau])) {
        emit(AuthStateLoading(isLoading: true));
        String? maNguoiDung = await _prefs.id;
        //lấy dữ liệu của người dùng sau khi đã đăng nhập
        final checkDataSaved = await _auth.logged();

        //kiểm tra dữ liệu kinh nguyệt trên server đã có chưa
        if (checkDataSaved.isOk) {
          bool synced = await _syncV2.syncAllToLocal(checkDataSaved.data);
          if (!synced) {
            //chưa có dữ liệu thì tạo dữ liệu mới
            List<KinhNguyet> initListCKKN = CalendarV2.initListCKKN(
              ckdn: int.parse(event.ckdn),
              cknn: int.parse(event.cknn),
              snck: int.parse(event.snck),
              ngayBatDau: DateTime.parse(event.ngayBatDau),
              maNguoiDung: maNguoiDung!,
            );

            //insert kinh nguyệt vào server
            bool checkPhase =
                await _server.updatePhase(phase: event.phase.toInt());
            bool checkKN =
                await _knV2.serverInsertListKN(listKinhNguyet: initListCKKN);

            if (checkPhase && checkKN) {
              //insert kinh nguyệt vào local
              await _knV2.localInsertListKN(listKinhNguyet: initListCKKN);
              await _local.updatePhase(event.phase.toInt());
              await _prefs.setSync(true);

              NguoiDung nguoiDung = await _local.getNguoiDung(maNguoiDung);
              emit(AuthStateLogged(
                  user: nguoiDung, phase: PhaseEnum.getPhase(nguoiDung.phase)));
            } else {
              emit(AuthFailureState(
                  error: 'Cập nhật thất bại. Vui lòng thử lại'));
            }
          } else {
            await _prefs.setSync(true);
            NguoiDung nguoiDung = await _local.getNguoiDung(maNguoiDung!);
            emit(AuthStateLogged(
                user: nguoiDung, phase: PhaseEnum.getPhase(nguoiDung.phase)));
          }
        } else {
          emit(AuthFailureState(error: 'Cập nhật thất bại. Vui lòng thử lại'));
        }
      } else {
        event.context.showToast('Vui lòng điền đầy đủ thông tin');
      }
    } on DioException catch (e) {
      emit(AuthFailureState(error: e.messageTr));
    }
  }

  //logout
  _onLogout(
    AuthEventLogout event,
    Emitter<AuthState> emit,
  ) async {
    await _prefs.logout();
    await _local.deleteAll();
    event.context.goName(SplashScreen.routeName);
    await Future.delayed(const Duration(seconds: 1));
    emit(AuthStateLogout(isLoading: false));
    await _auth.logout();
  }

  //switch phase
  _onSwitchPhase(
    AuthSwitchPhase event,
    Emitter<AuthState> emit,
  ) async {
    final synchronized = await _prefs.synchronized;
    if (event.phaseSelected != null && event.user != null) {
      final userPhase = PhaseEnum.getPhase(event.user!.phase);
      PhaseEnum phaseSelected = event.phaseSelected!.type;

      if (userPhase != phaseSelected) {
        switch (phaseSelected) {
          case PhaseEnum.trung:
          case PhaseEnum.antoan:
          case PhaseEnum.sua:
            if (userPhase == PhaseEnum.thai) {
              final check = await switchPhaseBottomSheet(
                event.context,
                phase: event.user!.phase!,
                title: event.phaseSelected!.title,
                onTap: () => Navigator.of(event.context).pop(true),
              );
              if (check == true) {
                try {
                  LoadingDialog().show(
                      context: event.context, text: 'Đang xóa dữ liệu...');
                  final check = await _thai.serverDeleteThaiKy();
                  final check1 =
                      await _auth.updatePhase(phase: phaseSelected.toInt());
                  if (check.isOk && check1.isOk) {
                    await _local.deleteThaiKi(
                        maNguoiDung: event.user!.maNguoiDung);
                    await _local.updatePhase(phaseSelected.toInt());
                    LoadingDialog().hide();

                    if (phaseSelected == PhaseEnum.sua) {
                      event.context.goName(HomePhase3Scren.routeName);
                    } else {
                      if (synchronized) {
                        event.context.goName(MainScreen.routeName,
                            arguments: event.user);
                      } else {
                        event.context.goName(SplashScreen.routeName);
                      }
                    }
                  }
                } on DioException catch (e) {
                  LoadingDialog().hide();
                  event.context.showErrorToast(e.messageTr);
                }
              }
            } else {
              final check = await transferPhaseDialog(
                  event.context, event.phaseSelected!.title);
              if (check == true) {
                await _local.updatePhase(phaseSelected.toInt());
                if (phaseSelected == PhaseEnum.sua) {
                  event.context.goName(HomePhase3Scren.routeName);
                } else {
                  if (synchronized) {
                    event.context
                        .goName(MainScreen.routeName, arguments: event.user);
                  } else {
                    event.context.goName(SplashScreen.routeName);
                  }
                }
              }
            }
            break;
          case PhaseEnum.thai:
            final check = await transferPhaseDialog(
                event.context, event.phaseSelected!.title);
            if (check == true) {
              await _local.updatePhase(phaseSelected.toInt());
              event.context.pushNamed(Phase2InitialScreen.routeName,
                  arguments: {'phase': event.user!.phase});
            }
            break;
          default:
        }
      }
    }

    if (synchronized) {
      String? maNguoiDung = await _prefs.id;
      NguoiDung nguoiDung = await _local.getNguoiDung(maNguoiDung!);
      emit(AuthStateLogged(
        user: nguoiDung,
        phase: PhaseEnum.getPhase(nguoiDung.phase),
        isLoading: false,
      ));
    }
  }

  _onChoosePhase(
    AuthChoosePhaseEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final phaseSelected = event.phaseSelected;
      if (phaseSelected != null) {
        _fcm.registerTopic(phaseSelected.type);
        if (phaseSelected.type.mustSaveData()) {
          event.context.pushNamed(
            QuestionMainScreen.routeName,
            arguments: phaseSelected.type,
          );
        } else if (phaseSelected.type == PhaseEnum.sua) {
          final res =
              await _auth.updatePhase(phase: phaseSelected.type.toInt());
          bool check1 = await LocalRepository().updatePhase(4);
          if (res.isOk && check1) {
            event.context.pushNamed(HomePhase3Scren.routeName);
          } else {
            emit(AuthFailureState(error: 'Cập nhật dữ liệu không thành công'));
          }
        } else if (phaseSelected.type == PhaseEnum.thai) {
          event.context.pushNamed(Phase2InitialScreen.routeName,
              arguments: {'phase': null});
        }
      } else {
        event.context.showToast('Vui lòng lựa chọn tính năng');
      }
    } on DioException catch (e) {
      emit(AuthFailureState(error: e.messageTr));
    }
  }

  _onOpenDrawer(
    AuthOpenDrawer event,
    Emitter<AuthState> emit,
  ) async {
    String? maNguoiDung = await _prefs.id;
    NguoiDung nguoiDung = await _local.getNguoiDung(maNguoiDung!);
    emit(AuthStateLogged(
      user: nguoiDung,
      phase: PhaseEnum.getPhase(nguoiDung.phase),
      isLoading: false,
    ));
  }
}
