// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_ovumb_app_version1/data/models/other/model_nhatky.dart';

class NhatKyState {
  final String? luongkinh;
  final Data listLuongkinh;
  final List<Data> answers;
  final DateTime? date;
  const NhatKyState({
    this.luongkinh,
    required this.listLuongkinh,
    required this.answers,
    this.date,
  });
}
