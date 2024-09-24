// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ovumb_app_version1/data/handle/number_handle.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/order/order_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_order_success.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class StoreCartQRcode extends StatefulWidget {
  static const routeName = 'store-cart-qrcode';
  final Order order;
  const StoreCartQRcode({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<StoreCartQRcode> createState() => _StoreCartQRcodeState();
}

class _StoreCartQRcodeState extends State<StoreCartQRcode> {
  String content = '';
  OrderRepository orderRepository = OrderRepository();
  void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: '0770181898888'));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.black,
      ),
    );
  }

  void initState() {
    super.initState();
  }

  String urlPayment(Order order) {
    return 'https://api.vietqr.io/image/970422-0770181898888-05mbxkj.jpg?accountName=TRAN%20MINH%20HUNG&amount=${order.final_price}&addInfo=${order.content}';
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
            text: 'Chuyển khoản',
            fontWeight: FontWeight.w600,
            size: 18,
            color: grey700,
          ),
          centerTitle: true,
          backgroundColor: Color(0xffFAFAFA),
          shadowColor: whiteColor,
          bottomOpacity: 0.1,
          elevation: 0,
          actions: [],
        ),
        body: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleText(
                    text: 'QR Code',
                    fontWeight: FontWeight.w700,
                    size: 24,
                    color: grey600,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: TitleText(
                      text: 'Quét mã bên dưới để tiến hàng thanh toán',
                      fontWeight: FontWeight.w500,
                      size: 16,
                      color: grey400,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 380,
                    width: 300,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: grey300.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Image.asset(
                          'assets/stores/test_logo_mb.png',
                          scale: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 220,
                                height: 220,
                                child: CachedNetworkImage(
                                  imageUrl: urlPayment(widget.order),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/stores/test_qr.png'),
                                ),
                              ),
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 3, color: whiteColor),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Image.asset(
                                  'assets/stores/logo_mb.png',
                                  scale: 3,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        TitleText(
                          text: 'TRAN MINH HUNG',
                          fontWeight: FontWeight.w600,
                          size: 16,
                          color: grey600,
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            copyToClipboard(
                                context, 'Số tài khoản đã được sao chép');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TitleText(
                                text: '0770181898888',
                                fontWeight: FontWeight.w600,
                                size: 16,
                                color: grey400,
                              ),
                              const SizedBox(width: 4),
                              Image.asset(
                                'assets/stores/copy.png',
                                scale: 3,
                                color: grey400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      TitleText(
                        text: 'Nội dung chuyển khoản:',
                        fontWeight: FontWeight.w600,
                        size: 16,
                        color: grey600,
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          copyToClipboard(context,
                              'Nội dung chuyển khoản đã được sao chép');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TitleText(
                              text: widget.order.content,
                              fontWeight: FontWeight.w600,
                              size: 16,
                              color: grey400,
                            ),
                            const SizedBox(width: 4),
                            Image.asset(
                              'assets/stores/copy.png',
                              scale: 3,
                              color: grey400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TitleText(
                      text:
                          '*Lưu ý: Nhập đúng nội dung trên để đơn hàng được xử lý nhanh nhất',
                      fontWeight: FontWeight.w400,
                      size: 12,
                      color: grey500,
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                  widget.order.final_price, '.', '₫'),
                              fontWeight: FontWeight.w700,
                              size: 16,
                              color: rose600,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 160,
                      color: whiteColor,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
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
                                color: Color(0xff7F56D9).withOpacity(0.1),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              )
                            ]),
                        child: ElevatedButton(
                          onPressed: () async {
                            await orderRepository.updateUserPayed(
                              context: context,
                              orderId: widget.order.id,
                            );
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              StoreOrderSuccess.routeName,
                              (route) => false,
                            );
                          },
                          style: ButtonStyle(
                            overlayColor: const WidgetStatePropertyAll(
                                Colors.transparent),
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.transparent),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(38),
                              ),
                            ),
                            elevation: WidgetStatePropertyAll(0),
                            fixedSize:
                                WidgetStatePropertyAll(Size(size.width, 50)),
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
                            'Đã thanh toán',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
