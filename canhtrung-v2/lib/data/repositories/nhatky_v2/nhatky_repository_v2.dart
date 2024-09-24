import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/constant.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/database.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/cau_tra_loi.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nhat_ky.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/nhatky_v2/nhatky_provider_v2.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';

class NhatKyRepositoryV2 implements NhatKyProviderV2 {
  NhatKyRepositoryV2._();
  static final NhatKyRepositoryV2 _instance = NhatKyRepositoryV2._();
  factory NhatKyRepositoryV2() => _instance;
  final dbProvider = DatabaseProvider.db;

  final _prefs = SharedPreferencesService();
  final _dio = BaseService.instance.dio;

  // tồn taị = 0: tồn tại
  // tồn taị = 1: đã xoá

  // trạng thái = 0: chưa đồng bộ
  // trạng thái = 1: đã đồng bộ

  @override
  Future<NhatKy?> getNhatKy({required DateTime date}) async {
    final db = await dbProvider.database;
    try {
      String? id = await _prefs.id;
      final nhatKy = await db.query(
        tableNhatKy,
        where: 'maNguoiDung = ? AND thoiGian = ?',
        whereArgs: [id, date.millisecondsSinceEpoch],
        limit: 1,
      );
      if (nhatKy.isNotEmpty) {
        return NhatKy.fromJson(jsonEncode(nhatKy.first));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<NhatKy>> getListNhatKyNotSync() async {
    final db = await dbProvider.database;
    try {
      String? id = await _prefs.id;
      final nhatky = await db.query(
        tableNhatKy,
        where: 'maNguoiDung = ? AND trangThai = ?',
        whereArgs: [id, 0],
      );
      return nhatky.map((e) => NhatKy.fromJson(jsonEncode(e))).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<int?> insertNhatKy(
      {required DateTime date, int? trangThaiNhatKy}) async {
    final db = await dbProvider.database;
    try {
      final res = await getNhatKy(date: date);
      String? id = _prefs.id;

      // chưa có thì insert
      if (res == null) {
        int maNhatky = await db.insert(
          tableNhatKy,
          {
            'maNguoiDung': id,
            'thoiGian': date.millisecondsSinceEpoch,
            'trangThai': trangThaiNhatKy ?? 0,
          },
        );
        return maNhatky;
      } else {
        // đã có rồi thì check xem đã tồn tại chưa, nếu đã xóa thì cập nhật lại
        if (res.tonTai == 1) {
          await db.update(
            tableNhatKy,
            {
              'tonTai': 0,
              'trangThai': trangThaiNhatKy ?? 0,
            },
            where: 'maNhatKy = ?',
            whereArgs: [res.maNhatKy],
          );
          return res.maNhatKy;
        }
        return res.maNhatKy;
      }
    } catch (e) {
      debugPrint('insertNhatKy' + e.toString());
      return null;
    }
  }

  @override
  Future<List<CauTraLoi>> getListCauTraLoi({required DateTime date}) async {
    final db = await dbProvider.database;
    try {
      final nhatKy = await getNhatKy(date: date);
      if (nhatKy == null) {
        return [];
      }
      final res = await db.query(
        tableCauTraLoi,
        where: 'maNhatKy = ?',
        whereArgs: [nhatKy.maNhatKy],
      );
      return res.map((e) => CauTraLoi.fromJson(jsonEncode(e))).toList();
    } catch (e) {
      debugPrint('getListCauTraLoi ' + e.toString());
      return [];
    }
  }

  @override
  Future<CauTraLoi?> getCauTraLoi({
    required int maNhatKy,
    required int maCauHoi,
  }) async {
    final db = await dbProvider.database;
    try {
      final cauTraLoi = await db.query(
        tableCauTraLoi,
        where: 'maNhatKy = ? AND maCauHoi = ?',
        whereArgs: [maNhatKy, maCauHoi],
      );
      if (cauTraLoi.isNotEmpty) {
        return CauTraLoi.fromJson(jsonEncode(cauTraLoi.first));
      }
      return null;
    } catch (e) {
      debugPrint('getCauTraLoi' + e.toString());
      return null;
    }
  }

  @override
  Future insertListCauTraLoi({
    required List<String> cauTraLoi,
    required DateTime date,
    int? trangThaiNhatKy,
  }) async {
    try {
      final db = await dbProvider.database;
      final maNhatKy = await insertNhatKy(
        date: date,
        trangThaiNhatKy: trangThaiNhatKy,
      );
      if (maNhatKy != null) {
        for (int i = 0; i < cauTraLoi.length; i++) {
          int maCauHoi = i + 1;
          final res = await getCauTraLoi(
            maNhatKy: maNhatKy,
            maCauHoi: maCauHoi,
          );
          if (res == null) {
            await db.insert(tableCauTraLoi, {
              'maNhatKy': maNhatKy,
              'maCauHoi': maCauHoi,
              'cauTraLoi': cauTraLoi[i],
            });
          } else {
            await db.update(
              tableCauTraLoi,
              {
                'cauTraLoi': cauTraLoi[i],
              },
              where: 'maCauTraLoi = ?',
              whereArgs: [res.maCauTraLoi],
            );
          }
        }
      }
    } catch (e) {
      debugPrint('insertListCauTraLoi' + e.toString());
    }
  }

  @override
  Future serverSynchronizedNhatKy() async {
    try {
      List json = [];
      List<NhatKy> nhatKy = await getListNhatKyNotSync();
      String? id = await _prefs.id;

      //lấy tất cả câu trả lời trong nhật ký chưa đồng bộ để update
      nhatKy.forEach((e) async {
        List<CauTraLoi> cauTraLoi = await getListCauTraLoi(date: e.thoiGian);
        List jsonCauTraLoi = [];
        cauTraLoi.forEach((ctl) {
          jsonCauTraLoi.add(ctl.toMap());
        });
        dynamic res = e.toMap();
        res['cauTraLoi'] = jsonCauTraLoi;
        json.add(res);
      });

      final response = await _dio.post(
        '${ApiUrlV2.nhatKyDongBo}/$id',
        data: {'nhatky': json},
      );
      if (response.statusCode == 200) {
        return response.data['status'];
      }
      return false;
    } catch (e) {
      debugPrint('serverSynchronizedNhatKy' + e.toString());
      return false;
    }
  }

  @override
  Future updateNhatKyWhenSynced() async {
    final db = await dbProvider.database;
    try {
      List<NhatKy> nhatky = await getListNhatKyNotSync();
      nhatky.forEach((e) async {
        await db.update(
          tableNhatKy,
          {
            'trangThai': 1,
          },
          where: 'maNhatKy = ?',
          whereArgs: [e.maNhatKy],
        );
      });
    } catch (e) {
      debugPrint('updateNhatKyWhenSynced' + e.toString());
    }
  }
}
