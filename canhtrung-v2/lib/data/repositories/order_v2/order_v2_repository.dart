import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/order_v2/order_v2_provider.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';
import 'package:flutter_ovumb_app_version1/services/models/order_response.dart';

class OrderV2Repository implements OrderV2Provider {
  OrderV2Repository._();
  static final OrderV2Repository _instance = OrderV2Repository._();
  factory OrderV2Repository() => _instance;
  final _dio = BaseService.instance.dio;

  @override
  Future<GetOrderResponse> getOrder(int id) async {
    final response = await _dio.get('${ApiUrlV2.orderGet}/$id');
    return GetOrderResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: Order.fromMap(response.data['data']),
    );
  }

  @override
  Future<GetProductsResponse> getDiscountProducts() async {
    final response = await _dio.get(ApiUrlV2.sanphamGetDiscount);
    return GetProductsResponse(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<Product>.from(
              response.data['data'].map((e) => Product.fromMap(e)),
            )
          : [],
    );
  }
}
