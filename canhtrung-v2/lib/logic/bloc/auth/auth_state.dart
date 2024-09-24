// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter_ovumb_app_version1/data/enum/age_enum.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText,
  });

  copyWith({
    bool? isLoading,
    String? loadingText,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      loadingText: loadingText ?? this.loadingText,
    );
  }

  @override
  List<Object> get props => [
        isLoading,
      ];
}

class AuthStateInitial extends AuthState {
  AuthStateInitial({
    required super.isLoading,
  });
}

class AuthStateLoading extends AuthState {
  AuthStateLoading({
    super.isLoading = false,
    super.loadingText,
  });
}

class AuthStateLogin extends AuthState {
  String taiKhoan;
  String matKhau;
  AuthStateLogin({
    required this.taiKhoan,
    required this.matKhau,
    required super.isLoading,
  });
}

class AuthStateLogged extends AuthState {
  NguoiDung user;
  PhaseEnum phase;
  AuthStateLogged({
    required this.user,
    required this.phase,
    super.isLoading = false,
  });

  @override
  List<Object> get props => [
        phase,
        user,
      ];
}

class AuthFailureState extends AuthState {
  String? error;
  AuthFailureState({
    this.error,
    super.isLoading = false,
  });
}

class AuthStateDisconnect extends AuthState {
  String error;
  AuthStateDisconnect({
    required this.error,
    required super.isLoading,
  });
}

class AuthStateRegistering extends AuthState {
  AuthStateRegistering({
    required super.isLoading,
  });
}

class AuthRegisterSuccessState extends AuthState {
  String phone;
  String password;
  AuthRegisterSuccessState({
    required this.phone,
    required this.password,
    super.isLoading = false,
  });
}

class AuthStateRegisterFailure extends AuthState {
  String error;
  AuthStateRegisterFailure({
    required this.error,
    required super.isLoading,
  });
}

class AuthStateLoggedNotInfor extends AuthState {
  final AgeEnum ageEnum;
  final PhaseEnum? phase;
  AuthStateLoggedNotInfor({
    required this.ageEnum,
    this.phase,
    super.isLoading = false,
  });
}

class AuthStateLoginFailure extends AuthState {
  String? error;
  AuthStateLoginFailure({
    this.error,
    required super.isLoading,
  });
}

class AuthStateUserExist extends AuthState {
  AuthStateUserExist({required super.isLoading});
}

class AuthStateInsertKinhNguyetInitial extends AuthState {
  AuthStateInsertKinhNguyetInitial({
    required super.isLoading,
  });
}

class AuthStateInsertKinhNguyetSuccess extends AuthState {
  String maNguoiDung;
  AuthStateInsertKinhNguyetSuccess({
    required this.maNguoiDung,
    required super.isLoading,
  });
}

class AuthStateInsertKinhNguyetFailure extends AuthState {
  final String error;
  AuthStateInsertKinhNguyetFailure({
    required this.error,
    required super.isLoading,
  });
}

class AuthStateLogout extends AuthState {
  AuthStateLogout({
    super.isLoading = false,
  });
}

class AuthStateChoosePhase extends AuthState {
  AuthStateChoosePhase({
    required super.isLoading,
  });
}

class AuthStateResetPaswordSuccess extends AuthState {
  AuthStateResetPaswordSuccess({
    required super.isLoading,
  });
}

class AuthStateResetPaswordFailure extends AuthState {
  final String error;
  AuthStateResetPaswordFailure({
    required this.error,
    required super.isLoading,
  });
}

