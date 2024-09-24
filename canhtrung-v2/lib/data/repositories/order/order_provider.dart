import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order_detail.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order_item.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_store.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:rxdart/rxdart.dart';

class OrderProvider {
  static final OrderProvider _instance = OrderProvider._internal();
  factory OrderProvider() {
    return _instance;
  }
  OrderProvider._internal();
  final _dio = BaseService.instance.dio;
  final _prefs = SharedPreferencesService();

  final _orderStatusController = ReplaySubject<List<Order>?>(maxSize: 1);
  final _orderHistoryController = ReplaySubject<List<Order>?>(maxSize: 1);

  //status stream
  Stream<List<Order>?> get statusStream => _orderStatusController.stream;
  Sink<List<Order>?> get statusSink => _orderStatusController.sink;

  //history stream
  Stream<List<Order>?> get historyStream => _orderHistoryController.stream;
  Sink<List<Order>?> get historySink => _orderHistoryController.sink;

  //order content
  Future<String> payContent() async {
    final maNguoiDung = await _prefs.id ?? '';
    final user = await LocalRepository().getNguoiDung(maNguoiDung);
    String now = DateTime.now().millisecondsSinceEpoch.toString();
    return user.maNguoiDung.substring(0, 4) +
        now.toString().substring(now.length - 5, now.length - 1);
  }

  //insert order
  Future<Order?> insertOrder(
    BuildContext context,
    Order order,
    List<OrderDetail> orderDetails,
    Voucher? voucher,
  ) async {
    try {
      LoadingStore().show(context: context);
      final maNguoiDung = await _prefs.id;

      List<Map<String, dynamic>> orderJson = [];
      orderDetails.forEach((e) {
        orderJson.add(e.toMap());
      });

      String content = await payContent();

      final data = {
        'maNguoiDung': maNguoiDung,
        'address': order.address,
        'payment_method': order.payment_method,
        'status': order.status,
        'total_price': order.total_price,
        'sale_price': order.sale_price,
        'ship_price': order.ship_price,
        'final_price': order.final_price,
        'name': order.name,
        'phone': order.phone,
        'content': content,
        'voucher_id': voucher != null ? voucher.id : null,
        'type_id': voucher != null ? voucher.idTypeVoucher : null,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'detail': orderJson,
      };

      final response = await _dio.post(
        '$orderInsert',
        data: data,
      );
      LoadingStore().hide();

      if (response.statusCode == 200) {
        if (response.data['data'] != null) {
          return Order.fromJson(jsonEncode(response.data['data']));
        }
        return null;
      }
      return null;
    } catch (e) {
      LoadingStore().hide();
      return null;
    }
  }

  //get all order
  Future<List<Order>?> getAllOrder() async {
    try {
      final maNguoiDung = await _prefs.id;

      final response = await _dio.get('$orderGetAll/$maNguoiDung');
      List<Order> orders = [];
      if (response.statusCode == 200) {
        List? x = response.data['data'];
        if (x != null && x.isNotEmpty) {
          orders = x.map((e) => Order.fromJson(jsonEncode(e))).toList();
          return orders;
        }
        return orders;
      }
      return orders;
    } catch (e) {
      return null;
    }
  }

  //update order user payed
  Future<bool> updateUserPayed(
    BuildContext context,
    int orderId,
  ) async {
    try {
      LoadingStore().show(context: context);

      final response = await _dio.post('$orderUpdate/$orderId');
      LoadingStore().hide();
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      LoadingStore().hide();
      return true;
    }
  }

  //get list order status
  Future<List<Order>?> getOrderStatus() async {
    try {
      statusSink.add(null);

      final maNguoiDung = await _prefs.id;

      final response = await _dio.get('$orderGetStatus/$maNguoiDung');
      List<Order> orders = [];
      if (response.statusCode == 200) {
        List x = response.data['data'];
        orders = x.map((e) => Order.fromJson(jsonEncode(e))).toList();
      }
      statusSink.add(orders);
      return orders;
    } catch (e) {
      return null;
    }
  }

  //get list order history
  Future<List<Order>?> getOrderHistory() async {
    try {
      statusSink.add(null);

      final maNguoiDung = await _prefs.id;

      final response = await _dio.get('$orderGetHistory/$maNguoiDung');
      List<Order> orders = [];
      if (response.statusCode == 200) {
        List x = response.data['data'];
        orders = x.map((e) => Order.fromJson(jsonEncode(e))).toList();
      }
      historySink.add(orders);
      return orders;
    } catch (e) {
      return null;
    }
  }

  //get list order item details
  Future<List<OrderItem>?> getOrderItemDetails(int orderId) async {
    try {
      final response = await _dio.get('$orderGetItemDetail/$orderId');
      List<OrderItem> orders = [];
      if (response.statusCode == 200) {
        List x = response.data['data'];
        orders = x.map((e) => OrderItem.fromJson(jsonEncode(e))).toList();
      }
      return orders;
    } catch (e) {
      return null;
    }
  }

  //cancel order
  Future<bool?> cancelOrder(
    BuildContext context,
    int orderId,
    int index,
    List<Order> orders,
  ) async {
    try {
      LoadingStore().show(context: context);

      final response = await _dio.get('$orderCancel/$orderId');
      LoadingStore().hide();
      if (response.statusCode == 200) {
        if (orders.isNotEmpty) {
          orders.removeAt(index);
          statusSink.add(orders);
        }
        return true;
      }
      return false;
    } catch (e) {
      LoadingStore().hide();
      return null;
    }
  }
}
