import 'package:flutter_ovumb_app_version1/data/api_url/api_url.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';

class UpgradeApi {
  final _dio = BaseService.instance.dio;

  Future<int?> getLastestVersion() async {
    try {
      final response = await _dio.get(versionGet);
      if (response.statusCode == 200) {
        return response.data['version_id'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
