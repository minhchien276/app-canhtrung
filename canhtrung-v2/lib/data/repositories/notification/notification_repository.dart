import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/models/notification/notification.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/notification/notification_provider.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';
import 'package:flutter_ovumb_app_version1/services/models/noti_response.dart';

class NotificationRepository implements NotificationProvider {
  NotificationRepository._();
  static final NotificationRepository _instance = NotificationRepository._();
  factory NotificationRepository() => _instance;
  final _dio = BaseService.instance.dio;

  @override
  Future<GetNotifications> getNotification(int page) async {
    final response = await _dio.get(ApiUrlV2.notificationGet);
    return GetNotifications(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<NotificationModel>.from(
              response.data['data'].map((e) => NotificationModel.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetNotificationDetail> getNotificationDetail(int id) async {
    final response =
        await _dio.get(ApiUrlV2.notificationGetDetail, data: {'id': id});
    return GetNotificationDetail(
      status: ApiResponseStatus.fromMap(response.data),
      data: NotificationModel.fromMap(response.data['data']),
    );
  }
}
