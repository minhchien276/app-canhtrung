// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product_category.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/product/store_product_item.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/product/store_product_search_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreProductCategory extends StatelessWidget {
  final List<Product> products;
  final ProductCategory type;
  const StoreProductCategory({
    Key? key,
    required this.products,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: 355.h,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 25.h),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            height: 30.h,
            width: size.width,
            //color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BuildText(
                  text: type.name,
                  style: 18.text600,
                  color: grey700,
                ),
                InkWell(
                  onTap: () {
                    context.pushNamed(
                      StoreProductSearchScreen.routeName,
                      arguments: {
                        'search': type.id,
                        'title': type.name,
                        'isSearch': false,
                      },
                    );
                  },
                  child: TitleText(
                    text: 'Xem thêm',
                    fontWeight: FontWeight.w600,
                    size: 14,
                    color: Color.fromARGB(255, 158, 119, 237),
                  ),
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.only(left: 20.w),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return StoreProductItem(
                  product: products[index],
                  type: type.name,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
