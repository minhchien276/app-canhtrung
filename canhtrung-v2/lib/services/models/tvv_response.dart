import 'package:flutter_ovumb_app_version1/data/models/nguoidung/tvv.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';

class GetTVVResponse extends ApiResponse<List<TVV>> {
  GetTVVResponse({required super.status, required super.data});
}
