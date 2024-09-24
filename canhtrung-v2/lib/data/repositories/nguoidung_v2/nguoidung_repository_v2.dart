import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/constant.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/database.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/nguoidung_v2/nguoidung_provider_v2.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';
import 'package:flutter_ovumb_app_version1/services/models/user_response.dart';

class NguoiDungRepositoryV2 implements NguoiDungProviderV2 {
  static final NguoiDungRepositoryV2 _instance =
      NguoiDungRepositoryV2._internal();
  factory NguoiDungRepositoryV2() {
    return _instance;
  }
  NguoiDungRepositoryV2._internal();
  final dbProvider = DatabaseProvider.db;
  final _prefs = SharedPreferencesService();
  final _dio = BaseService.instance.dio;

  @override
  Future<int?> getTrangThai() async {
    try {
      final db = await dbProvider.database;
      String? maNguoiDung = await _prefs.id;
      final user = await db.query(
        tableNguoiDung,
        where: 'maNguoiDung = ?',
        whereArgs: [maNguoiDung],
      );
      NguoiDung nguoiDung = NguoiDung.fromJson(jsonEncode(user.first));
      return nguoiDung.trangThai;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateTrangThai({required int trangThai}) async {
    try {
      final db = await dbProvider.database;
      String? maNguoiDung = await _prefs.id;
      await db.update(
        tableNguoiDung,
        {'trangThai': trangThai},
        where: 'maNguoiDung = ?',
        whereArgs: [maNguoiDung],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UpdateUserResponse> updateUser(FormData data) async {
    final id = await _prefs.id;
    final response = await _dio.post(
      '${ApiUrlV2.authUpdateUser}/$id',
      data: data,
    );
    return UpdateUserResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data']['avatar'],
    );
  }
}
