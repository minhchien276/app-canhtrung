// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/product/local_product_repository.dart';

import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/voucher/store_voucher_category.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class StoreVoucherScreen extends StatefulWidget {
  static const routeName = 'store-voucher-screen';
  const StoreVoucherScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StoreVoucherScreen> createState() => _StoreVoucherScreenState();
}

class _StoreVoucherScreenState extends State<StoreVoucherScreen> {
  LocalProductRepository localProductReposity = LocalProductRepository();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: grey100,
      appBar: AppBar(
        title: TitleText(
          text: 'Voucher',
          fontWeight: FontWeight.w600,
          size: 18,
          color: grey700,
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/icons/back_button.png',
            scale: 3.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: grey100,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        elevation: 0,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        margin: const EdgeInsets.only(top: 20, right: 24, left: 24),
        child: StreamBuilder<List<VoucherType>>(
          stream: localProductReposity.voucherStream(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              List<VoucherType> voucherTypes = snapshot.data!;
              return ListView.builder(
                itemCount: voucherTypes.length,
                itemBuilder: (context, index) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.data != null) {
                        return StoreVoucherCategory(
                          voucherType: voucherTypes[index],
                          listVoucherType: voucherTypes,
                        );
                      } else {
                        return const SizedBox();
                      }
                    default:
                      return const SizedBox();
                  }
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
