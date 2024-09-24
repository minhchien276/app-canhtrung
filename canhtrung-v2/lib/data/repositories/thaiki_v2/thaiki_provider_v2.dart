import 'package:flutter_ovumb_app_version1/data/models/nguoidung/thai_ki.dart';
import 'package:flutter_ovumb_app_version1/services/models/thaiki_response.dart';

abstract class ThaiKiProviderV2 {
  //Local
  Future<bool> localInsertThaiKi({required ThaiKi thaiKi});
  Future<ThaiKi?> localGetThaiKi();
  Future<bool> localUpdateThaiKi({required ThaiKi thaiKi});
  Future<bool> localUpdateTrangThaiWhenSynced();
  Future<bool> localInsertNgayDuSinh();
  Future<bool> localDeleteNgayDuSinh();

  //Server
  Future<bool> serverInsertThaiKi({required ThaiKi thaiKi});
  Future<DeleteThaiKyResponse> serverDeleteThaiKy();
}
