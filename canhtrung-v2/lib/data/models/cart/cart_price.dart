// ignore_for_file: public_member_api_docs, sort_constructors_first
class CartPrice {
  final num productPrice;
  final num shipPrice;
  final num discountPrice;
  final num totalPrice;
  final bool isFreeShip;
  final bool isVoucherUsed;
  CartPrice({
    required this.productPrice,
    required this.shipPrice,
    required this.discountPrice,
    required this.totalPrice,
    required this.isFreeShip,
    required this.isVoucherUsed,
  });
}
