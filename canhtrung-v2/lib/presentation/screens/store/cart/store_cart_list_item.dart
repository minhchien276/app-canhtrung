// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/handle/number_handle.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/product/local_product_repository.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/cart_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/local_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_image_error.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_minus_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_plus_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/delete_item.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

// ignore: must_be_immutable
class StoreCartListItem extends StatefulWidget {
  StoreCartListItem({
    Key? key,
  }) : super(key: key);

  @override
  State<StoreCartListItem> createState() => _StoreCartListItemState();
}

class _StoreCartListItemState extends State<StoreCartListItem> {
  LocalProductRepository localProductRepository = LocalProductRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(right: 20),
      height: size.height,
      width: size.width,
      child: StreamBuilder<CartProduct>(
        stream: localProductRepository.cartProduct(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.data != null) {
                List<Product> products = snapshot.data!.products;
                List<LocalProduct> locals = snapshot.data!.locals;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    Product product = products[index];
                    LocalProduct local = locals[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        dismissThresholds: {DismissDirection.endToStart: 0.2},
                        confirmDismiss: (direction) async {
                          bool? check = await deleteItemDialog(context);
                          if (check == true) {
                            await localProductRepository.deleteProduct(
                              maSanPham: product.product_id,
                            );
                            localProductRepository.addPrice(products: products);
                            products.removeAt(index);
                            locals.removeAt(index);
                            localProductRepository.addCartProduct(
                                products: products, locals: locals);
                          }
                          return check;
                        },
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            // Thực hiện xóa mục tại đây
                          }
                        },
                        background: Container(
                          height: 120,
                          width: size.width,
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: rose100,
                          ),
                          child: Image.asset(
                            'assets/images/trash.png',
                            scale: 2,
                            color: rose500,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 120,
                              child: InkWell(
                                onTap: () {
                                  if (local.trangThai == 0) {
                                    local.trangThai = 1;
                                    localProductRepository.updateProductStatus(
                                      maSanPham: local.maSanPham,
                                      trangThai: 1,
                                    );
                                  } else {
                                    local.trangThai = 0;
                                    localProductRepository.updateProductStatus(
                                      maSanPham: local.maSanPham,
                                      trangThai: 0,
                                    );
                                  }
                                  localProductRepository.addCartProduct(
                                      products: products, locals: locals);
                                  localProductRepository.addPrice(
                                      products: products);
                                },
                                child: Image.asset(
                                  local.trangThai == 1
                                      ? 'assets/icons/radio_check.png'
                                      : 'assets/icons/radio_uncheck.png',
                                  scale: 3,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 120,
                                width: size.width,
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 120,
                                        width: size.width,
                                        color: whiteColor,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 120,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                color: rose100,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: product.image,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        StoreImageError(),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TitleText(
                                                    text: product.name,
                                                    fontWeight: FontWeight.w500,
                                                    size: 14,
                                                    color: grey700,
                                                    maxLines: 1,
                                                  ),
                                                  TitleText(
                                                    text: product.type,
                                                    fontWeight: FontWeight.w500,
                                                    size: 12,
                                                    color: grey500,
                                                    maxLines: 1,
                                                  ),
                                                  TitleText(
                                                    text: NumberHandle()
                                                        .formatPrice(
                                                            product.sale,
                                                            '.',
                                                            '₫'),
                                                    fontWeight: FontWeight.w500,
                                                    size: 18,
                                                    color: Color(0xffF63D68),
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Container(
                                              height: 120,
                                              width: 34,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: whiteColor,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      local.soLuong++;
                                                      setState(() {});
                                                      localProductRepository
                                                          .updateProduct(
                                                        localProduct: local,
                                                        soLuong: local.soLuong,
                                                      );

                                                      localProductRepository
                                                          .addPrice(
                                                              products:
                                                                  products);
                                                    },
                                                    child: StorePlusButton(
                                                      width: 28,
                                                      height: 25,
                                                      backgroundColor: grey200,
                                                      iconColor: grey500,
                                                    ),
                                                  ),
                                                  TitleText(
                                                    text: local.soLuong
                                                        .toString(),
                                                    fontWeight: FontWeight.w500,
                                                    size: 14,
                                                    color: grey500,
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      if (local.soLuong == 1) {
                                                        bool? check =
                                                            await deleteItemDialog(
                                                                context);
                                                        if (check == true) {
                                                          await localProductRepository
                                                              .deleteProduct(
                                                                  maSanPham: product
                                                                      .product_id);
                                                          localProductRepository
                                                              .addPrice(
                                                                  products:
                                                                      products);
                                                          products
                                                              .removeAt(index);
                                                          locals
                                                              .removeAt(index);

                                                          localProductRepository
                                                              .addCartProduct(
                                                                  products:
                                                                      products,
                                                                  locals:
                                                                      locals);
                                                        }
                                                      } else {
                                                        local.soLuong--;
                                                        setState(() {});
                                                        localProductRepository
                                                            .updateProduct(
                                                          localProduct: local,
                                                          soLuong:
                                                              local.soLuong,
                                                        );
                                                        localProductRepository
                                                            .addPrice(
                                                                products:
                                                                    products);
                                                      }
                                                    },
                                                    child: StoreMinusButton(
                                                      width: 28,
                                                      height: 25,
                                                      backgroundColor: grey200,
                                                      iconColor: grey500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (local.trangThai == 0) ...[
                                        Container(
                                          height: 120,
                                          width: size.width,
                                          color: whiteColor.withOpacity(0.4),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox();
              }
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
