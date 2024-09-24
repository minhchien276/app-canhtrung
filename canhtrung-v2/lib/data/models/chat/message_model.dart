// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_ovumb_app_version1/data/enum/message_enum.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/chat/ovumb_card.dart';

class MessageModel {
  final int? id;
  final int index;
  final String? text;
  final String? image;
  final MessageType? type;
  final SenderType senderType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OvumbCardModel>? questions;
  MessageModel({
    this.id,
    required this.index,
    this.text,
    this.image,
    this.type,
    required this.senderType,
    this.createdAt,
    this.updatedAt,
    this.questions,
  });

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'text': text,
  //     'image': image,
  //     'type': MessageType.parseId(type),
  //     'createdAt': createdAt?.millisecondsSinceEpoch,
  //     'updatedAt': updatedAt?.millisecondsSinceEpoch,
  //     'questions': questions,
  //   };
  // }

  // factory MessageModel.fromMap(Map<String, dynamic> map) {
  //   return MessageModel(
  //     id: map['id'] != null ? map['id'] as int : null,
  //     text: map['text'] != null ? map['text'] as String : null,
  //     image: map['image'] != null ? map['image'] as String : null,
  //     type: map['type'] != null ? MessageType.parseEnum(map['type']) : null,
  //     createdAt: map['createdAt'] != null
  //         ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
  //         : null,
  //     updatedAt: map['updatedAt'] != null
  //         ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
  //         : null,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory MessageModel.fromJson(String source) =>
  //     MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
