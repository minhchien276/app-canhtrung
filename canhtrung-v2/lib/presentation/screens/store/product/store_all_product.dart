import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/store/store_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/product/store_product_item.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class StoreAllProduct extends StatefulWidget {
  const StoreAllProduct({super.key});

  @override
  State<StoreAllProduct> createState() => _StoreAllProductState();
}

class _StoreAllProductState extends State<StoreAllProduct> {
  StoreRepository storeRepository = StoreRepository();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: TitleText(
          text: 'Kết quả tìm kiếm',
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return StoreProductItem(
                          product: snapshot.data![index],
                          type: snapshot.data![index].type,
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: TitleText(
                        text: 'Không thấy kết quả tìm kiếm',
                        fontWeight: FontWeight.w500,
                        size: 16,
                        color: grey700,
                      ),
                    );
                  }
                } else {
                  return Loading();
                }
              default:
                return Loading();
            }
          },
        ),
      ),
    );
  }
}
