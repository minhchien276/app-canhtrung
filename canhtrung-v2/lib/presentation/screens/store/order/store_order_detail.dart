// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/enum/order_status_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/cart_payment_method.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/cart_price.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order_item.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/order/order_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_pay_method_info.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_payment_total.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/order/store_order_address.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/order/store_order_product.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_order_status_widget.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/remove_order_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';

class StoreOrderDetailScreen extends StatefulWidget {
  static const routeName = 'store-order-detail-screen';
  final int index;
  final Order order;
  final List<Order> orders;
  const StoreOrderDetailScreen({
    Key? key,
    required this.index,
    required this.order,
    required this.orders,
  }) : super(key: key);

  @override
  State<StoreOrderDetailScreen> createState() => _StoreOrderDetailScreenState();
}

class _StoreOrderDetailScreenState extends State<StoreOrderDetailScreen> {
  OrderRepository orderRepository = OrderRepository();
  List<CartPaymentMethod> cartMethods = [
    CartPaymentMethod(
      image: 'assets/stores/pay_qr.png',
      title: 'Chuyển khoản',
      subTitle: 'Ngân hàng MB Bank',
    ),
    CartPaymentMethod(
      image: 'assets/stores/pay_cod.png',
      title: 'Thanh toán',
      subTitle: 'Khi nhận hàng (COD)',
    ),
  ];

  @override
  void initState() {
    orderRepository.getOrderItemDetails(orderId: widget.order.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
      child: Scaffold(
        backgroundColor: Color(0xffFAFAFA),
        appBar: AppBar(
          title: TitleText(
            text: 'Thông tin đơn hàng',
            fontWeight: FontWeight.w600,
            size: 18,
            color: grey700,
          ),
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/icons/back_button.png',
              scale: 3.5,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffFAFAFA),
          shadowColor: whiteColor,
          bottomOpacity: 0.1,
          elevation: 0,
          actions: [],
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          height: size.height,
          width: size.width,
          child: ListView(
            children: [
              StoreOrderAddress(
                name: widget.order.name,
                phoneNumber: widget.order.phone,
                address: widget.order.address,
              ),
              const SizedBox(height: 20),
              Container(
                height: 70,
                width: size.width,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: StorePayMethodInfo(
                  title: cartMethods[widget.order.payment_method].title,
                  subTitle: cartMethods[widget.order.payment_method].subTitle,
                  image: cartMethods[widget.order.payment_method].image,
                ),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<OrderItem>?>(
                future: orderRepository.getOrderItemDetails(
                    orderId: widget.order.id),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.data != null) {
                        List<OrderItem> orderItems = snapshot.data!;
                        return Container(
                          height: orderItems.length * 96 + 20,
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 20),
                          decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orderItems.length,
                            itemBuilder: (context, index) {
                              OrderItem orderItem = orderItems[index];
                              return Column(
                                children: [
                                  StoreOrderProduct(
                                    product: Product(
                                      id: 0,
                                      image: orderItem.image,
                                      name: orderItem.name,
                                      price: orderItem.sale,
                                      description: orderItem.type,
                                      content: '',
                                      guide: '',
                                      product_id: 1,
                                      sale: orderItem.sale,
                                      type: '',
                                    ),
                                    quanyity: orderItem.quantity,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14),
                                    child: Divider(
                                      color: grey300,
                                      height: 30,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    default:
                      return const SizedBox();
                  }
                },
              ),
              const SizedBox(height: 20),
              StoreOrderStatusWidget(
                orderStatus: OrderSatus().get(widget.order.status),
              ),
              const SizedBox(height: 20),
              StorePaymentTotal(
                cartPrice: CartPrice(
                  productPrice: widget.order.total_price,
                  shipPrice: widget.order.ship_price,
                  discountPrice: widget.order.sale_price,
                  totalPrice: widget.order.final_price,
                  isFreeShip: widget.order.ship_price == 0 ? true : false,
                  isVoucherUsed: widget.order.sale_price == 0 ? false : true,
                ),
              ),
              const SizedBox(height: 20),
              if (widget.order.status < 3) ...[
                InkWell(
                  onTap: () async {
                    bool? check =
                        await removeOrderDialog(context, widget.order.content);
                    if (check == true) {
                      bool? del = await orderRepository.cancelOrder(
                        context: context,
                        orderId: widget.order.id,
                        index: widget.index,
                        orders: widget.orders,
                      );
                      if (del == true) {
                        showStoreSuccessToast(
                          context,
                          'Đơn hàng đã được huỷ thành công',
                        );
                        Navigator.pop(context);
                      } else {
                        showMessageToast(
                            context, 'Đơn hàng huỷ không thành công');
                      }
                    }
                  },
                  child: Container(
                    height: 45,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: rose400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TitleText(
                        text: 'Huỷ đơn hàng',
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
