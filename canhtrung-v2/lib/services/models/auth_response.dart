import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';

class GetLoginResponse extends ApiResponse<dynamic> {
  GetLoginResponse({required super.status, required super.data});
}

class GetRegisterResponse extends ApiResponse<bool> {
  GetRegisterResponse({required super.status, super.data = true});
}

class GetResetPasswordResponse extends ApiResponse<bool> {
  GetResetPasswordResponse({required super.status, super.data = true});
}

class GetCheckSaveDataResponse extends ApiResponse<dynamic> {
  GetCheckSaveDataResponse({required super.status, required super.data});
}

class UpdatePhaseResponse extends ApiResponse<bool> {
  UpdatePhaseResponse({required super.status, super.data = true});
}

class UpdateDeviceTokenResponse extends ApiResponse<bool> {
  UpdateDeviceTokenResponse({required super.status, super.data = true});
}
