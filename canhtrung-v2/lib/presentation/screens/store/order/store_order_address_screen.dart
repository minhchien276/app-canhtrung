import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/address/address_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/shipping/shipping_info.dart';

class StoreOrderAddressScreen extends StatefulWidget {
  static const routeName = 'store-order-address-screen';
  const StoreOrderAddressScreen({super.key});

  @override
  State<StoreOrderAddressScreen> createState() =>
      _StoreOrderAddressScreenState();
}

class _StoreOrderAddressScreenState extends State<StoreOrderAddressScreen> {
  AddressRepository addressRepository = AddressRepository();

  @override
  void initState() {
    addressRepository.getAllAddress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ShippingInfo();
  }
}
