import 'package:flutter_ovumb_app_version1/services/models/auth_response.dart';

abstract class AuthProviderV2 {
  Future<GetRegisterResponse> register({
    required String phone,
    required String password,
    required String name,
    required String email,
    required String dob,
  });

  Future<GetLoginResponse> login({
    required String taiKhoan,
    required String matKhau,
  });

  Future<UpdatePhaseResponse> updatePhase({
    required int phase,
  });

  Future logout();

  Future<GetResetPasswordResponse> resetPassword({required String email});

  Future changePassword({
    required String matKhau,
    required String matKhauMoi,
    required String password_confirmation,
  });

  Future<String?> deleteAccount();

  Future<bool> verifyOtp({required String otp});

  Future<GetCheckSaveDataResponse> logged();

  Future<UpdateDeviceTokenResponse> updateDeviceToken();
}
 