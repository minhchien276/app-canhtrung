import 'package:flutter_ovumb_app_version1/data/models/nguoidung/luong_kinh.dart';

abstract class LuongKinhProviderV2 {
  Future<LuongKinh?> getLuongKinh({required DateTime date, int? trangThai});
  Future<bool> insertLuongKinh(
      {required DateTime date, required String? luongkinh});
  Future deleteLuongKinh({required DateTime date});
  Future<List<LuongKinh>> getListLuongKinh(
      {required DateTime begin, required DateTime end});
  Future<List<LuongKinh>> getLuongKinhNotSync();
  Future updateLuongKinhWhenSynced();
  Future<bool> serverSynchroziedLuongKinh();
}
