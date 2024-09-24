enum MessageType {
  text,
  image;

  static parseEnum(int id) {
    switch (id) {
      case 1:
        return MessageType.text;
      case 2:
        return MessageType.image;
      default:
        return MessageType.text;
    }
  }

  static parseId(MessageType? type) {
    switch (type) {
      case MessageType.text:
        return 1;
      case MessageType.image:
        return 2;
      default:
        return 1;
    }
  }
}

enum SenderType {
  ovumb,
  user,
}
