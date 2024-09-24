// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_ovumb_app_version1/data/handle/number_handle.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/product/local_product_repository.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/cart_price.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/local_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/cart/cart_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/cart/cart_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/cart/cart_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_cart_list_item.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_cart_payment.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_cart_empty.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/shimmer/product_item_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';

class StoreCartScreen extends StatefulWidget {
  static const routeName = 'store-cart-screen';
  final bool isShowHome;
  const StoreCartScreen({
    Key? key,
    required this.isShowHome,
  }) : super(key: key);

  @override
  State<StoreCartScreen> createState() => _StoreCartScreenState();
}

class _StoreCartScreenState extends State<StoreCartScreen> {
  LocalProductRepository localProductReposity = LocalProductRepository();

  @override
  void initState() {
    context.read<CartBloc>().add(HomeCartEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            text: 'Giỏ hàng',
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
          backgroundColor: whiteColor,
          shadowColor: whiteColor,
          bottomOpacity: 0.1,
          elevation: 0,
        ),
        body: BlocBuilder<CartBloc, CartState>(
          buildWhen: (previousState, currentState) {
            return previousState != currentState;
          },
          builder: (context, state) {
            if (state is HomeCartState) {
              List<Product> products = state.products;
              List<LocalProduct> locals = state.local;
              if (products.isEmpty || locals.isEmpty) {
                return StoreCartEmpty(isShowHome: widget.isShowHome);
              }
              return Container(
                height: size.height,
                width: size.width,
                child: Stack(
                  children: [
                    StoreCartListItem(),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        width: size.width,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          boxShadow: [
                            BoxShadow(
                              color: grey300.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(1, 0),
                            )
                          ],
                        ),
                        child: StreamBuilder<CartPrice>(
                          stream: localProductReposity.cartPrice(),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                              case ConnectionState.active:
                              case ConnectionState.done:
                                if (snapshot.data != null) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TitleText(
                                              text: 'Tổng tiền hàng',
                                              fontWeight: FontWeight.w500,
                                              size: 14,
                                              color: grey500,
                                            ),
                                            const SizedBox(height: 4),
                                            TitleText(
                                              text: NumberHandle().formatPrice(
                                                  snapshot.data!.productPrice,
                                                  '.',
                                                  '₫'),
                                              fontWeight: FontWeight.w700,
                                              size: 16,
                                              color: rose600,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 160,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Color(0xff7F56D9),
                                                  Color(0xff7F56D9),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(38),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xff7F56D9)
                                                      .withOpacity(0.1),
                                                  spreadRadius: 4,
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 3),
                                                )
                                              ]),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (snapshot.data!.productPrice ==
                                                  0) {
                                                showMessageToast(context,
                                                    'Vui lòng chọn tối thiểu 1 sản phẩm');
                                              } else {
                                                Navigator.pushNamed(
                                                  context,
                                                  StoreCartPayment.routeName,
                                                  arguments: {
                                                    "products": products,
                                                    "locals": locals,
                                                    "voucherType":
                                                        state.voucherType,
                                                  },
                                                );
                                              }
                                            },
                                            style: ButtonStyle(
                                              overlayColor:
                                                  const WidgetStatePropertyAll(
                                                      Colors.transparent),
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      Colors.transparent),
                                              shape: WidgetStatePropertyAll(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(38),
                                                ),
                                              ),
                                              elevation:
                                                  WidgetStatePropertyAll(0),
                                              fixedSize: WidgetStatePropertyAll(
                                                  Size(size.width, 50)),
                                              //foregroundColor: WidgetStatePropertyAll(roseTitleText),
                                              textStyle: WidgetStatePropertyAll(
                                                TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: whiteColor,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              'Thanh toán',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              default:
                                return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return getShimmer(ProductItemShimmer());
          },
        ),
      ),
    );
  }
}
