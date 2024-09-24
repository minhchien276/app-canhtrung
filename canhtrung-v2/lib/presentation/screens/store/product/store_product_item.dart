// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/handle/number_handle.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/product/store_product_item_detail.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_image_error.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreProductItem extends StatelessWidget {
  final Product product;
  final String type;
  const StoreProductItem({
    Key? key,
    required this.product,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int discount(Product product) {
      return (((product.price - product.sale) / product.price) * 100).round();
    }

    return InkWell(
      onTap: () async {
        context.pushNamed(
          StoreProductItemDetail.routeName,
          arguments: {
            'product': product,
            'type': type,
            'isSlider': true,
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 24.w, bottom: 10.h),
        width: 170.w,
        child: Column(
          children: [
            SizedBox(
              height: 180.h,
              width: 170.w,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurStyle: BlurStyle.normal,
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 16,
                          offset: Offset(0, 7), // changes position of shadow
                        ),
                      ],
                      color: rose100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    height: 180.h,
                    width: 170.w,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        errorWidget: (context, url, error) => StoreImageError(),
                      ),
                    ),
                  ),
                  if (discount(product) != 0) ...[
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        height: 30.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          color: Color(0xff734CC9),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: BuildText(
                            text: '${discount(product)}% OFF',
                            style: 11.text600,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      blurStyle: BlurStyle.normal,
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 14,
                      offset: Offset(0, 7), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              BuildText(
                                text: product.name,
                                style: 14.text500,
                                maxLines: 1,
                                color: grey700,
                              ),
                              if (discount(product) != 0) ...[
                                BuildText(
                                  text: NumberHandle()
                                      .formatPrice(product.price, '.', '₫'),
                                  style: 12.text600,
                                  maxLines: 1,
                                  color: Color(0xff98A2B3),
                                  textDecoration: TextDecoration.lineThrough,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Container(
                          height: 40.h,
                          width: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Image.asset(IconApp.cartPlus, scale: 3),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: BuildText(
                              text: NumberHandle()
                                  .formatPrice(product.sale, '.', '₫'),
                              style: 15.text600,
                              maxLines: 1,
                              color: discount(product) != 0
                                  ? rose500
                                  : Color(0xff344054),
                            ),
                          ),
                          2.horizontalSpace,
                          BuildText(
                            text: NumberHandle().formatSold(product.sold) +
                                ' đã bán',
                            style: 10.text600,
                            color: grey400,
                            maxLines: 1,
                          ),
                        ],
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
