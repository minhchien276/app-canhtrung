// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/constant/choose_phase.dart';

import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckLoggedEvent extends AuthEvent {
  AuthCheckLoggedEvent();
}

class AuthResetPasswordEvent extends AuthEvent {
  final BuildContext context;
  final String email;
  AuthResetPasswordEvent(
    this.context, {
    required this.email,
  });
}

class AuthLoginEvent extends AuthEvent {
  final BuildContext context;
  final String taiKhoan;
  final String matKhau;
  AuthLoginEvent(
    this.context,
    this.taiKhoan,
    this.matKhau,
  );
}

class AuthEventRegister extends AuthEvent {
  final BuildContext context;
  String phone;
  String password;
  String repassword;
  String name;
  String email;
  String dob;
  bool isVerify;
  AuthEventRegister(
    this.context, {
    required this.phone,
    required this.password,
    required this.repassword,
    required this.name,
    required this.email,
    required this.dob,
    required this.isVerify,
  });
}

class AuthEventInsertKinhNguyet extends AuthEvent {
  final BuildContext context;
  final String cknn;
  final String ckdn;
  final String snck;
  final String ngayBatDau;
  final PhaseEnum phase;
  AuthEventInsertKinhNguyet(
    this.context, {
    required this.cknn,
    required this.ckdn,
    required this.snck,
    required this.ngayBatDau,
    required this.phase,
  });
}

class AuthChoosePhaseEvent extends AuthEvent {
  final BuildContext context;
  final ChoosePhase? phaseSelected;
  AuthChoosePhaseEvent(
    this.context, {
    required this.phaseSelected,
  });
}

class AuthEventLogout extends AuthEvent {
  final BuildContext context;
  AuthEventLogout(this.context);
}

class AuthSwitchPhase extends AuthEvent {
  final BuildContext context;
  final ChoosePhase? phaseSelected;
  final NguoiDung? user;
  AuthSwitchPhase(
    this.context, {
    this.phaseSelected,
    this.user,
  });
}

class AuthOpenDrawer extends AuthEvent {
  AuthOpenDrawer();
}
