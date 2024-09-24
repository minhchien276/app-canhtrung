import 'package:flutter_ovumb_app_version1/services/models/blog_response.dart';

abstract class BlogProvider {
  Future<GetTypeBlogResponse> getTypeBlog(int phase);
  Future<GetBlogsResponse> getBlogs(int id);
}
