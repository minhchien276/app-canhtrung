import 'package:dio/dio.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/ket_qua_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/test_resutl.dart';
import 'package:flutter_ovumb_app_version1/services/models/test_response.dart';

abstract class KetQuaTestProviderV2 {
  //LOCAL
  Future insertKetQuaTest({required KetQuaTest ketQuaTest});

  Future insertListKetQuaTest({required List<KetQuaTest> listKetQuaTest});

  Future<List<KetQuaTest>> getListKetQuaTest();

  //SERVER
  Future<TestResult?> serverInsertKQT({
    required int maQuanLyQueTest,
    required int maLoaiQue,
    required DateTime date,
    required int ketQua,
    required int? phase,
    required int? testEnum,
    required int? firstDate,
    required int? endDate,
  });

  Future<InsertTestResponse> serverInsertKQT1(FormData data);
  Future<GetQuanLyQueTestResponse> serverGetQLQT();
  Future<GetListGuideResponse> serverGetVideos();
  Future<GetListGuideResponse> serverGetImages();
  Future<UpdateHopTestResponse> serverUpdateHopTest(String maHopTest);
}
