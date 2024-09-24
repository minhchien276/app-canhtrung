// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/handle/voucher_handle.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/product/local_product_repository.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/cart_price.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/voucher/voucher_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';

class StoreVoucherShipItem extends StatefulWidget {
  final Voucher voucher;
  final List<VoucherType> voucherType;
  const StoreVoucherShipItem({
    Key? key,
    required this.voucher,
    required this.voucherType,
  }) : super(key: key);

  @override
  State<StoreVoucherShipItem> createState() => _StoreVoucherShipItemState();
}

class _StoreVoucherShipItemState extends State<StoreVoucherShipItem> {
  VoucherRepository voucherRepository = VoucherRepository();
  LocalProductRepository localProductReposity = LocalProductRepository();

  @override
  void initState() {
    super.initState();
  }

  String buildDate() {
    DateTime date = DateTime.parse(widget.voucher.expired);
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: 100,
          width: size.width,
          child: Row(
            children: [
              Image.asset('assets/stores/voucher_ship.png', scale: 3),
              Expanded(
                child: Container(
                  height: 100,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(
                                text: VoucherHandle().shipTitle(),
                                fontWeight: FontWeight.w500,
                                size: 14,
                                color: grey700,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              TitleText(
                                text: VoucherHandle().shipText(),
                                fontWeight: FontWeight.w400,
                                size: 13,
                                color: grey600,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  TitleText(
                                    text: 'HSD: ' + buildDate(),
                                    fontWeight: FontWeight.w400,
                                    size: 11,
                                    color: grey500,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      StreamBuilder<CartPrice>(
                        stream: localProductReposity.cartPrice(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.active:
                            case ConnectionState.done:
                              if (snapshot.data != null) {
                                return InkWell(
                                  onTap: () {
                                    CartPrice cartPrice = snapshot.data!;
                                    Voucher voucher = widget.voucher;
                                    if (VoucherHandle().checkShipFee(
                                        snapshot.data!.productPrice)) {
                                      voucher.isUsed = !voucher.isUsed;
                                      localProductReposity.addVoucher(
                                          voucherType: widget.voucherType);
                                      localProductReposity.addCartPrice(
                                        cartPrice: CartPrice(
                                          productPrice: cartPrice.productPrice,
                                          shipPrice: cartPrice.shipPrice,
                                          discountPrice:
                                              cartPrice.discountPrice,
                                          totalPrice: cartPrice.totalPrice,
                                          isFreeShip: voucher.isUsed,
                                          isVoucherUsed:
                                              cartPrice.isVoucherUsed,
                                        ),
                                        voucherType: widget.voucherType,
                                        isButtonShip: true,
                                      );
                                    } else {
                                      showMessageToast(context,
                                          'Không đủ điều kiện để dùng Voucher',
                                          seconds: 2);
                                    }
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 50,
                                    child: Image.asset(
                                      widget.voucher.isUsed
                                          ? 'assets/stores/check.png'
                                          : 'assets/stores/un_check.png',
                                      scale: 3,
                                    ),
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
