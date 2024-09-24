import 'dart:async';
import 'dart:convert';
import 'package:flutter_ovumb_app_version1/data/local_data/database/constant.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/database.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/cau_hoi.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/cau_tra_loi.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/thai_ki.dart';

class LocalProvider {
  static final LocalProvider _instance = LocalProvider._internal();
  factory LocalProvider() {
    return _instance;
  }
  LocalProvider._internal();
  final dbProvider = DatabaseProvider.db;
  final _prefs = SharedPreferencesService();

  //Người dùng
  //insert người dùng
  Future<int?> insertNguoiDung(
    NguoiDung nguoiDung,
  ) async {
    final db = await dbProvider.database;
    final check = await db.query(
      tableNguoiDung,
      where: 'maNguoiDung = ?',
      whereArgs: [nguoiDung.maNguoiDung],
    );
    if (check.isEmpty) {
      try {
        int id = await db.insert(tableNguoiDung, {
          'maNguoiDung': nguoiDung.maNguoiDung,
          'tenNguoiDung': nguoiDung.tenNguoiDung,
          'namSinh': nguoiDung.namSinh,
          'chieuCao': nguoiDung.chieuCao,
          'canNang': nguoiDung.canNang,
          'phase': nguoiDung.phase,
          'avatar': nguoiDung.avatar,
          'trangThai': nguoiDung.trangThai,
        });
        return id;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // lấy người dùng
  Future<NguoiDung> getNguoiDung(String id) async {
    try {
      final db = await dbProvider.database;
      final user = await db.query(
        tableNguoiDung,
        where: 'maNguoiDung = ?',
        whereArgs: [id],
      );
      return NguoiDung.fromJson(jsonEncode(user.first));
    } catch (e) {
      throw (e.toString());
    }
  }

  //cập nhật người dùng
  Future<bool> updateNguoiDung(
    NguoiDung nguoiDung,
  ) async {
    try {
      final db = await dbProvider.database;
      await db.update(
        tableNguoiDung,
        {
          'tenNguoiDung': nguoiDung.tenNguoiDung,
          'chieuCao': nguoiDung.chieuCao,
          'canNang': nguoiDung.canNang,
          'avatar': nguoiDung.avatar,
        },
        where: 'maNguoiDung = ?',
        whereArgs: [nguoiDung.maNguoiDung],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //cập nhật người dùng
  Future<bool> updateTrangThaiWhenSynced() async {
    try {
      final db = await dbProvider.database;
      await db.update(
        tableNguoiDung,
        {
          'trangThai': 1,
        },
        where: 'maNguoiDung = ?',
        whereArgs: [_prefs.id],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //cập nhật phase người dùng
  Future<bool> updatePhase(
    int phase,
  ) async {
    try {
      String? maNguoiDung = await _prefs.id;
      final db = await dbProvider.database;
      await db.update(
        tableNguoiDung,
        {
          'phase': phase,
          'trangThai': 0, //0: chưa đồng bộ, 1: đã đồng bộ
        },
        where: 'maNguoiDung = ?',
        whereArgs: [maNguoiDung],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //Câu hỏi
  //insert câu hỏi
  Future<bool> insertCauHoi(List<CauHoi> listCauHoi) async {
    final db = await dbProvider.database;
    final check = await db.query(tableCauHoi);
    if (check.isEmpty) {
      try {
        listCauHoi.forEach((e) async {
          await db.insert(tableCauHoi, {
            'maCauHoi': e.maCauHoi,
            'noiDung': e.noiDung,
          });
        });
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  //insert câu hỏi
  Future<List<CauHoi>> getListCauHoi() async {
    final db = await dbProvider.database;
    final listCauHoi = await db.query(tableCauHoi);
    final List<CauHoi> list = [];
    listCauHoi.forEach((e) {
      list.add(CauHoi.fromJson(jsonEncode(e)));
    });
    return list;
  }

  //delete câu hỏi
  Future<bool> deleteCauHoi() async {
    final db = await dbProvider.database;
    try {
      await db.delete(tableCauHoi);
      return true;
    } catch (e) {
      return false;
    }
  }

  //câu trả lời
  //get CauTraLoi
  Future<CauTraLoi?> getCauTraLoi(
    int maNhatKy,
    int maCauHoi,
  ) async {
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
      throw (e.toString());
    }
  }

  //update list CauTraLoi
  Future<bool> insertListCauTraLoi(
    int maNhatKy,
    List<String> listCauTraLoi,
    bool connected,
  ) async {
    try {
      for (int i = 0; i < listCauTraLoi.length; i++) {
        await insertCauTraLoi(maNhatKy, i + 1, listCauTraLoi[i]);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  //insert CauTraLoi
  Future<bool> insertCauTraLoi(
    int maNhatKy,
    int maCauHoi,
    String cauTraLoi,
  ) async {
    final db = await dbProvider.database;
    try {
      await db.insert(tableCauTraLoi, {
        'maNhatKy': maNhatKy,
        'maCauHoi': maCauHoi,
        'cauTraLoi': cauTraLoi,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  //update CauTraLoi
  Future<bool> updateCauTraLoi(
    int maCauTraLoi,
    String cauTraLoi,
  ) async {
    final db = await dbProvider.database;
    try {
      await db.update(
        tableCauTraLoi,
        {
          'cauTraLoi': cauTraLoi,
        },
        where: 'maCauTraLoi = ?',
        whereArgs: [maCauTraLoi],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // xoá dữu liệu khi đăng xuất
  Future<bool> deleteAll() async {
    final db = await dbProvider.database;
    try {
      await db.delete(tableCauTraLoi);
      await db.delete(tableNhatKy);
      await db.delete(tableKinhNguyet);
      await db.delete(tableNguoiDung);
      await db.delete(tableThaiKi);
      await db.delete(tableLuongKinh);
      await db.delete(tableKetQuaTest);
      return true;
    } catch (e) {
      return false;
    }
  }

  //insert thai kì
  Future<bool> insertThaiKi(ThaiKi thaiKi) async {
    try {
      final db = await dbProvider.database;
      String? maNguoiDung = await SharedPreferencesService().id;
      if (maNguoiDung != null) {
        ThaiKi? tk = await getThaiKi(maNguoiDung);
        if (tk == null) {
          await db.insert(
              tableThaiKi,
              jsonDecode(ThaiKi(
                      maNguoiDung: maNguoiDung, ngayDuSinh: thaiKi.ngayDuSinh)
                  .toJson()));
        } else {
          await updateThaiKi(
            ThaiKi(
              maNguoiDung: maNguoiDung,
              ngayDuSinh: thaiKi.ngayDuSinh,
              trangThai: 0,
            ),
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  //get thai kì
  Future<ThaiKi?> getThaiKi(String maNguoiDung) async {
    final db = await dbProvider.database;
    try {
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
      throw e;
    }
  }

  //update thai kì
  Future<bool> updateThaiKi(ThaiKi thaiKi) async {
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

  //delete thai kì
  Future<bool> deleteThaiKi(String maNguoiDung) async {
    final db = await dbProvider.database;
    try {
      await db.delete(
        tableThaiKi,
        where: 'maNguoiDung = ?',
        whereArgs: [maNguoiDung],
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
