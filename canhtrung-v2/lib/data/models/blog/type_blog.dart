import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TypeBlog {
  final int id;
  final String type;
  final int? isHorizontal;
  TypeBlog({
    required this.id,
    required this.type,
    this.isHorizontal,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
    };
  }

  factory TypeBlog.fromMap(Map<String, dynamic> map) {
    return TypeBlog(
      id: map['id'] as int,
      type: map['type'] as String,
      isHorizontal: map['isHorizontal'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TypeBlog.fromJson(String source) =>
      TypeBlog.fromMap(json.decode(source) as Map<String, dynamic>);
  bool get isVertical => isHorizontal == 1 ? true : false;
}
