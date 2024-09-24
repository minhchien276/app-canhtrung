import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/link/link_v2_provider.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:flutter_ovumb_app_version1/services/models/link_response.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';

class LinkV2Repository extends LinkV2Provider {
  LinkV2Repository._();
  static final LinkV2Repository _instance = LinkV2Repository._();
  factory LinkV2Repository() => _instance;

  final _prefs = SharedPreferencesService();
  final _dio = BaseService.instance.dio;
  @override
  Future<GetLink> getBuMeLink() async {
    final response = await _dio.get(
      ApiUrlV2.videoGetBuMe,
      data: {'maNguoiDung': _prefs.id},
    );
    return GetLink(
      status: ApiResponseStatus.fromMap(response.data),
      data: (response.data['data'] as List).isNotEmpty
          ? Guide.fromMap(response.data['data'][0])
          : null,
    );
  }
}
