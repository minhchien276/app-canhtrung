// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/thai_ki.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

class HomeEvent extends MainEvent {
  HomeEvent();
}

class ChartEvent extends MainEvent {
  final BuildContext context;
  ChartEvent(this.context);
}

class CalendarEvent extends MainEvent {
  String id;
  CalendarEvent({
    required this.id,
  });
}

class ProfileEvent extends MainEvent {
  String id;
  ProfileEvent({
    required this.id,
  });
}

class ProfileEditEvent extends MainEvent {
  String id;
  ProfileEditEvent({
    required this.id,
  });
}

class ProfileUpdateEvent extends MainEvent {
  final BuildContext context;
  final String name;
  final String weight;
  final String height;
  final File? avatar;
  ProfileUpdateEvent(
    this.context, {
    required this.name,
    required this.weight,
    required this.height,
    this.avatar,
  });
}

class NgayDuSinhCheckEvent extends MainEvent {
  NgayDuSinhCheckEvent();
}

class NgayDuSinhInsertEvent extends MainEvent {
  ThaiKi thaiKi;
  NgayDuSinhInsertEvent({
    required this.thaiKi,
  });
}

class GetBlogsEvent extends MainEvent {
  final BuildContext context;
  final int phase;
  GetBlogsEvent(
    this.context, {
    required this.phase,
  });
}

class GetTvvEvent extends MainEvent {
  final BuildContext context;
  GetTvvEvent(this.context);
}
