import 'package:flutter_ovumb_app_version1/data/models/store/local_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product_category.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/store_slider.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/store/store_provider.dart';

class StoreRepository {
  final _provider = StoreProvider();

  Future<List<ProductCategory>?> getLimitProduct() =>
      _provider.getLimitProduct();

  Future<List<Product>?> getAllProduct({
    required int category,
  }) =>
      _provider.getAllProduct(category);

  Future<List<Product>> getProductByListId({
    required List<LocalProduct> products,
  }) =>
      _provider.getProductByListId(products);

  Future<List<Product>?> searchProducts({
    required String search,
  }) =>
      _provider.searchProducts(search);

  Future<List<StoreSlider>?> getSliders() => _provider.getSliders();
  Stream<List<Product>?> searchStream() => _provider.searchStream;
}
