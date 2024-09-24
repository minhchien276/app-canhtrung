// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/widgets.dart';

class FetchStatus extends ChangeNotifier {
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> setLoading(bool input) async {
    _isLoading = input;
    notifyListeners();
  }

  Future<void> setRefreshing(bool input) async {
    _isRefreshing = input;
    notifyListeners();
  }

  Future<void> setLoadingMore(bool input) async {
    _isLoadingMore = input;
    notifyListeners();
  }
}
