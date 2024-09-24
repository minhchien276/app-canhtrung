import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/ket_qua_test.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/test/test_provider.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';
import 'package:flutter_ovumb_app_version1/services/models/test_response.dart';

class TestRepository implements TestProvider {
  TestRepository._();
  static final TestRepository _instance = TestRepository._();
  factory TestRepository() => _instance;
  final _dio = BaseService.instance.dio;
  final _prefs = SharedPreferencesService();

  @override
  Future<GetKQTests> getKQTests() async {
    final id = await _prefs.id;
    final response = await _dio.get('${ApiUrlV2.ketQuaTestFind}/$id');
    return GetKQTests(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<KetQuaTest>.from(
              response.data['data'].map((e) => KetQuaTest.fromMap(e)),
            )
          : [],
    );
  }
}
