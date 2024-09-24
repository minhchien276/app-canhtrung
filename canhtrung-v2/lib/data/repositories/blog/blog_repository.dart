import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/models/blog/blog.dart';
import 'package:flutter_ovumb_app_version1/data/models/blog/type_blog.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/blog/blog_provider.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';
import 'package:flutter_ovumb_app_version1/services/models/blog_response.dart';

class BlogRepository implements BlogProvider {
  BlogRepository._();
  static final BlogRepository _instance = BlogRepository._();
  factory BlogRepository() => _instance;
  final _dio = BaseService.instance.dio;

  @override
  Future<GetBlogsResponse> getBlogs(int id) async {
    final response = await _dio.get('${ApiUrlV2.blogListBlog}/$id');
    return GetBlogsResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<Blog>.from(
              response.data['data'].map((e) => Blog.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetTypeBlogResponse> getTypeBlog(int phase) async {
    final response = await _dio.get('${ApiUrlV2.blogGetListType}/$phase');
    return GetTypeBlogResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<TypeBlog>.from(
              response.data['data'].map((e) => TypeBlog.fromMap(e)),
            )
          : [],
    );
  }
}
