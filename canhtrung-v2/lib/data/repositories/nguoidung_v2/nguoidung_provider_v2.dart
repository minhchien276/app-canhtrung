import 'package:dio/dio.dart';
import 'package:flutter_ovumb_app_version1/services/models/user_response.dart';

abstract class NguoiDungProviderV2 {
  Future<int?> getTrangThai();
  Future<bool> updateTrangThai({required int trangThai});
  Future<UpdateUserResponse> updateUser(FormData data);
}
