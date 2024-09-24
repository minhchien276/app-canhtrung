// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/product/local_product_repository.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/cart_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_image_error.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class StorePaymentItems extends StatefulWidget {
  const StorePaymentItems({
    Key? key,
  }) : super(key: key);

  @override
  State<StorePaymentItems> createState() => _StorePaymentItemsState();
}

class _StorePaymentItemsState extends State<StorePaymentItems> {
  LocalProductRepository localProductRepository = LocalProductRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: 155,
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
                text: 'Giỏ hàng',
                fontWeight: FontWeight.w600,
                size: 14,
                color: grey700,
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: TitleText(
                  text: 'Chỉnh sửa',
                  fontWeight: FontWeight.w600,
                  size: 12,
                  color: violet500,
                ),
              ),
            ],
          ),
          StreamBuilder<CartProduct>(
            stream: localProductRepository.cartProduct(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.data != null) {
                    List<Product> activeProduct = snapshot.data!.productsActice;
                    double widthContiner = size.width - 120 - 100 - 40;
                    int itemCount = widthContiner ~/ 65 + 1;
                    int itemLoaded = itemCount < activeProduct.length
                        ? itemCount
                        : activeProduct.length;
                    return Container(
                      height: 100,
                      width: size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: List.generate(
                                itemLoaded,
                                (index) => Positioned(
                                  left: (itemLoaded - index - 1) * 70,
                                  top: 0,
                                  bottom: 0,
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: rose100,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        width: 3,
                                        color: whiteColor,
                                      ),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: activeProduct[index].image,
                                      errorWidget: (context, url, error) =>
                                          StoreImageError(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            width: 26,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 5,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    color: grey500,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                Container(
                                  height: 5,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    color: grey500,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                Container(
                                  height: 5,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    color: grey500,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
    );
  }
}
