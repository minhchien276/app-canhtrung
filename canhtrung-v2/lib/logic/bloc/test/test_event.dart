// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ovumb_app_version1/data/enum/que_type.dart';
import 'package:image/image.dart' as img;

abstract class TestEvent extends Equatable {
  const TestEvent();

  @override
  List<Object> get props => [];
}

class TestSubmitLHEvent extends TestEvent {
  final BuildContext context;
  final int maQuanLyQueTest;
  final QueTestType queTestType;
  final img.Image image;
  final File file;
  TestSubmitLHEvent({
    required this.context,
    required this.maQuanLyQueTest,
    required this.queTestType,
    required this.image,
    required this.file,
  });
}

class TestCheckEvent extends TestEvent {
  TestCheckEvent();
}

class TestOpenQREvent extends TestEvent {
  TestOpenQREvent();
}

class TestQRSubmitEvent extends TestEvent {
  final String qrcode;
  final BuildContext context;
  TestQRSubmitEvent({
    required this.context,
    required this.qrcode,
  });
}

class TestGuideEvent extends TestEvent {
  final BuildContext context;
  final bool isNext;
  TestGuideEvent({
    required this.context,
    this.isNext = false,
  });
}
