// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_ovumb_app_version1/data/enum/que_type.dart';

import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/quan_ly_que_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/test_resutl.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';

enum TestStatus {
  none,
  begin,
  success,
  failure,
}

// ignore: must_be_immutable
class TestState extends Equatable {
  final bool isLoading;
  final bool isReset;
  final String? loadingText;
  final String? message;
  final List<Guide> videos;
  final List<Guide> images;
  final QuanLyQueTest? quanLyQueTest;
  LoadedStatus status;
  final bool isNext;
  TestStatus testStatus;
  final TestResult? testResult;
  final QueTestType queTestType;
  TestState({
    this.isLoading = false,
    this.isReset = false,
    this.loadingText = '',
    this.message = '',
    required this.videos,
    required this.images,
    this.quanLyQueTest,
    this.status = LoadedStatus.none,
    this.isNext = false,
    this.testStatus = TestStatus.none,
    this.testResult,
    this.queTestType = QueTestType.trung,
  });

  copyWith({
    bool? isLoading,
    bool? isReset,
    String? loadingText,
    String? message,
    int? soLuongQueThai,
    int? soLuongQueTrung,
    List<Guide>? videos,
    List<Guide>? images,
    QuanLyQueTest? quanLyQueTest,
    LoadedStatus? status,
    bool? isNext,
    TestStatus? testStatus,
    TestResult? testResult,
    QueTestType? queTestType,
  }) {
    return TestState(
      isLoading: isLoading ?? false,
      loadingText: loadingText ?? '',
      message: message ?? '',
      videos: videos ?? this.videos,
      images: images ?? this.images,
      quanLyQueTest:
          isReset == true ? null : (quanLyQueTest ?? this.quanLyQueTest),
      status: status ?? LoadedStatus.succes,
      isNext: isNext ?? false,
      testStatus: testStatus ?? TestStatus.none,
      testResult: testResult ?? this.testResult,
      queTestType: queTestType ?? this.queTestType,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isReset,
        loadingText,
        videos,
        images,
        quanLyQueTest,
        status,
        message,
        isNext,
        testStatus,
        testResult,
        queTestType,
      ];
}
