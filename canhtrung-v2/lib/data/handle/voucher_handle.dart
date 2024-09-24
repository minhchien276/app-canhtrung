import 'package:flutter_ovumb_app_version1/data/models/cart/cart_price.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';

class VoucherHandle {
  String formatVoucherPrice(num price) {
    double prefix = price / 1000;
    return 'đ${prefix.round()}K';
  }

  String shipTitle() {
    return 'Miễn phí vận chuyển';
  }

  String shipText() {
    return 'Đơn tối thiểu 1 triệu';
  }

  String voucherTitle(Voucher voucher) {
    String value = formatVoucherPrice(voucher.maxPrice);
    return 'Giảm ${voucher.discount}% Giảm tối đa ${value}';
  }

  String voucherText(Voucher voucher) {
    String value = formatVoucherPrice(voucher.minPrice);
    return 'Đơn tối thiểu ${value}';
  }

  bool checkShipFee(num total) {
    return total >= 1000000;
  }

  bool checkVoucher(CartPrice cartPrice, Voucher voucher) {
    return cartPrice.productPrice >= voucher.minPrice;
  }

  void resetVoucher(
    Voucher voucherActive,
    List<VoucherType> voucherType,
  ) {
    for (int i = 1; i < voucherType.length; i++) {
      for (int j = 0; j < voucherType[i].vouchers.length; j++) {
        if (voucherActive.id != voucherType[i].vouchers[j].id) {
          voucherType[i].vouchers[j].isUsed = false;
        }
      }
    }
  }
}
