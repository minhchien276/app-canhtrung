import 'dart:async';
import 'dart:convert';

import 'package:flutter_ovumb_app_version1/data/local_data/database/constant.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/database/database.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/cart_price.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/cart_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/local_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';
import 'package:rxdart/rxdart.dart';

class LocalProductProvider {
  static final LocalProductProvider _instance =
      LocalProductProvider._internal();
  factory LocalProductProvider() {
    return _instance;
  }
  LocalProductProvider._internal();
  final dbProvider = DatabaseProvider.db;

  final StreamController<List<LocalProduct>> _stream =
      StreamController.broadcast();

  final _cartStreamController = ReplaySubject<CartProduct>(maxSize: 1);
  final _priceStreamController = ReplaySubject<CartPrice>(maxSize: 1);
  final _voucherStreamController = ReplaySubject<List<VoucherType>>(maxSize: 1);

  //cart product stream
  Stream<CartProduct> get cartStream => _cartStreamController.stream;
  Sink<CartProduct> get cartSink => _cartStreamController.sink;

  //cart price stream
  Stream<CartPrice> get priceStream => _priceStreamController.stream;
  Sink<CartPrice> get priceSink => _priceStreamController.sink;

  // product cho stream
  Stream<List<LocalProduct>> get localProductStream => _stream.stream;
  Sink<List<LocalProduct>> get localProductSink => _stream.sink;

  // voucher cho stream
  Stream<List<VoucherType>> get voucherStream =>
      _voucherStreamController.stream;
  Sink<List<VoucherType>> get voucherSink => _voucherStreamController.sink;

  //get product
  Future<LocalProduct?> getProduct(int maSanPham) async {
    try {
      final db = await dbProvider.database;
      final product = await db.query(
        tableProduct,
        where: 'maSanPham = ?',
        whereArgs: [maSanPham],
      );
      if (product.first.isNotEmpty) {
        return LocalProduct.fromJson(jsonEncode(product.first));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  //get all product
  Future<List<LocalProduct>> getAllProduct() async {
    try {
      final db = await dbProvider.database;
      final product = await db.query(
        tableProduct,
      );
      List<LocalProduct> products = [];
      if (product.isNotEmpty) {
        product.forEach((element) {
          products.add(LocalProduct.fromJson(jsonEncode(element)));
        });
        localProductSink.add(products);
      } else {
        localProductSink.add([]);
      }
      return products;
    } catch (e) {
      throw 'Lỗi kết nối';
    }
  }

  //add product to cart
  Future<bool> addProduct(int maSanPham, int soLuong) async {
    try {
      final db = await dbProvider.database;
      LocalProduct? product = await getProduct(maSanPham);
      if (product != null) {
        await updateProduct(product, soLuong);
      } else {
        await db.insert(
          tableProduct,
          {
            'maSanPham': maSanPham,
            'soLuong': soLuong,
            'trangThai': 1,
          },
        );
      }
      await getAllProduct();
      return true;
    } catch (e) {
      return false;
    }
  }

  //add product to cart
  Future<bool> addQuantityProduct(int maSanPham, int soLuong) async {
    try {
      final db = await dbProvider.database;
      LocalProduct? product = await getProduct(maSanPham);
      if (product != null) {
        await updateQuantityProduct(product, soLuong);
      } else {
        await db.insert(
          tableProduct,
          {
            'maSanPham': maSanPham,
            'soLuong': soLuong,
            'trangThai': 1,
          },
        );
      }
      await getAllProduct();
      return true;
    } catch (e) {
      return false;
    }
  }

  //update product to cart
  Future<bool> updateProduct(LocalProduct localProduct, int soLuong) async {
    try {
      final db = await dbProvider.database;
      await db.update(
        tableProduct,
        {
          'soLuong': soLuong,
        },
        where: 'maSanPham = ?',
        whereArgs: [localProduct.maSanPham],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //update quantity product to cart
  Future<bool> updateQuantityProduct(
      LocalProduct localProduct, int soLuong) async {
    try {
      final db = await dbProvider.database;
      await db.update(
        tableProduct,
        {
          'soLuong': localProduct.soLuong + soLuong,
        },
        where: 'maSanPham = ?',
        whereArgs: [localProduct.maSanPham],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //update product status to cart
  Future<bool> updateProductStatus(int maSanPham, int trangThai) async {
    try {
      final db = await dbProvider.database;
      await db.update(
        tableProduct,
        {
          'trangThai': trangThai,
        },
        where: 'maSanPham = ?',
        whereArgs: [maSanPham],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  //delete product to cart
  Future<bool> deleteProduct(int maSanPham) async {
    try {
      final db = await dbProvider.database;
      await db.delete(
        tableProduct,
        where: 'maSanPham = ?',
        whereArgs: [maSanPham],
      );
      await getAllProduct();
      return true;
    } catch (e) {
      return false;
    }
  }

  //delete product from cart
  Future<bool> deleteListProduct() async {
    try {
      List<LocalProduct> locals = await getAllProduct();
      for (LocalProduct local in locals) {
        if (local.trangThai == 1) {
          await deleteProduct(local.maSanPham);
        }
      }
      await getAllProduct();
      return true;
    } catch (e) {
      return false;
    }
  }

  //add price
  Future<void> addPrice(
    List<Product> products,
    num? ship,
    num? discount,
  ) async {
    num res = 0;
    List<LocalProduct> locals = await getAllProduct();
    for (int i = 0; i < products.length; i++) {
      if (locals[i].trangThai == 1) {
        res += products[i].sale * locals[i].soLuong;
      }
    }
    num shipFee = ship ?? 0;
    num discountFee = (discount ?? 0) / 100 * res;

    priceSink.add(
      CartPrice(
        productPrice: res,
        shipPrice: shipFee,
        discountPrice: discountFee,
        totalPrice: res + shipFee - discountFee,
        isFreeShip: false,
        isVoucherUsed: false,
      ),
    );
  }

  //add price
  Future<void> addCartPrice(
    CartPrice cartPrice,
    List<VoucherType> voucherType,
    bool isButtonShip,
  ) async {
    num total = cartPrice.totalPrice;
    num finalDiscount = cartPrice.discountPrice;

    //if ship free
    if (isButtonShip) {
      if (voucherType.first.vouchers.first.isUsed == true) {
        total -= cartPrice.shipPrice;
      } else {
        total += cartPrice.shipPrice;
      }
    } else {
      Voucher? voucherActive;
      for (int i = 1; i < voucherType.length; i++) {
        for (int j = 0; j < voucherType[i].vouchers.length; j++) {
          if (voucherType[i].vouchers[j].isUsed) {
            voucherActive = voucherType[i].vouchers[j];
            break;
          }
        }
      }

      if (voucherActive != null) {
        num discount = voucherActive.discount * cartPrice.productPrice / 100;
        finalDiscount = discount < voucherActive.maxPrice
            ? discount
            : voucherActive.maxPrice;
        total += cartPrice.discountPrice;
        total -= finalDiscount;
      } else {
        total += cartPrice.discountPrice;
      }
    }

    priceSink.add(
      CartPrice(
        productPrice: cartPrice.productPrice,
        shipPrice: cartPrice.shipPrice,
        discountPrice: finalDiscount,
        totalPrice: total,
        isFreeShip: cartPrice.isFreeShip,
        isVoucherUsed: cartPrice.isVoucherUsed,
      ),
    );
  }

  void addVoucher(List<VoucherType> voucherType) {
    voucherSink.add(voucherType);
  }

  void addCartProduct(List<Product> products, List<LocalProduct> locals) {
    try {
      List<Product> actives = [];
      for (int i = 0; i < locals.length; i++) {
        if (locals[i].trangThai == 1) {
          actives.add(products[i]);
        }
      }
      final cart = CartProduct(
        products: products,
        locals: locals,
        productsActice: actives,
      );
      cartSink.add(cart);
    } catch (e) {
      // Xử lý khi có lỗi
      print('Error in addCartProduct: $e');
    }
  }
}
