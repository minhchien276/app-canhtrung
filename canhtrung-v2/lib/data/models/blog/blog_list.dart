// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_ovumb_app_version1/data/models/blog/blog.dart';

class BlogList {
  final String? name;
  final int? isHorizontal;
  final List<Blog> blogs;

  BlogList({
    this.name,
    this.isHorizontal,
    required this.blogs,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'blogs': blogs.map((x) => x.toMap()).toList(),
    };
  }

  factory BlogList.fromMap(Map<String, dynamic> map) {
    return BlogList(
      name: map['name'] != null ? map['name'] as String : null,
      isHorizontal:
          map['isHorizontal'] != null ? map['isHorizontal'] as int : null,
      blogs: List<Blog>.from(
        map['blogs'].map<Blog>((x) => Blog.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogList.fromJson(String source) =>
      BlogList.fromMap(json.decode(source) as Map<String, dynamic>);

  bool get isVertical => isHorizontal == 1 ? true : false;
}
