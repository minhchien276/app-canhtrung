import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/ket_qua_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/luong_kinh.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/thai_ki.dart';

abstract class SynchroziedProviderV2 {
  Future synchroziedAll(BuildContext context);

  //sync local
  Future syncKinhNguyetToLocal(List<KinhNguyet> kinhnguyet);
  Future syncLuongKinhToLocal(List<LuongKinh> luongkinh);
  Future syncNhatKyToLocal(List map);
  Future syncThaiKiToLocal(List<ThaiKi> thaiKi);
  Future syncKetQuaTestToLocal(List<KetQuaTest> ketquatest);
  Future<bool> syncAllToLocal(dynamic data);
  Future<bool> syncKinhNguyetWhenPassed();
}
