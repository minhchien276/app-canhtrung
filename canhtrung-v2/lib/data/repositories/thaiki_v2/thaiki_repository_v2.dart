import 'dart:convert';

import 'package:flutter_ovumb_app_version1/data/api_url/api_url.dart';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/enum/test_result_enum.dart';
import 'package:flutter_ovumb_app_version1/data/handle/test_lh.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/constant.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/database.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/ket_qua_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/thai_ki.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/server/server_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/thaiki_v2/thaiki_provider_v2.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';
import 'package:flutter_ovumb_app_version1/services/models/thaiki_response.dart';

class ThaiKiRepositoryV2 implements ThaiKiProviderV2 {
  ThaiKiRepositoryV2._();
  static final ThaiKiRepositoryV2 _instance = ThaiKiRepositoryV2._();
  factory ThaiKiRepositoryV2() => _instance;
  final dbProvider = DatabaseProvider.db;

  final _prefs = SharedPreferencesService();
  final _dio = BaseService.instance.dio;

  final _server = ServerRepository();
  final _local = LocalRepository();
  final _testLH = TestLH();

  @override
  Future<bool> localInsertThaiKi({required ThaiKi thaiKi}) async {
    try {
      final db = await dbProvider.database;
      String? maNguoiDung = await _prefs.id;
      ThaiKi? tk = await localGetThaiKi();
      if (tk == null) {
        await db.insert(
          tableThaiKi,
          jsonDecode(
            ThaiKi(
              maNguoiDung: maNguoiDung,
              ngayDuSinh: thaiKi.ngayDuSinh,
            ).toJson(),
          ),
        );
      } else {
        await localUpdateThaiKi(
          thaiKi: ThaiKi(
            maNguoiDung: maNguoiDung,
            ngayDuSinh: thaiKi.ngayDuSinh,
            trangThai: 0,
          ),
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ThaiKi?> localGetThaiKi() async {
    final db = await dbProvider.database;
    try {
      String? maNguoiDung = await _prefs.id;
      final thaiKi = await db.query(
        tableThaiKi,
        where: 'maNguoiDung = ?',
        whereArgs: [maNguoiDung],
        limit: 1,
      );
      if (thaiKi.isNotEmpty) {
        return ThaiKi.fromJson(jsonEncode(thaiKi.first));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> localUpdateThaiKi({required ThaiKi thaiKi}) async {
    final db = await dbProvider.database;
    try {
      await db.update(
        tableThaiKi,
        {
          'ngayDuSinh': thaiKi.ngayDuSinh!.millisecondsSinceEpoch,
          'trangThai': thaiKi.trangThai,
        },
        where: 'maNguoiDung = ?',
        whereArgs: [thaiKi.maNguoiDung],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> localDeleteNgayDuSinh() async {
    try {
      String? maNguoiDung = await _prefs.id;

      final response = await _dio.get(
        '$thaiKiDelete/$maNguoiDung',
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> localInsertNgayDuSinh() async {
    try {
      List<KetQuaTest> listKQ = await _server.getKetQuaTest();
      DateTime? time;
      for (int i = listKQ.length - 1; i >= 0; i--) {
        if (_testLH.checkLH(listKQ[i].ketQua) == TestResultEnum.datdinh) {
          time = listKQ[i].thoiGian;
          break;
        }
      }
      //nếu chưa test trứng thì insert ngày hiện tại
      if (listKQ.isEmpty) {
        time = DateTime.now();
      } else {
        // nếu có rồi thì xem ngày cuối cùng đạt đỉnh là ngày nào, có thì insert không có thì insert ngày cuối cùng test
        if (time != null) {
          time = time.add(const Duration(days: 280));
        } else {
          time = listKQ.last.thoiGian.add(const Duration(days: 280));
        }
      }
      await _local.insertThaiKi(
          thaiKi: ThaiKi(ngayDuSinh: time.add(const Duration(days: 280))));
      await _server.insertThaiKi(
          thaiKi: ThaiKi(ngayDuSinh: time.add(const Duration(days: 280))));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> localUpdateTrangThaiWhenSynced() async {
    String? maNguoiDung = await _prefs.id;
    final db = await dbProvider.database;
    try {
      await db.update(
        tableThaiKi,
        {
          'trangThai': 1,
        },
        where: 'maNguoiDung = ?',
        whereArgs: [maNguoiDung],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //SERVER
  @override
  Future<bool> serverInsertThaiKi({required ThaiKi thaiKi}) async {
    try {
      String? maNguoiDung = await _prefs.id;
      final response = await _dio.post(
        '${ApiUrlV2.thaiKiInsert}',
        data: ThaiKi(
          maNguoiDung: maNguoiDung,
          ngayDuSinh: thaiKi.ngayDuSinh,
        ).toJson(),
      );

      if (response.statusCode == 200) {
        return response.data['status'];
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<DeleteThaiKyResponse> serverDeleteThaiKy() async {
    String? maNguoiDung = await _prefs.id;
    final response = await _dio.get('${ApiUrlV2.thaiKiDelete}/$maNguoiDung');
    return DeleteThaiKyResponse(
      status: ApiResponseStatus.fromMap(response.data),
    );
  }
}
