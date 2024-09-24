import 'dart:async';

import 'package:flutter_ovumb_app_version1/data/models/chat/message_model.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/chat/chat_provider.dart';
import 'package:rxdart/rxdart.dart';

class ChatRepository implements ChatProvider {
  ChatRepository._();
  static final ChatRepository _instance = ChatRepository._();
  factory ChatRepository() => _instance;

  final _stream = ReplaySubject<List<MessageModel>>(maxSize: 1);

  @override
  sendMessage(MessageModel item) async {
    if (_stream.values.isEmpty) {
      _stream.sink.add([item]);
    } else {
      List<MessageModel> items = _stream.values.last;
      _stream.sink.add([...items, item]);
    }
  }

  @override
  Stream<List<MessageModel>> chatList() => _stream.stream;
}
