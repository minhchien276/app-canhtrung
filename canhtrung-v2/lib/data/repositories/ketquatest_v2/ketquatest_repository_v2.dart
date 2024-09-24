import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/constant.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/database.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/ket_qua_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/quan_ly_que_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/test_resutl.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/ketquatest_v2/ketquatest_provider_v2.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';
import 'package:flutter_ovumb_app_version1/services/models/test_response.dart';

class KetQuaTestRepositoryV2 implements KetQuaTestProviderV2 {
  KetQuaTestRepositoryV2._();
  static final KetQuaTestRepositoryV2 _instance = KetQuaTestRepositoryV2._();
  factory KetQuaTestRepositoryV2() => _instance;
  final dbProvider = DatabaseProvider.db;

  final _prefs = SharedPreferencesService();
  final _dio = BaseService.instance.dio;

  Future<KetQuaTest?> getKetQuaTest(DateTime date) async {
    try {
      final db = await dbProvider.database;
      final ketQua = await db.query(
        tableKetQuaTest,
        where: 'thoiGian = ?',
        whereArgs: [date.formatStartDate().millisecondsSinceEpoch],
      );
      return KetQuaTest.fromJson(jsonEncode(ketQua.first));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<KetQuaTest>> getListKetQuaTest() async {
    final db = await dbProvider.database;
    try {
      final List<KetQuaTest> list = [];
      final listKetQuaTest = await db.query(
        tableKetQuaTest,
      );
      listKetQuaTest.forEach((e) {
        list.add(KetQuaTest.fromJson(jsonEncode(e)));
      });
      return list;
    } catch (e) {
      return [];
    }
  }

  @override
  Future insertKetQuaTest({required KetQuaTest ketQuaTest}) async {
    try {
      final db = await dbProvider.database;
      await db.insert(
        tableKetQuaTest,
        {
          'maLoaiQue': ketQuaTest.maLoaiQue,
          'lanTest': ketQuaTest.lanTest,
          'thoiGian':
              ketQuaTest.thoiGian.formatStartDate().millisecondsSinceEpoch,
          'ketQua': ketQuaTest.ketQua,
        },
      );
      return true;
    } catch (e) {
      //return false;
      throw e;
    }
  }

  @override
  Future insertListKetQuaTest(
      {required List<KetQuaTest> listKetQuaTest}) async {
    try {
      for (int i = 0; i < listKetQuaTest.length; i++) {
        await insertKetQuaTest(ketQuaTest: listKetQuaTest[i]);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<TestResult?> serverInsertKQT({
    required int maQuanLyQueTest,
    required int maLoaiQue,
    required DateTime date,
    required int ketQua,
    int? phase,
    int? testEnum,
    int? firstDate,
    int? endDate,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiUrlV2.ketQuaTestInsert}',
        data: {
          'maNguoiDung': _prefs.id,
          'maQuanLyQueTest': maQuanLyQueTest,
          'maLoaiQue': maLoaiQue,
          'thoiGian': date.millisecondsSinceEpoch,
          'ketQua': ketQua,
          'phase': phase,
          'testEnum': testEnum,
          'firstDate': firstDate,
          'endDate': endDate,
          'checkUpdateVersion': true,
        },
      );
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          return TestResult.fromJson(jsonEncode(response.data['data']));
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<InsertTestResponse> serverInsertKQT1(FormData data) async {
    final response = await _dio.post(
      '${ApiUrlV2.ketQuaTestInsert}',
      data: data,
    );
    return InsertTestResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: TestResult.fromMap(response.data['data']),
    );
  }

  @override
  Future<GetQuanLyQueTestResponse> serverGetQLQT() async {
    final response =
        await _dio.get('${ApiUrlV2.quanLyQueTestGet}/${_prefs.id}');
    return GetQuanLyQueTestResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? QuanLyQueTest.fromMap(response.data['data'])
          : null,
    );
  }

  @override
  Future<GetListGuideResponse> serverGetImages() async {
    final response = await _dio.get(ApiUrlV2.videoGuideGetImage);
    return GetListGuideResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<Guide>.from(
              response.data['data'].map((e) => Guide.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetListGuideResponse> serverGetVideos() async {
    final response = await _dio.get(ApiUrlV2.videoGuideGetVideo);
    return GetListGuideResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<Guide>.from(
              response.data['data'].map((e) => Guide.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<UpdateHopTestResponse> serverUpdateHopTest(String maHopTest) async {
    final response = await _dio.post(
      '${ApiUrlV2.hopTestUpdate}/$maHopTest',
      data: {
        'maNguoiDung': _prefs.id,
        'thoiGian': DateTime.now().millisecondsSinceEpoch,
      },
    );
    return UpdateHopTestResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? QuanLyQueTest.fromMap(response.data['data'])
          : null,
    );
  }
}
