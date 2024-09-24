// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_shipping.dart';

import 'package:flutter_ovumb_app_version1/data/models/store/address.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/address/address_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/shipping/shipping_add.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/shimmer/address_widget_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/shipping/shipping_address.dart';

class ShippingInfo extends StatefulWidget {
  static const routeName = 'shipping-info';
  const ShippingInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<ShippingInfo> createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfo> {
  AddressRepository addressRepository = AddressRepository();

  List<Address> initAddress = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar();
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final appBarHeight = appBar.preferredSize.height;
    final totalAppBarHeight = appBarHeight + statusBarHeight;
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height - totalAppBarHeight;
    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xfffafafa),
        title: Text(
          'Địa Chỉ Giao Hàng',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            color: grey700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/back_icon.png',
            scale: 3,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        padding: EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: [
            StreamBuilder<List<Address>>(
              initialData: initAddress,
              stream: addressRepository.allAddress(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    if (snapshot.data!.isNotEmpty) {
                      List<Address> address = snapshot.data!;
                      initAddress = address;
                      return Container(
                        height: address.length * 180,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: address.length,
                          itemBuilder: (context, index) {
                            return ShippingAddress(
                              address: address[index],
                              length: address.length,
                              height: screenHeight,
                            );
                          },
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }
                }
                return getShimmer(AddressWidgetShimmer());
              },
            ),
            if (initAddress.length < 3) ...[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextButton(
                  style: const ButtonStyle(
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    shadowColor: WidgetStatePropertyAll(Colors.transparent),
                  ),
                  child: Container(
                    height: 50,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: violet600,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Thêm Địa Chỉ Mới',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onPressed: () {
                    dataShipping[0].isDeleted = false;
                    setState(() {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        barrierColor: Colors.white.withOpacity(0.001),
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        context: context,
                        builder: (context) {
                          return Container(
                            height: screenHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: ShippingAdd(
                              address: initAddress,
                            ),
                          );
                        },
                      );
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
