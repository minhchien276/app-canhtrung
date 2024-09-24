import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/notification/notification.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/notification/notification_repository.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/notification/notifcation_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit()
      : super(NotificationState(
          isLoading: false,
          isRefreshing: false,
          isLoadingMore: false,
          notifications: [],
          data: {},
        ));

  final _notiRepository = NotificationRepository();

  final _endReachedThreshold = 200;
  bool _isEmpty = false;
  int _currentPage = 0;
  int _size = 20;
  ScrollController scroll = ScrollController();

  bool get isFreezing =>
      (state.isLoading || state.isRefreshing || state.isLoadingMore) &&
      !_isEmpty;

  _mapping(List<NotificationModel> notis) {
    Map<DateTime, List<NotificationModel>> map = {};
    for (var e in notis) {
      var key = e.createdAt!.formatStartDate();
      if (map[key] != null) {
        map[key]!.add(e);
      } else {
        map[key] = [e];
      }
    }
    return map;
  }

  //prevent request when data is empty
  void emptyData(int len) {
    if (len < _size) {
      _isEmpty = true;
      debugPrint('empty data to get');
    }
  }

  Future<void> fetch() async {
    if (isFreezing) return;
    debugPrint('begin fetching');
    emit(state.copyWith(isLoading: true));
    final response = await _notiRepository.getNotification(_currentPage);
    emptyData(response.data.length);
    emit(state.copyWith(
      isLoading: false,
      notifications: [...response.data],
      data: _mapping([...response.data]),
    ));
    debugPrint('fetched');
  }

  Future<void> refreshing() async {
    if (isFreezing) return;
    debugPrint('begin refresh');
    _currentPage = 0;
    emit(state.copyWith(isRefreshing: true));
    final response = await _notiRepository.getNotification(_currentPage);
    emptyData(response.data.length);
    emit(state.copyWith(
      isRefreshing: false,
      notifications: [...response.data],
      data: _mapping([...response.data]),
    ));
    debugPrint('refreshed');
  }

  Future<void> loadmore() async {
    if (isFreezing || _isEmpty) return;
    debugPrint('begin loadmore');
    ++_currentPage;
    emit(state.copyWith(isLoadingMore: true));
    final response = await _notiRepository.getNotification(_currentPage);
    emptyData(response.data.length);
    state.notifications.addAll(response.data);
    emit(state.copyWith(
      isLoadingMore: false,
      notifications: state.notifications,
      data: _mapping(state.notifications),
    ));
    debugPrint('loaded');
  }

  void _onScroll() {
    if (!isFreezing &&
        scroll.hasClients &&
        scroll.position.extentAfter < _endReachedThreshold) {
      loadmore();
    }
  }

  void addListener(VoidCallback listener) {
    scroll.addListener(_onScroll);
  }

  void removeListener(VoidCallback listener) {
    scroll.removeListener(_onScroll);
  }
}
