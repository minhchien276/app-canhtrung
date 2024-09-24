import 'package:flutter_ovumb_app_version1/data/models/cart/order.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';

class GetOrderResponse extends ApiResponse<Order> {
  GetOrderResponse({required super.status, required super.data});
}

class GetProductsResponse extends ApiResponse<List<Product>> {
  GetProductsResponse({required super.status, required super.data});
}
