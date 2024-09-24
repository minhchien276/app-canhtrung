import 'package:flutter_ovumb_app_version1/data/models/chat/message_model.dart';

abstract class ChatProvider {
  sendMessage(MessageModel item);
  Stream<List<MessageModel>> chatList();
}
