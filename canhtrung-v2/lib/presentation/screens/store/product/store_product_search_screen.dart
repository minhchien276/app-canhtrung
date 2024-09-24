// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/store/store_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/product/store_product_item_expanded.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class StoreProductSearchScreen extends StatefulWidget {
  static const routeName = 'store-product-search-screen';
  final dynamic search;
  final String title;
  final bool isSearch;
  const StoreProductSearchScreen({
    Key? key,
    required this.search,
    required this.title,
    required this.isSearch,
  }) : super(key: key);

  @override
  State<StoreProductSearchScreen> createState() =>
      _StoreProductSearchScreenState();
}

class _StoreProductSearchScreenState extends State<StoreProductSearchScreen> {
  StoreRepository storeRepository = StoreRepository();

  @override
  void initState() {
    if (widget.isSearch) {
      storeRepository.searchProducts(search: widget.search);
    } else {
      storeRepository.getAllProduct(category: widget.search);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: TitleText(
          text: widget.title,
          fontWeight: FontWeight.w600,
          size: 18,
          color: grey700,
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
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
      body: Container(
        height: size.height,
        width: size.width,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: StreamBuilder<List<Product>?>(
          stream: storeRepository.searchStream(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.data != null) {
                  if (snapshot.data!.isNotEmpty) {
                    return GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        crossAxisCount: 2,
                        childAspectRatio: 9 / 15,
                      ),
                      itemBuilder: (context, index) {
                        return StoreProductItemExpand(
                          product: snapshot.data![index],
                          type: snapshot.data![index].type,
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: TitleText(
                        text: 'Không tìm thấy kết quả tìm kiếm',
                        fontWeight: FontWeight.w500,
                        size: 16,
                        color: grey700,
                      ),
                    );
                  }
                } else {
                  return const Center(child: Loading());
                }
              default:
                return const Center(child: Loading());
            }
          },
        ),
      ),
    );
  }
}
