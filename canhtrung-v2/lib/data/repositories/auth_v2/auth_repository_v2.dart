import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url.dart';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/auth_v2/auth_provider_v2.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';
import 'package:flutter_ovumb_app_version1/services/models/auth_response.dart';

class AuthRepositoryV2 implements AuthProviderV2 {
  AuthRepositoryV2._();
  static final AuthRepositoryV2 _instance = AuthRepositoryV2._();
  factory AuthRepositoryV2() => _instance;

  final _dio = BaseService.instance.dio;
  final _prefs = SharedPreferencesService();
  final LocalRepository _localRepository = LocalRepository();

  @override
  Future<GetRegisterResponse> register({
    required String phone,
    required String password,
    required String name,
    required String email,
    required String dob,
  }) async {
    final response = await _dio.post(
      ApiUrlV2.authRegister,
      data: {
        'taiKhoan': phone,
        'matKhau': password,
        'tenNguoiDung': name,
        'email': email,
        'namSinh': dob,
        'ngayTao': DateTime.now().millisecondsSinceEpoch,
      },
    );
    return GetRegisterResponse(
      status: ApiResponseStatus.fromMap(response.data),
    );
  }

  @override
  Future<GetLoginResponse> login({
    required String taiKhoan,
    required String matKhau,
  }) async {
    final response = await _dio.post(
      ApiUrlV2.authLoginV2,
      data: {
        'taiKhoan': taiKhoan,
        'matKhau': matKhau,
      },
    );
    if (response.statusCode == 200) {
      if (response.data != null) {
        if (response.data['status'] == true) {
          //lưu token và mã người dùng của người dùng
          await _prefs.setToken(response.data['token']);
          await _prefs.setId(response.data['nguoidung']['maNguoiDung']);
          BaseService.instance.addToken(response.data['token']);
          //lưu người dùng vào local
          await _localRepository.insertNguoiDung(
              NguoiDung.fromJson(jsonEncode(response.data['nguoidung'])));
        }
      }
    }
    return GetLoginResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'],
    );
  }

  @override
  Future changePassword(
      {required String matKhau,
      required String matKhauMoi,
      required String password_confirmation}) async {
    try {
      String? maNguoiDung = await _prefs.id;

      final response = await _dio.post(
        '$authResetPassword/$maNguoiDung',
        data: {
          'matKhau': matKhau,
          'matKhauMoi': matKhauMoi,
          'password_confirmation': password_confirmation,
        },
      );
      if (response.statusCode == 200) {
        return response.data['status'];
      }
      return false;
    } on DioException catch (e) {
      if (e.error is SocketException) {
        throw 'Lỗi kết nối mạng';
      } else if (e.response!.statusCode == 500) {
        throw 'Hệ thống đang bảo trì. Vui lòng thử lại sau';
      } else {
        throw e.response!.data['message'];
      }
    }
  }

  @override
  Future<GetResetPasswordResponse> resetPassword(
      {required String email}) async {
    final response = await _dio.post(
      ApiUrlV2.mailResetPassword,
      data: {'email': email},
    );
    return GetResetPasswordResponse(
      status: ApiResponseStatus.fromMap(response.data),
    );
  }

  @override
  Future<String?> deleteAccount() async {
    try {
      String? maNguoiDung = await _prefs.id;

      final response =
          await _dio.post('$mailGenOtp', data: {'maNguoiDung': maNguoiDung});
      if (response.statusCode == 200) {
        if (response.data != null) {
          if (response.data['status'] == true) {
            return response.data['email'];
          }
        }
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<GetCheckSaveDataResponse> logged() async {
    String? maNguoiDung = await _prefs.id;
    final response = await _dio.get('${ApiUrlV2.authLogged}/$maNguoiDung');
    return GetCheckSaveDataResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'],
    );
  }

  @override
  Future logout() async {
    try {
      final response = await _dio.post(authLogout);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> verifyOtp({required String otp}) async {
    try {
      String? maNguoiDung = await _prefs.id;

      final response = await _dio.post('$mailVerifyOtp', data: {
        'maNguoiDung': maNguoiDung,
        'pin': otp,
      });
      if (response.statusCode == 200) {
        if (response.data != null) {
          return response.data['status'];
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UpdatePhaseResponse> updatePhase({required int phase}) async {
    final maNguoiDung = await _prefs.id;
    final response = await _dio.post(
      '${ApiUrlV2.authUpdatePhase}/$maNguoiDung',
      data: {'phase': phase},
    );
    return UpdatePhaseResponse(
      status: ApiResponseStatus.fromMap(response.data),
    );
  }

  @override
  Future<UpdateDeviceTokenResponse> updateDeviceToken() async {
    final maNguoiDung = await _prefs.id;
    final deviceToken = await _prefs.deviceToken;

    final response = await _dio.post(
      '${ApiUrlV2.authUpdateDeviceToken}/$maNguoiDung',
      data: {'device_token': deviceToken},
    );
    return UpdateDeviceTokenResponse(
      status: ApiResponseStatus.fromMap(response.data),
    );
  }
}
