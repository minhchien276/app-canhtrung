import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/tvv.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/tvv/tvv_provider.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';
import 'package:flutter_ovumb_app_version1/services/models/tvv_response.dart';

class TVVRepository implements TVVProvider {
  TVVRepository._();
  static final TVVRepository _instance = TVVRepository._();
  factory TVVRepository() => _instance;
  final _dio = BaseService.instance.dio;
  final _prefs = SharedPreferencesService();

  @override
  Future<GetTVVResponse> getTVV(int type) async {
    final maNguoiDung = await _prefs.id;
    final response = await _dio.get(
      '${ApiUrlV2.tvvGetbyUser}/$maNguoiDung/$type',
    );

    return GetTVVResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<TVV>.from(
              response.data['data'].map((e) => TVV.fromMap(e)),
            )
          : [],
    );
  }
}
