import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';

abstract class KinhNguyetProviderV2 {
  //local
  Future<bool> localInsertKN({required KinhNguyet kinhNguyet});
  Future<bool> localInsertListKN({required List<KinhNguyet> listKinhNguyet});
  Future<List<KinhNguyet>> localGetListKN();
  Future<List<KinhNguyet>> localGetListKNByTrangThai({required int trangThai});
  Future<KinhNguyet?> localGetKN({required int trangThai});
  Future<KinhNguyet?> localGetKNByDate({required DateTime date});
  Future<KinhNguyet?> localGetNextKNFromDate({required DateTime date});
  Future<bool> localUpdateNgayKinh({required DateTime date});
  Future<bool> localUpdateTrangThai(
      {required int maKinhNguyet, required int trangThai});
  Future<bool> localUpdateKinhNguyet(
      {required int maKinhNguyet, required KinhNguyet kinhNguyet});
  Future<bool> localDeleteKN({required int maKinhNguyet});
  Future<bool> localDeleteKNFromDate({required DateTime date});
  Future<bool> localDeleteKNWhenSynced();
  Future<bool> localResetCKKNWhenTestLH();

  //server
  Future<List<KinhNguyet>?> serverGetListKN();
  Future<bool> serverInsertListKN({required List<KinhNguyet> listKinhNguyet});
  Future<bool> serverDeleteKNByDate();
}
