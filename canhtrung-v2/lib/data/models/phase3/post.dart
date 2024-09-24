import 'dart:convert';
import 'dart:io';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PostModel {
  final int id;
  final String? title;
  final String? content;
  final String? image;
  final String? link;
  PostModel({
    required this.id,
    this.title,
    this.content,
    this.image,
    this.link,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'image': image,
      'link': link,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] as int,
      title: map['title'] != null ? map['title'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      link: map['link'] != null ? map['link'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source) as Map<String, dynamic>);

  String get videoId => link?.split('/').last ?? '';

  bool isPdf() {
    if ((link ?? '').contains('.pdf') && Platform.isAndroid) {
      return true;
    }
    return false;
  }
}
