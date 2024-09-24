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

class StoreVoucherSaleItem extends StatefulWidget {
  final Voucher voucher;
  final List<VoucherType> voucherType;
  const StoreVoucherSaleItem({
    Key? key,
    required this.voucher,
    required this.voucherType,
  }) : super(key: key);

  @override
  State<StoreVoucherSaleItem> createState() => _StoreVoucherSaleItemState();
}

class _StoreVoucherSaleItemState extends State<StoreVoucherSaleItem> {
  VoucherRepository voucherRepository = VoucherRepository();
  LocalProductRepository localProductReposity = LocalProductRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          Container(
            height: 100,
            width: size.width,
            child: Row(
              children: [
                Image.asset('assets/stores/voucher_ovumb.png', scale: 3),
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
                                  text: VoucherHandle()
                                      .voucherTitle(widget.voucher),
                                  fontWeight: FontWeight.w500,
                                  size: 14,
                                  color: grey700,
                                  maxLines: 2,
                                ),
                                const SizedBox(height: 4),
                                TitleText(
                                  text: VoucherHandle()
                                      .voucherText(widget.voucher),
                                  fontWeight: FontWeight.w400,
                                  size: 13,
                                  color: grey600,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    TitleText(
                                      text: 'HSD: 31.12.2024',
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
                                  CartPrice cartPrice = snapshot.data!;
                                  Voucher voucher = widget.voucher;
                                  return InkWell(
                                    onTap: () {
                                      if (VoucherHandle().checkVoucher(
                                        snapshot.data!,
                                        widget.voucher,
                                      )) {
                                        voucher.isUsed = !voucher.isUsed;
                                        if (voucher.isUsed == true) {
                                          VoucherHandle().resetVoucher(
                                            voucher,
                                            widget.voucherType,
                                          );
                                        }
                                        localProductReposity.addVoucher(
                                            voucherType: widget.voucherType);
                                        localProductReposity.addCartPrice(
                                          cartPrice: CartPrice(
                                            productPrice:
                                                cartPrice.productPrice,
                                            shipPrice: cartPrice.shipPrice,
                                            discountPrice:
                                                cartPrice.discountPrice,
                                            totalPrice: cartPrice.totalPrice,
                                            isFreeShip: cartPrice.isFreeShip,
                                            isVoucherUsed: voucher.isUsed,
                                          ),
                                          voucherType: widget.voucherType,
                                          isButtonShip: false,
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
                        //
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
