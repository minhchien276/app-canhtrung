import 'dart:convert';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/local_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product_category.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/store_slider.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:rxdart/rxdart.dart';

class StoreProvider {
  final _dio = BaseService.instance.dio;
  static final StoreProvider _instance = StoreProvider._internal();
  factory StoreProvider() {
    return _instance;
  }
  StoreProvider._internal();

  final _searchController = ReplaySubject<List<Product>?>(maxSize: 1);
  final _prefs = SharedPreferencesService();

  //status stream
  Stream<List<Product>?> get searchStream => _searchController.stream;
  Sink<List<Product>?> get searchSink => _searchController.sink;

  //get all sp
  Future<List<Product>> getProductByListId(
      List<LocalProduct> localProduct) async {
    try {
      List<int> listId =
          localProduct.map((product) => product.maSanPham).toList();

      final response = await _dio.get(
        '$sanphamGetAllByListId',
        data: {'data': listId},
      );
      List<Product> products = [];
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          List data = response.data['data'];
          products = data.map((e) => Product.fromJson(jsonEncode(e))).toList();
        }
      }
      return products;
    } catch (e) {
      throw e;
    }
  }

  //get all sp
  Future<List<Product>?> getAllProduct(int category) async {
    try {
      searchSink.add(null);

      final response = await _dio.get('$sanphamGetAll/$category');
      List<Product> products = [];
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          List data = response.data['data'];
          products = data.map((e) => Product.fromJson(jsonEncode(e))).toList();
        }
      }
      searchSink.add(products);
      return products;
    } catch (e) {
      return null;
    }
  }

  //get limit sp
  Future<List<ProductCategory>?> getLimitProduct() async {
    try {
      final maNguoiDung = await _prefs.id ?? '';
      final user = await LocalRepository().getNguoiDung(maNguoiDung);

      final response = await _dio.get('$sanphamGetLimit/${user.phase}');
      List<ProductCategory> products = [];
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          List data = response.data['data'];
          products =
              data.map((e) => ProductCategory.fromJson(jsonEncode(e))).toList();
        }
      }
      return products;
    } catch (e) {
      return null;
    }
  }

  //get slider
  Future<List<StoreSlider>?> getSliders() async {
    try {
      final response = await _dio.get('$sildeGet');
      List<StoreSlider> sliders = [];
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          List data = response.data['data'];
          sliders =
              data.map((e) => StoreSlider.fromJson(jsonEncode(e))).toList();
        }
      }
      return sliders;
    } catch (e) {
      return null;
    }
  }

  //search products
  Future<List<Product>?> searchProducts(String search) async {
    try {
      searchSink.add(null);

      final maNguoiDung = await _prefs.id ?? '';
      final user = await LocalRepository().getNguoiDung(maNguoiDung);

      final response = await _dio.get(
        '$sanphamSearch/${user.phase}',
        data: {
          'search': search,
        },
      );
      List<Product> products = [];
      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          List data = response.data['data'];
          products = data.map((e) => Product.fromJson(jsonEncode(e))).toList();
        }
      }
      searchSink.add(products);
      return products;
    } catch (e) {
      return null;
    }
  }
}
