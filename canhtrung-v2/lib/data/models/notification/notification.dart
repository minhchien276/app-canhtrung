// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_ovumb_app_version1/data/enum/notification_enum.dart';

class NotificationModel {
  final int id;
  final String? title;
  final String? content;
  final String? receiverId;
  final String? senderId;
  final dynamic applicationId;
  final NotificationType type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  NotificationModel({
    required this.id,
    this.title,
    this.content,
    this.receiverId,
    this.senderId,
    required this.applicationId,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'receiverId': receiverId,
      'senderId': senderId,
      'type': type.parseId(),
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int,
      title: map['title'] != null ? map['title'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
      receiverId:
          map['receiverId'] != null ? map['receiverId'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      applicationId: map['applicationId'],
      type: NotificationType.toEnum(map['type']),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
