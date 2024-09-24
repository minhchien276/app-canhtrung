// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';
import 'package:flutter_ovumb_app_version1/data/models/blog/blog.dart';
import 'package:flutter_ovumb_app_version1/data/models/blog/type_blog.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/cau_hoi.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/tvv.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/chart/chart_screen.dart';

class MainState extends Equatable {
  final bool isLoading;
  final String? loadingText;
  final NguoiDung? user;
  final List<CauHoi> listCauHoi;
  final Map<String, List<ChartLHData>> ketQuaTest;
  final DateTime? ngayDuSinh;
  final List<TypeBlog> blogTypes;
  final List<List<Blog>> blogs;
  final List<TVV> tvv;

  const MainState({
    this.isLoading = false,
    this.loadingText,
    this.user,
    required this.listCauHoi,
    required this.ketQuaTest,
    this.ngayDuSinh,
    required this.blogTypes,
    required this.blogs,
    required this.tvv,
  });

  copyWith({
    bool? isLoading,
    NguoiDung? user,
    List<CauHoi>? listCauHoi,
    Map<String, List<ChartLHData>>? ketQuaTest,
    DateTime? ngayDuSinh,
    List<TypeBlog>? blogTypes,
    List<List<Blog>>? blogs,
    List<TVV>? tvv,
  }) {
    return MainState(
      isLoading: isLoading ?? false,
      user: user ?? this.user,
      listCauHoi: listCauHoi ?? this.listCauHoi,
      ketQuaTest: ketQuaTest ?? this.ketQuaTest,
      ngayDuSinh: ngayDuSinh ?? this.ngayDuSinh,
      blogTypes: blogTypes ?? this.blogTypes,
      blogs: blogs ?? this.blogs,
      tvv: tvv ?? this.tvv,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        user,
        listCauHoi,
        ketQuaTest,
        ngayDuSinh,
        blogTypes,
        blogs,
        tvv,
      ];
}
