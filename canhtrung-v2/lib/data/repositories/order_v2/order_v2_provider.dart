import 'package:flutter_ovumb_app_version1/services/models/order_response.dart';

abstract class OrderV2Provider {
  Future<GetOrderResponse> getOrder(int id);

  Future<GetProductsResponse> getDiscountProducts();
}
