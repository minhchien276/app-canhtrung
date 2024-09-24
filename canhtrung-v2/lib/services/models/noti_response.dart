import 'package:flutter_ovumb_app_version1/data/models/notification/notification.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';

class GetNotifications extends ApiResponse<List<NotificationModel>> {
  GetNotifications({required super.status, required super.data});
}

class GetNotificationDetail extends ApiResponse<NotificationModel> {
  GetNotificationDetail({required super.status, required super.data});
}
