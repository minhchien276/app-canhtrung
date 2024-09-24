import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/ket_qua_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/quan_ly_que_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/test_resutl.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';

class GetKQTests extends ApiResponse<List<KetQuaTest>> {
  GetKQTests({required super.status, required super.data});
}

class InsertTestResponse extends ApiResponse<TestResult> {
  InsertTestResponse({required super.status, required super.data});
}

class GetQuanLyQueTestResponse extends ApiResponse<QuanLyQueTest?> {
  GetQuanLyQueTestResponse({required super.status, required super.data});
}

class GetListGuideResponse extends ApiResponse<List<Guide>> {
  GetListGuideResponse({required super.status, required super.data});
}

class UpdateHopTestResponse extends ApiResponse<QuanLyQueTest?> {
  UpdateHopTestResponse({required super.status, required super.data});
}
