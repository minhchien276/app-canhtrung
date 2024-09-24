import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/constant.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/database.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/luong_kinh.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/luongkinh_v2/luongkinh_provider_v2.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';

class LuongKinhRepositoryV2 implements LuongKinhProviderV2 {
  LuongKinhRepositoryV2._();
  static final LuongKinhRepositoryV2 _instance = LuongKinhRepositoryV2._();
  factory LuongKinhRepositoryV2() => _instance;
  final dbProvider = DatabaseProvider.db;

  final _prefs = SharedPreferencesService();
  final _dio = BaseService.instance.dio;

  // tồn taị = 0: tồn tại
  // tồn taị = 1: đã xoá

  // trạng thái = 0: chưa đồng bộ
  // trạng thái = 1: đã đồng bộ

  // lấy lượng kinh còn tồn tại
  @override
  Future<LuongKinh?> getLuongKinh({
    required DateTime date,
    int? trangThai,
  }) async {
    final db = await dbProvider.database;
    try {
      String? id = await _prefs.id;

      //nếu khác null lây theo tồn tại, nếu bằng null không lấy theo tồn tại
      String query = trangThai != null
          ? 'maNguoiDung = ? AND thoiGian = ? AND tonTai = ?'
          : 'maNguoiDung = ? AND thoiGian = ?';

      List<dynamic> where = trangThai != null
          ? [id, date.formatStartDate().millisecondsSinceEpoch, trangThai]
          : [id, date.formatStartDate().millisecondsSinceEpoch];
      final luongKinh = await db.query(
        tableLuongKinh,
        where: query,
        whereArgs: where,
        limit: 1,
      );
      return LuongKinh.fromJson(jsonEncode(luongKinh.first));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> insertLuongKinh({
    required DateTime date,
    required String? luongkinh,
    int trangThai = 0,
  }) async {
    final db = await dbProvider.database;
    try {
      String? id = await _prefs.id;
      final res = await getLuongKinh(date: date);

      print(res);

      if (res != null) {
        await db.update(
            tableLuongKinh,
            {
              'luongKinh': luongkinh,
              'trangThai': trangThai,
              'tonTai': 0,
            },
            where: 'maLuongKinh = ?',
            whereArgs: [res.maLuongKinh]);
      } else {
        await db.insert(
          tableLuongKinh,
          {
            'maNguoiDung': id,
            'luongKinh': luongkinh,
            'thoiGian': date.formatStartDate().millisecondsSinceEpoch,
            'trangThai': trangThai,
            'tonTai': 0,
          },
        );
      }
      return true;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future deleteLuongKinh({required DateTime date}) async {
    final db = await dbProvider.database;
    try {
      await db.update(
        tableLuongKinh,
        {
          'tonTai': 1,
          'trangThai': 0,
        },
        where: 'thoiGian = ?',
        whereArgs: [date.formatStartDate().millisecondsSinceEpoch],
      );
      return true;
    } catch (e) {
      return true;
    }
  }

  @override
  Future<List<LuongKinh>> getListLuongKinh({
    required DateTime begin,
    required DateTime end,
  }) async {
    final db = await dbProvider.database;
    try {
      String? id = await _prefs.id;
      final luongKinh = await db.query(
        tableLuongKinh,
        where:
            'maNguoiDung = ? AND tonTai = ? AND thoiGian >= ? AND thoiGian <= ?',
        whereArgs: [
          id,
          0,
          begin.millisecondsSinceEpoch,
          end.millisecondsSinceEpoch
        ],
      );
      return luongKinh.map((e) => LuongKinh.fromJson(jsonEncode(e))).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<LuongKinh>> getLuongKinhNotSync() async {
    final db = await dbProvider.database;
    try {
      String? id = await _prefs.id;
      final luongKinh = await db.query(
        tableLuongKinh,
        where: 'maNguoiDung = ? AND trangThai = ?',
        whereArgs: [id, 0],
      );
      return luongKinh.map((e) => LuongKinh.fromJson(jsonEncode(e))).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future updateLuongKinhWhenSynced() async {
    final db = await dbProvider.database;
    try {
      List<LuongKinh> luongKinh = await getLuongKinhNotSync();
      luongKinh.forEach((e) async {
        await db.update(
          tableLuongKinh,
          {
            'trangThai': 1,
          },
          where: 'maLuongKinh = ?',
          whereArgs: [e.maLuongKinh],
        );
      });
    } catch (e) {
      debugPrint('updateLuongKinhWhenSynced' + e.toString());
    }
  }

  //SERVER
  @override
  Future<bool> serverSynchroziedLuongKinh() async {
    try {
      List<LuongKinh> luongKinh = await getLuongKinhNotSync();
      String? id = await _prefs.id;

      List json = [];
      luongKinh.forEach((e) {
        json.add(e.toMap());
      });

      Map<String, dynamic> data = {
        'luongkinh': json,
      };

      final response = await _dio.post(
        '${ApiUrlV2.luongKinhDongBo}/$id',
        data: data,
      );
      if (response.statusCode == 200) {
        return response.data['status'];
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
