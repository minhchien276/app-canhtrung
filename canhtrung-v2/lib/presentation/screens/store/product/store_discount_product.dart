// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/store/store_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/product/store_product_item_expanded.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

// ignore: must_be_immutable
class StoreDiscountProductScreen extends StatelessWidget {
  static const routeName = 'store-product-discount-screen';
  final List<Product> products;
  StoreDiscountProductScreen({
    Key? key,
    required this.products,
  }) : super(key: key);

  StoreRepository storeRepository = StoreRepository();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: TitleText(
          text: 'Sản Phẩm Khuyến Mãi',
          fontWeight: FontWeight.w600,
          size: 18,
          color: grey700,
        ),
        leading: kBackButton(context),
        centerTitle: true,
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        elevation: 0,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            crossAxisCount: 2,
            childAspectRatio: 9 / 15,
          ),
          itemBuilder: (context, index) {
            return StoreProductItemExpand(
              product: products[index],
              type: products[index].type,
            );
          },
        ),
      ),
    );
  }
}
