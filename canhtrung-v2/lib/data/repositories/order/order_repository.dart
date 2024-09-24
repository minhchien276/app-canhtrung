import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order_detail.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order_item.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/order/order_provider.dart';

class OrderRepository {
  final localProvider = OrderProvider();

  Future<Order?> insertOrder({
    required BuildContext context,
    required Order order,
    required List<OrderDetail> orderDetail,
    required Voucher? voucher,
  }) =>
      localProvider.insertOrder(context, order, orderDetail, voucher);

  Future<List<Order>?> getAllOrder() => localProvider.getAllOrder();

  Future<bool> updateUserPayed({
    required BuildContext context,
    required int orderId,
  }) =>
      localProvider.updateUserPayed(context, orderId);

  Future<List<Order>?> getOrderStatus() => localProvider.getOrderStatus();
  Future<List<Order>?> getOrderHistory() => localProvider.getOrderHistory();
  Future<List<OrderItem>?> getOrderItemDetails({required int orderId}) =>
      localProvider.getOrderItemDetails(orderId);

  Future<bool?> cancelOrder({
    required BuildContext context,
    required int orderId,
    required int index,
    required List<Order> orders,
  }) =>
      localProvider.cancelOrder(context, orderId, index, orders);

  Stream<List<Order>?> statusStream() => localProvider.statusStream;
  Stream<List<Order>?> historyStream() => localProvider.historyStream;
}
