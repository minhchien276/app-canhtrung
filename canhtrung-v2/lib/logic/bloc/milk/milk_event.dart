// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:equatable/equatable.dart';

import 'package:flutter_ovumb_app_version1/data/enum/blog_type.dart';
import 'package:flutter_ovumb_app_version1/data/enum/choan_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/choan.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/hutsua.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/phattriencon.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/trieuchung.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';

abstract class MilkEvent extends Equatable {
  const MilkEvent();

  @override
  List<Object> get props => [];
}

class CheckBabyExistEvent extends MilkEvent {
  CheckBabyExistEvent();
}

class InsertBabyEvent extends MilkEvent {
  Con con;
  InsertBabyEvent({
    required this.con,
  });
}

class UpdateBabyEvent extends MilkEvent {
  Con con;
  File? avatar;
  UpdateBabyEvent({
    required this.con,
    this.avatar,
  });
}

class AddBabyEvent extends MilkEvent {
  Con con;
  MilkEventName event;
  AddBabyEvent({
    required this.con,
    this.event = MilkEventName.rGet,
  });
}

class DeleteBabyEvent extends MilkEvent {
  Con con;
  DeleteBabyEvent({
    required this.con,
  });
}

class SwitchBabyEvent extends MilkEvent {
  Con con;
  SwitchBabyEvent({
    required this.con,
  });
}

class CheckChoAnEvent extends MilkEvent {
  int maCon;
  DateTime date;
  CheckChoAnEvent({
    required this.maCon,
    required this.date,
  });
}

class CheckQRExistEvent extends MilkEvent {
  CheckQRExistEvent();
}

class InsertPhattrienEvent extends MilkEvent {
  PhatTrienCon phatTrienCon;
  InsertPhattrienEvent({
    required this.phatTrienCon,
  });
}

class InsertTrieuchungEvent extends MilkEvent {
  TrieuChung trieuChung;
  InsertTrieuchungEvent({
    required this.trieuChung,
  });
}

class SwitchPhatTrienEvent extends MilkEvent {
  int index;
  SwitchPhatTrienEvent({
    required this.index,
  });
}

class GetChoAnHistoryEvent extends MilkEvent {
  List<int> maLoaiChoAn;
  DateTime date;
  ChoAnEnum choAnEnum;
  GetChoAnHistoryEvent({
    required this.choAnEnum,
    required this.date,
    required this.maLoaiChoAn,
  });
}

class BackChoAnInputEvent extends MilkEvent {
  BackChoAnInputEvent();
}

class InsertChoAnEvent extends MilkEvent {
  ChoAn choAn;
  InsertChoAnEvent({
    required this.choAn,
  });
}

class GetBumeLinkEvent extends MilkEvent {
  GetBumeLinkEvent();
}

class DeleteChoAnEvent extends MilkEvent {
  int maChoAn;
  DeleteChoAnEvent({
    required this.maChoAn,
  });
}

class UpdateChoAnEvent extends MilkEvent {
  ChoAn choAn;
  UpdateChoAnEvent({
    required this.choAn,
  });
}

class GetHutSuaEvent extends MilkEvent {
  DateTime date;
  GetHutSuaEvent({
    required this.date,
  });
}

class GetHutSuaHistoryEvent extends MilkEvent {
  DateTime date;
  GetHutSuaHistoryEvent({
    required this.date,
  });
}

class InsertHutSuaEvent extends MilkEvent {
  HutSua hutSua;
  InsertHutSuaEvent({
    required this.hutSua,
  });
}

class DeleteHutSuaEvent extends MilkEvent {
  int maHutSua;
  DeleteHutSuaEvent({
    required this.maHutSua,
  });
}

class UpdateHutSuaEvent extends MilkEvent {
  HutSua hutSua;
  UpdateHutSuaEvent({
    required this.hutSua,
  });
}

class InsertQrSua extends MilkEvent {
  String qrCode;
  InsertQrSua({
    required this.qrCode,
  });
}

class GetPostsEvent extends MilkEvent {
  GetPostsEvent();
}

class GetVideosEvent extends MilkEvent {
  GetVideosEvent();
}

class GetBlogsEvent extends MilkEvent {
  BlogType type;
  GetBlogsEvent({
    required this.type,
  });
}
