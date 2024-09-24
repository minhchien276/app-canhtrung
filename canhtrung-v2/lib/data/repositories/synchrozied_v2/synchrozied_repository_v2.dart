import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/ket_qua_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/luong_kinh.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/thai_ki.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/ketquatest_v2/ketquatest_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/kinhnguyet_v2/kinhnguyet_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/luongkinh_v2/luongkinh_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/nhatky_v2/nhatky_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/server/server_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/synchrozied_v2/synchrozied_provider_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/thaiki_v2/thaiki_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_v2.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/warning_lh_dialog.dart';
import 'package:flutter_ovumb_app_version1/services/internet_connection.dart';

class SynchroziedRepositoryV2 implements SynchroziedProviderV2 {
  SynchroziedRepositoryV2._();
  static final SynchroziedRepositoryV2 _instance = SynchroziedRepositoryV2._();
  factory SynchroziedRepositoryV2() => _instance;

  final _prefs = SharedPreferencesService();
  final _kinhnguyet = KinhNguyetRepositoryV2();
  final _luongkinh = LuongKinhRepositoryV2();
  final _nhatky = NhatKyRepositoryV2();
  final _thaiki = ThaiKiRepositoryV2();
  final _ketquatest = KetQuaTestRepositoryV2();
  final _local = LocalRepository();
  final _server = ServerRepository();
  final _connect = InternetConnection();

  //SYNC SERVER
  Future synchroziedKinhNguyet(BuildContext context) async {
    bool check = await _prefs.syncKinhNguyet ?? true;
    print('synchroziedKinhNguyet $check');
    if (!check) {
      bool res = await _kinhnguyet.serverDeleteKNByDate();
      if (res) {
        await _prefs.setSyncKinhNguyet(true);
      }
    }
  }

  Future synchroziedLuongKinh() async {
    bool check = await _prefs.syncLuongKinh ?? true;
    print('synchroziedLuongKinh $check');
    if (!check) {
      bool res = await _luongkinh.serverSynchroziedLuongKinh();
      if (res) {
        await _prefs.setSyncLuongKinh(true);
        await _luongkinh.updateLuongKinhWhenSynced();
      }
    }
  }

  Future synchroziedNhatKy() async {
    bool check = await _prefs.syncNhatKy ?? true;
    print('synchroziedNhatKy $check');
    if (!check) {
      bool res = await _nhatky.serverSynchronizedNhatKy();
      if (res) {
        await _prefs.setSyncNhatKy(true);
        await _nhatky.updateNhatKyWhenSynced();
      }
    }
  }

  Future synchroziedNguoiDung() async {
    NguoiDung nguoiDung = await _local.getNguoiDung(_prefs.id ?? '');
    print('synchroziedNguoiDung ${nguoiDung.trangThai}');
    if (nguoiDung.trangThai == 0) {
      bool res = await _server.updatePhase(phase: nguoiDung.phase!);
      if (res) {
        await _local.updateTrangThaiWhenSynced();
      }
    }
  }

  Future synchroziedThaiKi() async {
    ThaiKi? thaiKi = await _thaiki.localGetThaiKi();
    if (thaiKi != null) {
      print('synchroziedThaiKi ${thaiKi.trangThai}');
      if (thaiKi.trangThai == 0) {
        bool res = await _thaiki.serverInsertThaiKi(thaiKi: thaiKi);
        if (res) {
          await _thaiki.localUpdateTrangThaiWhenSynced();
        }
      }
    }
  }

  @override
  Future synchroziedAll(BuildContext context) async {
    bool warning = await _prefs.warningKinhNguyet ?? true;
    print('synchroziedAll $warning');
    if (!warning) {
      await _prefs.setWarningKinhNguyet(true);
      KinhNguyet? current = await _kinhnguyet.localGetKN(trangThai: 1);
      if (current!.tbnkn > 45) {
        warningMenstrualDialog(context, current.tbnkn);
      }
    }
    bool connected = await _connect.status();
    if (connected) {
      synchroziedKinhNguyet(context);
      synchroziedNhatKy();
      synchroziedLuongKinh();
      synchroziedNguoiDung();
      synchroziedThaiKi();
    }
  }

  //SYNC LOCAL
  @override
  Future syncKinhNguyetToLocal(List<KinhNguyet> kinhnguyet) async {
    try {
      await _kinhnguyet.localInsertListKN(listKinhNguyet: kinhnguyet);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future syncLuongKinhToLocal(List<LuongKinh> luongkinh) async {
    try {
      luongkinh.forEach((e) async {
        await _luongkinh.insertLuongKinh(
          date: e.thoiGian,
          luongkinh: e.luongKinh,
          trangThai: 1,
        );
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future syncNhatKyToLocal(List map) async {
    try {
      if (map.isNotEmpty) {
        map.forEach((e) async {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(e['thoiGian']);
          List listCauTraLoi = e['cauTraLoi'];
          List<String> cauTraLoi = [];
          for (int i = 0; i < listCauTraLoi.length; i++) {
            cauTraLoi.add(listCauTraLoi[i]['cauTraLoi'] ?? '');
          }
          await _nhatky.insertListCauTraLoi(
            cauTraLoi: cauTraLoi,
            date: date,
            trangThaiNhatKy: 1,
          );
        });
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future syncThaiKiToLocal(List<ThaiKi> thaiKi) async {
    try {
      if (thaiKi.isNotEmpty) {
        await _thaiki.localInsertThaiKi(thaiKi: thaiKi.first);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future syncKetQuaTestToLocal(List<KetQuaTest> ketquatest) async {
    await _ketquatest.insertListKetQuaTest(listKetQuaTest: ketquatest);
  }

  //đồng bộ dữ liệu từ server vào local
  @override
  Future<bool> syncAllToLocal(dynamic data) async {
    print('syncAllToLocal');
    try {
      //get data
      List kinhnguyet = data['kinhnguyet'];
      if (kinhnguyet.isNotEmpty) {
        List luongkinh = data['luongkinh'];
        List ketquatest = data['ketquatest'];
        List thaiki = data['thaiki'];
        List nhatky = data['nhatky'];

        //parse data
        final listKinhnguyet =
            kinhnguyet.map((e) => KinhNguyet.fromJson(jsonEncode(e))).toList();
        final listLuongkinh =
            luongkinh.map((e) => LuongKinh.fromJson(jsonEncode(e))).toList();
        final listThaiki =
            thaiki.map((e) => ThaiKi.fromJson(jsonEncode(e))).toList();
        final listKetquatest =
            ketquatest.map((e) => KetQuaTest.fromJson(jsonEncode(e))).toList();

        await syncKinhNguyetToLocal(listKinhnguyet);
        await syncLuongKinhToLocal(listLuongkinh);
        await syncNhatKyToLocal(nhatky);
        await syncThaiKiToLocal(listThaiki);
        await syncKetQuaTestToLocal(listKetquatest);
        return true;
      }
      return false;
    } catch (e) {
      print('syncAllToLocal' + e.toString());
      return false;
    }
  }

  @override
  Future<bool> syncKinhNguyetWhenPassed() async {
    try {
      print('syncKinhNguyetWhenPassed');
      final now = DateTime.now().formatStartDate();
      KinhNguyet? current = await _kinhnguyet.localGetKNByDate(date: now);
      //nêú không có kinh nguyệt trong ngày hiện tại thì đã qua hết tất cả các chu kỳ
      if (current == null) {
        debugPrint(
            'nêú không có kinh nguyệt trong ngày hiện tại thì đã qua hết tất cả các chu kỳ');
        //lấy ra chu kỳ dự đoán để tạo list chu kỳ mới
        KinhNguyet? future = await _kinhnguyet.localGetKN(trangThai: 2);
        if (future != null) {
          List<KinhNguyet> initKN = CalendarV2.initListCKKN(
            ckdn: future.ckdn,
            cknn: future.cknn,
            snck: future.snck,
            tbnknInit: future.tbnkn,
            ngayBatDau: now, //ngày bắt đầu sẽ là ngày hiện tại
            maNguoiDung: future.maNguoiDung!,
            now: now,
          );

          //update các chu kỳ thành chu kỳ đã qua
          List<KinhNguyet> listKN = await _kinhnguyet.localGetListKN();
          listKN.forEach((kn) async {
            await _kinhnguyet.localUpdateTrangThai(
              maKinhNguyet: kn.maKinhNguyet!,
              trangThai: 0,
            );
          });

          //insert list chu kỳ mới
          await _kinhnguyet.localInsertListKN(listKinhNguyet: initKN);
          await _prefs.setSyncKinhNguyet(false);
        }
      }
      //nếu nằm trong chu kỳ dự đoán
      else if (current.trangThai == 2) {
        debugPrint('nếu nằm trong chu kỳ dự đoán');
        //lấy ra chu kỳ bằng 1 nhưng đã qua rồi để update trạng thái = 0
        KinhNguyet? pass = await _kinhnguyet.localGetKN(trangThai: 1);
        if (pass != null) {
          await _kinhnguyet.localUpdateTrangThai(
            maKinhNguyet: pass.maKinhNguyet!,
            trangThai: 0,
          );
        }

        //update trạng thái của chu kỳ dự đoán thành hiện tại = 1
        await _kinhnguyet.localUpdateTrangThai(
          maKinhNguyet: current.maKinhNguyet!,
          trangThai: 1,
        );

        //tạo ra một chu kỳ dự đoán mới và insert
        List<KinhNguyet> initKN = CalendarV2.initListCKKN(
          ckdn: current.ckdn,
          cknn: current.cknn,
          snck: current.snck,
          tbnknInit: current.tbnkn,
          ngayBatDau: current.ngayKetThuc!.add(Duration(
              days: 1)), //ngày bắt đầu là ngày kết thúc của chu kỳ hiện tại + 1
          maNguoiDung: current.maNguoiDung!,
        );
        await _kinhnguyet.localInsertListKN(listKinhNguyet: initKN);
        await _prefs.setSyncKinhNguyet(false);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
