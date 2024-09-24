import 'package:flutter_ovumb_app_version1/data/models/blog/blog.dart';
import 'package:flutter_ovumb_app_version1/data/models/blog/type_blog.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';

class GetTypeBlogResponse extends ApiResponse<List<TypeBlog>> {
  GetTypeBlogResponse({required super.status, required super.data});
}

class GetBlogsResponse extends ApiResponse<List<Blog>> {
  GetBlogsResponse({required super.status, required super.data});
}
