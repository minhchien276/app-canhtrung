import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url.dart';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/constant.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/database.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/kinhnguyet_v2/kinhnguyet_provider_v2.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_v2.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';

class KinhNguyetRepositoryV2 implements KinhNguyetProviderV2 {
  KinhNguyetRepositoryV2._();
  static final KinhNguyetRepositoryV2 _instance = KinhNguyetRepositoryV2._();
  factory KinhNguyetRepositoryV2() => _instance;
  final dbProvider = DatabaseProvider.db;

  final _dio = BaseService.instance.dio;
  final _prefs = SharedPreferencesService();

  //LOCAL
  @override
  Future<bool> localInsertKN({required KinhNguyet kinhNguyet}) async {
    final db = await dbProvider.database;
    try {
      await db.insert(
        tableKinhNguyet,
        jsonDecode(kinhNguyet.toJson()),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> localInsertListKN(
      {required List<KinhNguyet> listKinhNguyet}) async {
    try {
      for (KinhNguyet kinhNguyet in listKinhNguyet) {
        await localInsertKN(kinhNguyet: kinhNguyet);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<KinhNguyet>> localGetListKN() async {
    try {
      String? id = _prefs.id;
      final db = await dbProvider.database;
      //lấy ra tất cả kinh nguyệt theo thứ tự tăng dần
      /*
        trạng thái
        -1: đã xoá
        0: đã qua
        1: hiện tại
        2: tương lai
      */
      final kinhnguyet = await db.query(
        tableKinhNguyet,
        where: 'maNguoiDung = ? AND trangThai IN (?, ?, ?)',
        whereArgs: [id, 0, 1, 2],
        orderBy: 'trangThai ASC, ngayBatDau ASC',
      );

      List<KinhNguyet> listKN = [];
      kinhnguyet.forEach((element) {
        listKN.add(KinhNguyet.fromJson(jsonEncode(element)));
      });
      return listKN;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<KinhNguyet>> localGetListKNByTrangThai(
      {required int trangThai}) async {
    try {
      String? id = _prefs.id;
      final db = await dbProvider.database;
      final kinhnguyet = await db.query(
        tableKinhNguyet,
        where: 'maNguoiDung = ? AND trangThai = ?',
        whereArgs: [id, trangThai],
      );

      List<KinhNguyet> listKN = [];
      kinhnguyet.forEach((element) {
        listKN.add(KinhNguyet.fromJson(jsonEncode(element)));
      });
      return listKN;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<KinhNguyet?> localGetKN({required int trangThai}) async {
    try {
      final db = await dbProvider.database;
      String? maNguoiDung = await _prefs.id;

      final kinhnguyet = await db.query(
        tableKinhNguyet,
        where: 'maNguoiDung = ? AND trangThai = ?',
        whereArgs: [maNguoiDung, trangThai],
      );
      return KinhNguyet.fromJson(jsonEncode(kinhnguyet.first));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<KinhNguyet?> localGetKNByDate({required DateTime date}) async {
    try {
      final db = await dbProvider.database;
      String? maNguoiDung = await _prefs.id;

      final kinhnguyet = await db.query(
        tableKinhNguyet,
        where:
            'maNguoiDung = ? AND ngayBatDau <= ? AND ? <= ngayKetThuc AND trangThai != ?',
        whereArgs: [
          maNguoiDung,
          date.millisecondsSinceEpoch,
          date.millisecondsSinceEpoch,
          -1,
        ],
      );
      return KinhNguyet.fromJson(jsonEncode(kinhnguyet.first));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<KinhNguyet?> localGetNextKNFromDate({required DateTime date}) async {
    try {
      final db = await dbProvider.database;
      String? maNguoiDung = await _prefs.id;

      final kinhnguyet = await db.query(
        tableKinhNguyet,
        where: 'maNguoiDung = ? AND ngayBatDau >= ? AND trangThai != ?',
        whereArgs: [
          maNguoiDung,
          date.millisecondsSinceEpoch,
          -1,
        ],
        orderBy: 'ngayBatDau ASC',
      );
      return KinhNguyet.fromJson(jsonEncode(kinhnguyet.first));
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> localUpdateNgayKinh({required DateTime date}) async {
    try {
      final db = await dbProvider.database;
      KinhNguyet? kinhnguyet = await localGetKNByDate(date: date);
      if (kinhnguyet != null) {
        //tính lại số ngày có kinh
        int snck = date.difference(kinhnguyet.ngayBatDau!).inDays + 1;

        if (kinhnguyet.snck < snck) {
          await db.update(
            tableKinhNguyet,
            {
              'ngayKetThucKinh': date.millisecondsSinceEpoch,
              'snck': snck,
            },
            where: 'maKinhNguyet = ?',
            whereArgs: [kinhnguyet.maKinhNguyet],
          );
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> localUpdateTrangThai({
    required int maKinhNguyet,
    required int trangThai,
  }) async {
    try {
      final db = await dbProvider.database;
      await db.update(
        tableKinhNguyet,
        {
          'trangThai': trangThai,
        },
        where: 'maKinhNguyet = ?',
        whereArgs: [maKinhNguyet],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> localUpdateKinhNguyet({
    required int maKinhNguyet,
    required KinhNguyet kinhNguyet,
  }) async {
    try {
      final db = await dbProvider.database;
      await db.update(
        tableKinhNguyet,
        {
          'tbnkn': kinhNguyet.tbnkn,
          'snck': kinhNguyet.snck,
          'snct': kinhNguyet.snct,
          'ckdn': kinhNguyet.ckdn,
          'cknn': kinhNguyet.cknn,
          'ngayBatDau': kinhNguyet.ngayBatDau!.millisecondsSinceEpoch,
          'ngayKetThuc': kinhNguyet.ngayKetThuc!.millisecondsSinceEpoch,
          'ngayBatDauKinh': kinhNguyet.ngayBatDauKinh!.millisecondsSinceEpoch,
          'ngayKetThucKinh': kinhNguyet.ngayKetThucKinh!.millisecondsSinceEpoch,
          'ngayBatDauTrung': kinhNguyet.ngayBatDauTrung!.millisecondsSinceEpoch,
          'ngayKetThucTrung':
              kinhNguyet.ngayKetThucTrung!.millisecondsSinceEpoch,
          'trangThai': kinhNguyet.trangThai,
        },
        where: 'maKinhNguyet = ?',
        whereArgs: [maKinhNguyet],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> localDeleteKN({required int maKinhNguyet}) async {
    try {
      final db = await dbProvider.database;
      await db.update(
        tableKinhNguyet,
        {
          'trangThai': -1,
        },
        where: 'maKinhNguyet = ?',
        whereArgs: [maKinhNguyet],
      );
      return true;
    } catch (e) {
      debugPrint('localDeleteKN' + e.toString());
      return false;
    }
  }

  @override
  Future<bool> localDeleteKNFromDate({required DateTime date}) async {
    try {
      final db = await dbProvider.database;
      final res = await db.update(
        tableKinhNguyet,
        {
          'trangThai': -1,
        },
        where: 'ngayKetThuc >= ?',
        whereArgs: [date.millisecondsSinceEpoch],
      );
      debugPrint('localDeleteKNFromDate ress:' + res.toString());
      return true;
    } catch (e) {
      debugPrint('throw localDeleteKNFromDate' + e.toString());
      return false;
    }
  }

  @override
  Future<bool> localDeleteKNWhenSynced() async {
    try {
      final db = await dbProvider.database;
      await db.delete(
        tableKinhNguyet,
        where: 'trangThai = ?',
        whereArgs: [-1],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> localResetCKKNWhenTestLH() async {
    try {
      KinhNguyet? current = await localGetKN(trangThai: 1);
      DateTime now = DateTime.now().formatStartDate();

      if (current != null) {
        int rangeDay = now.difference(current.ngayBatDau!).inDays + 1;
        //nếu ngày test đạt đỉnh nằm ngoài 7 ngày kinh thì thay đổi ngày dự đoán
        print('rangeDay $rangeDay');
        print(current.toJson().toString());
        print(current.ngayBatDau);
        if (rangeDay > 7) {
          int tbnknNew = 13;
          if (current.tbnkn > 28) {
            tbnknNew = current.tbnkn - 15;
          }
          bool check = await localDeleteKNFromDate(date: now);
          if (check) {
            tbnknNew += rangeDay;
            print('tbnknNew $tbnknNew');
            List<KinhNguyet> initKN = CalendarV2.initListCKKN(
              ckdn: tbnknNew,
              cknn: tbnknNew,
              tbnknInit: tbnknNew,
              snck: current.snck,
              ngayBatDau: current.ngayBatDau!,
              maNguoiDung: _prefs.id ?? '',
            );
            initKN.forEach((e) {
              print('${e.ngayBatDau} - ${e.ngayKetThuc}');
              print(e.toJson().toString());
            });
            await localInsertListKN(listKinhNguyet: initKN);
          }
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  //SERVER
  @override
  Future<List<KinhNguyet>?> serverGetListKN() async {
    try {
      String? maNguoiDung = await _prefs.id;

      final response = await _dio.get('$kinhNguyetFind/$maNguoiDung');
      if (response.statusCode == 200) {
        List x = response.data['data'];
        if (x.isNotEmpty) {
          return x.map((e) => KinhNguyet.fromMap(e)).toList();
        } else {
          return [];
        }
      }
      return null;
    } catch (e) {
      debugPrint('serverGetListKN ' + e.toString());
      return null;
    }
  }

  @override
  Future<bool> serverInsertListKN({
    required List<KinhNguyet> listKinhNguyet,
  }) async {
    try {
      List listKN = [];
      listKinhNguyet.forEach((kinhNguyet) {
        listKN.add(kinhNguyet.toJson());
      });

      final response = await _dio.post(
        '$kinhNguyetInsert',
        data: listKN,
      );
      if (response.statusCode == 200) {
        return response.data['status'];
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> serverDeleteKNByDate() async {
    try {
      final id = await _prefs.id;
      List delete = [];
      List update = [];
      List<KinhNguyet> knDelete =
          await localGetListKNByTrangThai(trangThai: -1);
      List<KinhNguyet> knUpdate = await localGetListKN();

      knDelete.forEach((e) {
        delete.add(e.toMap());
      });

      knUpdate.forEach((e) {
        update.add(e.toMap());
      });

      final response = await _dio.post(
        '${ApiUrlV2.kinhNguyetDeleteByDate}/$id',
        data: {
          'kinhNguyetDelete': delete,
          'kinhNguyetUpdate': update,
        },
      );
      if (response.statusCode == 200) {
        return response.data['status'];
      }
      return false;
    } catch (e) {
      debugPrint('serverDeleteKNByDate ' + e.toString());
      return false;
    }
  }
}
