// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/handle/number_handle.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/product/local_product_repository.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/cart_payment_method.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/cart_price.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order_detail.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/address.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/local_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/address/address_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/order/order_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/voucher/voucher_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/shipping/shipping_info.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_cart_qrcode.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_pay_method_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_pay_method_info.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_payment_items.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_payment_total.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/voucher/store_voucher_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_order_success.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/shimmer/address_widget_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/error_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';

class StoreCartPayment extends StatefulWidget {
  static const routeName = 'store-cart-payment';

  final List<Product> products;
  final List<LocalProduct> locals;
  final List<VoucherType> voucherType;
  const StoreCartPayment({
    Key? key,
    required this.products,
    required this.locals,
    required this.voucherType,
  }) : super(key: key);

  @override
  State<StoreCartPayment> createState() => _StoreCartPaymentState();
}

class _StoreCartPaymentState extends State<StoreCartPayment> {
  int _currentMethod = 0;
  List<CartPaymentMethod> cartMethods = [
    CartPaymentMethod(
      image: 'assets/stores/pay_cod.png',
      title: 'Thanh toán',
      subTitle: 'Khi nhận hàng (COD)',
    ),
    CartPaymentMethod(
      image: 'assets/stores/pay_qr.png',
      title: 'Chuyển khoản',
      subTitle: '0770181898888 MB Bank',
    ),
  ];
  LocalProductRepository localProductReposity = LocalProductRepository();
  AddressRepository addressRepository = AddressRepository();
  OrderRepository orderRepository = OrderRepository();
  VoucherRepository voucherRepository = VoucherRepository();
  List<Address> address = [];

  String parseAddress(Address address) {
    return '${address.address_specific}, ${address.wards}, ${address.districts}, ${address.provinces}';
  }

  List<OrderDetail> listOrderDetail() {
    List<OrderDetail> orderDetails = [];
    for (int i = 0; i < widget.products.length; i++) {
      if (widget.locals[i].trangThai == 1) {
        orderDetails.add(
          OrderDetail(
            quantity: widget.locals[i].soLuong,
            id_product_detail: widget.products[i].id,
            price: widget.products[i].sale,
          ),
        );
      }
    }
    return orderDetails;
  }

  int voucherSelect(List<VoucherType> voucherType) {
    int count = 0;
    for (int i = 0; i < widget.voucherType.length; i++) {
      for (int j = 0; j < widget.voucherType[i].vouchers.length; j++) {
        if (widget.voucherType[i].vouchers[j].isUsed == true) {
          count++;
        }
      }
    }
    return count;
  }

  Voucher? voucherUsed(List<VoucherType> voucherType) {
    for (int i = 1; i < widget.voucherType.length; i++) {
      for (int j = 0; j < widget.voucherType[i].vouchers.length; j++) {
        if (widget.voucherType[i].vouchers[j].isUsed == true) {
          return widget.voucherType[i].vouchers[j];
        }
      }
    }
    return null;
  }

  void resetVoucher() {
    for (int i = 0; i < widget.voucherType.length; i++) {
      for (int j = 0; j < widget.voucherType[i].vouchers.length; j++) {
        widget.voucherType[i].vouchers[j].isUsed = false;
      }
    }
    voucherRepository.addVouchers(voucherType: widget.voucherType);
  }

  @override
  void initState() {
    localProductReposity.addPrice(
      products: widget.products,
      ship: widget.voucherType[0].vouchers[0].maxPrice,
      discount: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    resetVoucher();
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
            text: 'Thanh Toán',
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
          actions: [],
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: size.height,
              width: size.width,
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    height: 110,
                    width: size.width,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TitleText(
                              text: 'Địa chỉ',
                              fontWeight: FontWeight.w600,
                              size: 14,
                              color: grey700,
                            ),
                            InkWell(
                              onTap: () => Navigator.pushNamed(
                                  context, ShippingInfo.routeName,
                                  arguments: address),
                              child: TitleText(
                                text: 'Thay đổi',
                                fontWeight: FontWeight.w600,
                                size: 12,
                                color: violet500,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: violet200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'assets/stores/location.png',
                                scale: 3,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: StreamBuilder<List<Address>>(
                                stream: addressRepository.allAddress(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                    case ConnectionState.active:
                                    case ConnectionState.done:
                                      if (snapshot.data != null) {
                                        if (snapshot.data!.isNotEmpty) {
                                          address = snapshot.data!;
                                          return TitleText(
                                            text: parseAddress(
                                                snapshot.data!.first),
                                            fontWeight: FontWeight.w500,
                                            size: 12,
                                            color: grey500,
                                          );
                                        } else {
                                          address = [];
                                          return InkWell(
                                            onTap: () => Navigator.pushNamed(
                                              context,
                                              ShippingInfo.routeName,
                                              arguments: snapshot.data,
                                            ),
                                            child: Container(
                                              child: Center(
                                                child: TitleText(
                                                  text: 'Thêm địa chỉ ',
                                                  fontWeight: FontWeight.w600,
                                                  size: 14,
                                                  color: grey700,
                                                  textDecoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        return getShimmer(
                                            AddressWidgetShimmer());
                                      }
                                    default:
                                      return getShimmer(AddressWidgetShimmer());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 170,
                    width: size.width,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleText(
                          text: 'Phương thức thanh toán',
                          fontWeight: FontWeight.w600,
                          size: 14,
                          color: grey700,
                        ),
                        Row(
                          children: List.generate(
                            cartMethods.length,
                            (index) => InkWell(
                              onTap: () {
                                _currentMethod = index;
                                setState(() {});
                              },
                              child: StorePayMethodButton(
                                isSelected: _currentMethod == index,
                                image: cartMethods[index].image,
                              ),
                            ),
                          ),
                        ),
                        StorePayMethodInfo(
                          title: cartMethods[_currentMethod].title,
                          subTitle: cartMethods[_currentMethod].subTitle,
                          image: cartMethods[_currentMethod].image,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  StorePaymentItems(),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      StoreVoucherScreen.routeName,
                    ),
                    child: Container(
                      height: 70,
                      width: size.width,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: rose100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Image.asset(
                                  'assets/stores/voucher.png',
                                  scale: 3,
                                ),
                              ),
                              const SizedBox(width: 10),
                              TitleText(
                                text: 'Chọn Voucher',
                                fontWeight: FontWeight.w500,
                                size: 14,
                                color: grey700,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              StreamBuilder<List<VoucherType>>(
                                initialData: widget.voucherType,
                                stream: localProductReposity.voucherStream(),
                                builder: (context, snapshot) {
                                  int count = snapshot.data != null
                                      ? voucherSelect(snapshot.data!)
                                      : 0;
                                  return TitleText(
                                    text: count.toString() + ' voucher đã chọn',
                                    fontWeight: FontWeight.w500,
                                    size: 12,
                                    color: grey400,
                                  );
                                },
                              ),
                              const SizedBox(width: 4),
                              Image.asset(
                                'assets/icons/next_button.png',
                                scale: 5,
                                color: grey400,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/stores/note.png',
                          scale: 3,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TitleText(
                            text:
                                'Đơn hàng sẽ được xác nhận từ 1-2 ngày và vận chuyển trong 2-4 ngày sau khi xác nhận',
                            fontWeight: FontWeight.w500,
                            size: 12,
                            color: grey400,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<CartPrice>(
                    stream: localProductReposity.cartPrice(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.data != null) {
                            return StorePaymentTotal(
                              cartPrice: snapshot.data!,
                            );
                          } else {
                            return const SizedBox();
                          }
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
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
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TitleText(
                                        text: 'Thành tiền',
                                        fontWeight: FontWeight.w500,
                                        size: 14,
                                        color: grey500,
                                      ),
                                      const SizedBox(height: 4),
                                      TitleText(
                                        text: NumberHandle().formatPrice(
                                            snapshot.data!.totalPrice,
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
                              ),
                              Container(
                                width: 160,
                                color: whiteColor,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 24),
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
                                      borderRadius: BorderRadius.circular(38),
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
                                    onPressed: () async {
                                      if (address.isNotEmpty) {
                                        Order? order =
                                            await orderRepository.insertOrder(
                                          context: context,
                                          order: Order(
                                            id: 0,
                                            address:
                                                parseAddress(address.first),
                                            payment_method:
                                                _currentMethod == 0 ? 1 : 0,
                                            status: 1,
                                            total_price:
                                                snapshot.data!.productPrice,
                                            ship_price:
                                                !snapshot.data!.isFreeShip
                                                    ? snapshot.data!.shipPrice
                                                    : 0,
                                            sale_price:
                                                snapshot.data!.discountPrice,
                                            final_price:
                                                snapshot.data!.totalPrice,
                                            name: address.first.username,
                                            phone: address.first.phone,
                                            content: '',
                                            created_at: DateTime.now(),
                                          ),
                                          orderDetail: listOrderDetail(),
                                          voucher:
                                              voucherUsed(widget.voucherType),
                                        );
                                        if (order != null) {
                                          showStoreSuccessToast(
                                              context, 'Đặt hàng thành công');
                                          await localProductReposity
                                              .deleteListProduct();
                                          if (_currentMethod == 0) {
                                            Future.delayed(
                                                const Duration(seconds: 1), () {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                StoreCartQRcode.routeName,
                                                arguments: order,
                                                (route) => false,
                                              );
                                            });
                                          } else {
                                            Future.delayed(
                                                const Duration(seconds: 1), () {
                                              Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                StoreOrderSuccess.routeName,
                                                (route) => false,
                                              );
                                            });
                                          }
                                        } else {
                                          showErrorDialog(context,
                                              'Đặt hàng không thành công');
                                        }
                                      } else {
                                        showMessageToast(context,
                                            'Vui lòng nhập địa chỉ giao hàng');
                                      }
                                    },
                                    style: ButtonStyle(
                                      overlayColor:
                                          const WidgetStatePropertyAll(
                                              Colors.transparent),
                                      backgroundColor: WidgetStatePropertyAll(
                                          Colors.transparent),
                                      shape: WidgetStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(38),
                                        ),
                                      ),
                                      elevation: WidgetStatePropertyAll(0),
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
      ),
    );
  }
}
