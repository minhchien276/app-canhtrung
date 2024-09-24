import 'package:flutter_ovumb_app_version1/data/local_data/repositories/product/local_product_provider.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/cart_price.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/cart_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/local_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';

class LocalProductRepository {
  static final LocalProductRepository _instance =
      LocalProductRepository._internal();
  factory LocalProductRepository() => _instance;
  LocalProductRepository._internal();
  final localProvider = LocalProductProvider();
  Future<LocalProduct?> getProduct({
    required int maSanPham,
  }) =>
      localProvider.getProduct(maSanPham);

  Future<List<LocalProduct>> getAllProduct() => localProvider.getAllProduct();
  Future<bool> addProduct({
    required int maSanPham,
    required int soLuong,
  }) =>
      localProvider.addProduct(maSanPham, soLuong);

  Future<bool> addQuantityProduct({
    required int maSanPham,
    required int soLuong,
  }) =>
      localProvider.addQuantityProduct(maSanPham, soLuong);

  Future<bool> updateProduct({
    required LocalProduct localProduct,
    required int soLuong,
  }) =>
      localProvider.updateProduct(localProduct, soLuong);
  Future<bool> updateProductStatus({
    required int maSanPham,
    required int trangThai,
  }) =>
      localProvider.updateProductStatus(maSanPham, trangThai);

  Future<bool> deleteProduct({required int maSanPham}) =>
      localProvider.deleteProduct(maSanPham);

  Future<bool> deleteListProduct() => localProvider.deleteListProduct();

  void addPrice({
    required List<Product> products,
    num? ship,
    num? discount,
  }) =>
      localProvider.addPrice(products, ship, discount);

  void addCartPrice({
    required CartPrice cartPrice,
    required List<VoucherType> voucherType,
    required bool isButtonShip,
  }) =>
      localProvider.addCartPrice(cartPrice, voucherType, isButtonShip);

  void addCartProduct({
    required List<Product> products,
    required List<LocalProduct> locals,
  }) =>
      localProvider.addCartProduct(products, locals);

  void addVoucher({required List<VoucherType> voucherType}) =>
      localProvider.addVoucher(voucherType);

  Stream<List<LocalProduct>> allProduct() => localProvider.localProductStream;
  Stream<CartProduct> cartProduct() => localProvider.cartStream;
  Stream<CartPrice> cartPrice() => localProvider.priceStream;
  Stream<List<VoucherType>> voucherStream() => localProvider.voucherStream;
}
