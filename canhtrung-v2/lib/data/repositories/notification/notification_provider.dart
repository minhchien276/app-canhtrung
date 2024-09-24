import 'package:flutter_ovumb_app_version1/services/models/noti_response.dart';

abstract class NotificationProvider {
  Future<GetNotifications> getNotification(int page);

  Future<GetNotificationDetail> getNotificationDetail(int id);
}
