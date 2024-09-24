// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_ovumb_app_version1/data/enum/order_status_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/order/store_order_detail.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class StoreOrderItem extends StatefulWidget {
  final int index;
  final Order order;
  final List<Order> orders;
  const StoreOrderItem({
    Key? key,
    required this.index,
    required this.order,
    required this.orders,
  }) : super(key: key);

  @override
  State<StoreOrderItem> createState() => _StoreOrderItemState();
}

class _StoreOrderItemState extends State<StoreOrderItem> {
  OrderStatusEnum get() {
    return OrderSatus().get(widget.order.status);
  }

  //format date time
  String formatDateTime(DateTime dateTime) {
    DateFormat formatter =
        DateFormat('yyyy-MM-dd hh:mm'); // Định dạng mong muốn
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 135,
      width: size.width,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: whiteColor,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    TitleText(
                      text: 'Đơn hàng số: ${widget.order.content}',
                      fontWeight: FontWeight.w500,
                      size: 14,
                      color: grey600,
                    ),
                    const SizedBox(height: 4),
                    TitleText(
                      text: formatDateTime(widget.order.created_at),
                      fontWeight: FontWeight.w500,
                      size: 14,
                      color: grey400,
                    ),
                  ],
                ),
              ),
              Container(
                width: 80,
                height: 50,
                child: Image.asset(
                  'assets/logo/logo_store.png',
                  scale: 10,
                ),
              )
            ],
          ),
          Divider(
            color: grey300,
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: OrderSatus().buildBgColor(get()),
                ),
                child: Center(
                  child: TitleText(
                    text: OrderSatus().buildText(get()),
                    fontWeight: FontWeight.w500,
                    size: 12,
                    color: OrderSatus().buildTextColor(get()),
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  StoreOrderDetailScreen.routeName,
                  arguments: {
                    "index": widget.index,
                    "order": widget.order,
                    "orders": widget.orders,
                  },
                ),
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: rose400,
                  ),
                  child: Center(
                    child: TitleText(
                      text: 'Xem chi tiết',
                      fontWeight: FontWeight.w500,
                      size: 12,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
