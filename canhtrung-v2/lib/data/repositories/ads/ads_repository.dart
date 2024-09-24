import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/ads/ads_provider.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';

class AdsRepository implements AdsProvider {
  AdsRepository._();
  static final AdsRepository _instance = AdsRepository._();
  factory AdsRepository() => _instance;

  final _dio = BaseService.instance.dio;
  @override
  Future clickAds() async {
    try {
      await _dio.post(ApiUrlV2.adsClick);
      return null;
    } catch (e) {
      return null;
    }
  }
}
