import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';

enum OrderStatusEnum {
  processing,
  confirmed,
  delivering,
  success,
  cancelled,
}

class OrderSatus {
  String buildText(OrderStatusEnum orderStatus) {
    switch (orderStatus) {
      case OrderStatusEnum.processing:
        return 'Đang xử lý';
      case OrderStatusEnum.confirmed:
        return 'Đã xác nhận';
      case OrderStatusEnum.delivering:
        return 'Đang vận chuyển';
      case OrderStatusEnum.success:
        return 'Đã giao hàng';
      case OrderStatusEnum.cancelled:
        return 'Đã hủy';
      default:
        return 'Đang xử lý';
    }
  }

  String buildTitleText(OrderStatusEnum orderStatus) {
    switch (orderStatus) {
      case OrderStatusEnum.processing:
        return 'Đơn hàng đang được xử lý';
      case OrderStatusEnum.confirmed:
        return 'Đơn hàng đã được xác nhận';
      case OrderStatusEnum.delivering:
        return 'Đơn hàng đang được vận chuyển';
      case OrderStatusEnum.success:
        return 'Đã giao hàng';
      case OrderStatusEnum.cancelled:
        return 'Đã hủy đơn hàng';
      default:
        return 'Đơn hàng đang được xử lý';
    }
  }

  String buildSubText(OrderStatusEnum orderStatus) {
    switch (orderStatus) {
      case OrderStatusEnum.processing:
        return 'Đơn hàng sẽ được xác nhận trong thời gian sớm nhất';
      case OrderStatusEnum.confirmed:
        return 'Đơn hàng sẽ đóng gói và giao cho đơn vị vận chuyển';
      case OrderStatusEnum.delivering:
        return 'Đơn hàng sẽ giao đến bạn trong vòng 2 - 3 ngày';
      case OrderStatusEnum.success:
        return 'Đơn hàng đã được giao đến khách hàng và chờ xác nhận';
      case OrderStatusEnum.cancelled:
        return 'Quý khách có thể liên hệ với chuyên gia nếu cần hỗ trợ thêm';
      default:
        return 'Đơn hàng sẽ được xác nhận trong thời gian sớm nhất';
    }
  }

  Color buildTextColor(OrderStatusEnum orderStatus) {
    switch (orderStatus) {
      case OrderStatusEnum.processing:
        return grey400;
      case OrderStatusEnum.confirmed:
        return Color(0xffED9A77);
      case OrderStatusEnum.delivering:
        return Color(0xff6DA2F1);
      case OrderStatusEnum.success:
        return Color(0xff62CF9B);
      case OrderStatusEnum.cancelled:
        return Color(0xffED7793);
      default:
        return grey400;
    }
  }

  Color buildBgColor(OrderStatusEnum orderStatus) {
    switch (orderStatus) {
      case OrderStatusEnum.processing:
        return grey200;
      case OrderStatusEnum.confirmed:
        return Color(0xffFFF1EB);
      case OrderStatusEnum.delivering:
        return Color(0xffEBF8FF);
      case OrderStatusEnum.success:
        return Color(0xffEBFFF3);
      case OrderStatusEnum.cancelled:
        return Color(0xffFFEBF2);
      default:
        return grey25;
    }
  }

  String buildImage(OrderStatusEnum orderStatus) {
    switch (orderStatus) {
      case OrderStatusEnum.processing:
        return 'assets/stores/status_processing.png';
      case OrderStatusEnum.confirmed:
        return 'assets/stores/status_confirmed.png';
      case OrderStatusEnum.delivering:
        return 'assets/stores/status_delivering.png';
      case OrderStatusEnum.success:
        return 'assets/stores/status_success.png';
      case OrderStatusEnum.cancelled:
        return 'assets/stores/status_cancelled.png';
      default:
        return 'assets/stores/status_processing.png';
    }
  }

  OrderStatusEnum get(int status) {
    if (status == 1) {
      return OrderStatusEnum.processing;
    } else if (status == 2) {
      return OrderStatusEnum.confirmed;
    } else if (status == 3) {
      return OrderStatusEnum.delivering;
    } else if (status == 4) {
      return OrderStatusEnum.success;
    } else if (status == 5) {
      return OrderStatusEnum.cancelled;
    }
    return OrderStatusEnum.processing;
  }
}
