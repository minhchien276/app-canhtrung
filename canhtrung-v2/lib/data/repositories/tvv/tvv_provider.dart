import 'package:flutter_ovumb_app_version1/services/models/tvv_response.dart';

abstract class TVVProvider {
  Future<GetTVVResponse> getTVV(int type);
}
