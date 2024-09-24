enum NotificationType {
  user,
  order,
  discount;

  parseId() {
    switch (this) {
      case NotificationType.user:
        return 0;
      case NotificationType.order:
        return 1;
      case NotificationType.discount:
        return 2;
      default:
        return 0;
    }
  }

  static toEnum(int id) {
    switch (id) {
      case 0:
        return NotificationType.user;
      case 1:
        return NotificationType.order;
      case 2:
        return NotificationType.discount;
      default:
        return NotificationType.user;
    }
  }
}
