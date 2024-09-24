import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';

class GetLink extends ApiResponse<Guide?> {
  GetLink({required super.status, required super.data});
}
