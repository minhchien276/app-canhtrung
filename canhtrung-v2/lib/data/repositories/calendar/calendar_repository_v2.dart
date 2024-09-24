import 'dart:async';

import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/calendar/calendar_day.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/ket_qua_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/luong_kinh.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nhat_ky.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/calendar/calendar_provider_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/ketquatest/ketquatest_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/kinhnguyet_v2/kinhnguyet_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/nhatky/nhatky_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/calendar.dart';

class CalendarRepositoryV2 implements CalendarProviderV2 {
  CalendarRepositoryV2._();
  static final CalendarRepositoryV2 _instance = CalendarRepositoryV2._();
  factory CalendarRepositoryV2() => _instance;

  final StreamController<CalendarDay> _stream = StreamController.broadcast();

  final _localRepository = LocalRepository();
  final _ketQuaTestRepository = KetQuaTestRepository();
  final _nhatkyRepository = NhatKyRepository();
  final _knV2 = KinhNguyetRepositoryV2();
  final _prefs = SharedPreferencesService();

  @override
  Future<CalendarDay> getCalendarData() async {
    try {
      final id = await _prefs.id ?? '';
      List<DateTime> listKinh = [];
      List<DateTime> listTrung = [];
      List<DateTime> listAnToanTuongDoi = [];
      List<DateTime> listAnToanTuyetDoi = [];
      final user = await _localRepository.getNguoiDung(id);

      List<KetQuaTest> listKetQua =
          await _ketQuaTestRepository.getListKetQuaTest();
      List<KetQuaTest> listKetQuaLast = [];
      List<DateTime> listLH = [];
      List<DateTime> listLHDD = [];
      listKetQua.forEach((e) {
        if (!listLH.contains(e.thoiGian)) {
          listLH.add(e.thoiGian);
          listKetQuaLast.add(e);
        } else {
          listKetQuaLast.removeAt(listKetQuaLast.length - 1);
          listKetQuaLast.add(e);
        }
        if (e.ketQua > 45) {
          if (!listLHDD.contains(e.thoiGian)) {
            listLHDD.add(e.thoiGian);
          }
        }
      });

      List<LuongKinh> listLuongKinh = await _nhatkyRepository.getListLuongKinh(
        maNguoiDung: id,
        tonTai: 0,
      );

      List<NhatKy> listNhatKy =
          await _nhatkyRepository.getListNhatKy(maNguoiDung: id);

      //lấy ra tất cả kinh nguyệt và tính
      List<KinhNguyet> listKinhNguyet = await _knV2.localGetListKN();

      for (int i = 0; i < listKinhNguyet.length; i++) {
        KinhNguyet kn = listKinhNguyet[i];
        print(kn.toJson().toString());
        print(kn.ngayBatDau);
        print(kn.ngayKetThuc);
        DateTime beginT = kn.ngayBatDauTrung!;
        DateTime endT = kn.ngayKetThucTrung!;
        DateTime beginK = kn.ngayBatDauKinh!;
        DateTime endK = kn.ngayKetThucKinh!;
        DateTime begin = kn.ngayBatDau!;
        DateTime end = kn.ngayKetThuc!;

        List<DateTime> listK = List<DateTime>.generate(
            endK.difference(beginK).inDays + 1,
            (index) => beginK.add(Duration(days: index)));

        List<DateTime> listT = [];
        listT = List<DateTime>.generate(endT.difference(beginT).inDays + 1,
            (index) => beginT.add(Duration(days: index)));

        List<DateTime> listAll = List<DateTime>.generate(
            end.difference(begin).inDays + 1,
            (index) => begin.add(Duration(days: index)));

        Set<DateTime> setAll = Set.from(listAll);
        Set<DateTime> setLH = Set.from(listLHDD);
        Set<DateTime> intersectionSetLH = setLH.intersection(setAll);
        List<DateTime> setToListLH = intersectionSetLH.toList();

        if (kn.trangThai != 0 && user.phase == 2) {
          KinhNguyet? current = await _knV2.localGetKN(trangThai: 1);
          if (current != null) {
            DateTime beginAT =
                kn.ngayKetThucTrung!.add(const Duration(days: 1));
            DateTime endAT = kn.ngayKetThuc!;
            if (beginAT.isBefore(endAT)) {
              List<DateTime> listAT = List<DateTime>.generate(
                  endAT.difference(beginAT).inDays + 1,
                  (index) => beginAT.add(Duration(days: index)));

              //tính ngày test cuối cùng đến ngày bắt đầu
              int leftDays = 0;
              if (setToListLH.isNotEmpty) {
                leftDays =
                    setToListLH.last.difference(current.ngayBatDau!).inDays + 1;
              }

              //nếu lớn hơn 7 thì show ngày AT tuyệt đối
              if (leftDays > 7) {
                DateTime last = setToListLH.last.add(Duration(days: 6));
                if (last.isBefore(endAT)) {
                  List<DateTime> listAT = List<DateTime>.generate(
                      endAT.difference(last).inDays + 1,
                      (index) => last.add(Duration(days: index)));
                  listAnToanTuyetDoi.addAll(listAT);
                }
                //remove list trung
                listT = [];
              }
              //nếu nhỏ hơn 7 hoặc chưa test thì show ngày AT tương đối
              else {
                listAnToanTuongDoi.addAll(listAT);
              }
            }
          }
        }
        listKinh.addAll(listK);
        listTrung.addAll(listT);
      }

      //lấy ra kinh nguyệt dự đoán và thêm các kinh nguyệt dự đoán
      KinhNguyet lastKinhNguyet = listKinhNguyet.last;
      int nct = testDay[lastKinhNguyet.tbnkn]! - 1;
      if (nct < lastKinhNguyet.snck) {
        nct = lastKinhNguyet.snck;
      }

      DateTime begin = lastKinhNguyet.ngayKetThuc!.add(Duration(days: 1));
      for (int i = 0; i < 3; i++) {
        DateTime end = begin.add(Duration(days: lastKinhNguyet.tbnkn - 1));
        DateTime beginK = begin;
        DateTime endK = beginK.add(Duration(days: lastKinhNguyet.snck - 1));
        DateTime beginT = begin.add(Duration(days: nct));
        DateTime endT = beginT.add(Duration(days: 6));
        List<DateTime> listK = List<DateTime>.generate(
            endK.difference(beginK).inDays + 1,
            (index) => beginK.add(Duration(days: index)));

        List<DateTime> listT = List<DateTime>.generate(
            endT.difference(beginT).inDays + 1,
            (index) => beginT.add(Duration(days: index)));

        listKinh.addAll(listK);
        listTrung.addAll(listT);
        listKinhNguyet.add(
          KinhNguyet(
            tbnkn: lastKinhNguyet.tbnkn,
            snck: lastKinhNguyet.snck,
            snct: lastKinhNguyet.snct,
            ckdn: lastKinhNguyet.ckdn,
            cknn: lastKinhNguyet.cknn,
            ngayBatDau: begin,
            ngayKetThuc: end,
            ngayBatDauTrung: beginT,
            ngayKetThucTrung: endT,
            ngayKetThucKinh: beginK,
            ngayBatDauKinh: endK,
            trangThai: 2,
          ),
        );
        begin = end.add(Duration(days: 1));

        if (i != 2 && user.phase == 2) {
          DateTime beginAT = listK.last.add(const Duration(days: 1));
          DateTime endAT = beginT.subtract(const Duration(days: 5));

          //tuyệt đối
          beginAT = endT.add(const Duration(days: 1));
          endAT = end;

          if (beginAT.isBefore(endAT)) {
            List<DateTime> listAT = List<DateTime>.generate(
                endAT.difference(beginAT).inDays + 1,
                (index) => beginAT.add(Duration(days: index)));
            listAnToanTuongDoi.addAll(listAT);
          }
        }
      }

      //lấy ra kinh nguyệt hiện tại
      KinhNguyet? currentKinhNguyet = await _knV2.localGetKN(trangThai: 1);
      KinhNguyet? futureKinhNguyet = await _knV2.localGetKN(trangThai: 2);
      _stream.sink.add(
        CalendarDay(
          listKinh: listKinh,
          listTrung: listTrung,
          listAnToanTuongDoi: listAnToanTuongDoi,
          listAnToanTuyetDoi: listAnToanTuyetDoi,
          listNhatKy: listNhatKy,
          listKetQuaTest: listKetQuaLast,
          listLuongKinh: listLuongKinh,
          listKinhNguyet: listKinhNguyet,
          listLH: listLH,
          currentKinhNguyet: currentKinhNguyet!,
          futureKinhNguyet: futureKinhNguyet!,
        ),
      );
      return CalendarDay(
        listKinh: listKinh,
        listTrung: listTrung,
        listNhatKy: listNhatKy,
        listAnToanTuongDoi: listAnToanTuongDoi,
        listAnToanTuyetDoi: listAnToanTuyetDoi,
        listKetQuaTest: listKetQuaLast,
        listLuongKinh: listLuongKinh,
        listKinhNguyet: listKinhNguyet,
        listLH: listLH,
        currentKinhNguyet: currentKinhNguyet,
        futureKinhNguyet: futureKinhNguyet,
      );
    } catch (e) {
      throw (e.toString());
    }
  }

  @override
  Stream<CalendarDay> streamData() => _stream.stream;
}
