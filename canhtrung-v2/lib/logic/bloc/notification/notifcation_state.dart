// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:equatable/equatable.dart';

import 'package:flutter_ovumb_app_version1/data/models/notification/notification.dart';

class NotificationState extends Equatable {
  bool isLoading;
  bool isRefreshing;
  bool isLoadingMore;
  List<NotificationModel> notifications;
  Map<DateTime, List<NotificationModel>> data;

  NotificationState({
    required this.isLoading,
    required this.isRefreshing,
    required this.isLoadingMore,
    required this.notifications,
    required this.data,
  });

  copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    List<NotificationModel>? notifications,
    Map<DateTime, List<NotificationModel>>? data,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      notifications: notifications ?? this.notifications,
      data: data ?? this.data,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isRefreshing, isLoadingMore, notifications, data];
}
