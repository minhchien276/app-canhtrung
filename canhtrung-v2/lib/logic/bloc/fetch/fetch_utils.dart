import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/fetch/fetch_state.dart';

class FetchUtils<T> extends FetchStatus {
  final Future<List<T>> Function(int page) fetchApi;
  final bool? isLoadmoreEnabled;
  FetchUtils(
      {required this.fetchApi,
      required int size,
      this.isLoadmoreEnabled = false})
      : _size = size;

  final _endReachedThreshold = 200;
  List<T> _data = [];
  final int _size;
  bool _isEmpty = false;
  int _currentPage = 0;
  ScrollController scroll = ScrollController();
  List<T> get data => _data.toSet().toList();

  bool get isFreezing =>
      (isLoading || isRefreshing || isLoadingMore) && !_isEmpty;

  updateData(var value) {
    _data = value;
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
    setLoading(true);
    final response = await fetchApi(_currentPage);
    _data = [...response];
    emptyData(response.length);
    debugPrint('fetched');
    setLoading(false);
  }

  Future<void> refreshing() async {
    if (isFreezing) return;
    debugPrint('begin refresh');
    _currentPage = 0;
    setRefreshing(true);
    final response = await fetchApi(_currentPage);
    _data = [...response];
    emptyData(response.length);
    debugPrint('refreshed');
    setRefreshing(false);
  }

  Future<void> loadmore() async {
    if (isFreezing || _isEmpty) return;
    debugPrint('begin loadmore');
    ++_currentPage;
    setLoadingMore(true);
    final response = await fetchApi(_currentPage);
    emptyData(response.length);
    _data.addAll(response);
    debugPrint('loaded');
    setLoadingMore(false);
  }

  void _onScroll() {
    if (isLoadmoreEnabled == true &&
        !isFreezing &&
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
