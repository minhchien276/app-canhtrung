import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/order/order_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/order/store_order_item.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class StoreOrderStatusScreen extends StatefulWidget {
  static const routeName = 'store-order-status-screen';
  const StoreOrderStatusScreen({super.key});

  @override
  State<StoreOrderStatusScreen> createState() => _StoreOrderStatusScreenState();
}

class _StoreOrderStatusScreenState extends State<StoreOrderStatusScreen> {
  OrderRepository orderRepository = OrderRepository();

  @override
  void initState() {
    orderRepository.getOrderStatus();
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
            text: 'Đơn Hàng Đang Đặt',
            fontWeight: FontWeight.w600,
            size: 18,
            color: grey700,
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
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
        body: StreamBuilder<List<Order>?>(
          stream: orderRepository.statusStream(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.data != null) {
                  if (snapshot.data!.isNotEmpty) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      width: size.width,
                      height: size.height,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return StoreOrderItem(
                            index: index,
                            order: snapshot.data![index],
                            orders: snapshot.data!,
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(
                      child: TitleText(
                        text: 'Không có đơn hàng',
                        fontWeight: FontWeight.w500,
                        size: 16,
                        color: grey700,
                      ),
                    );
                  }
                } else {
                  return const Center(child: Loading());
                }
              default:
                return const Center(child: Loading());
            }
          },
        ),
      ),
    );
  }
}
