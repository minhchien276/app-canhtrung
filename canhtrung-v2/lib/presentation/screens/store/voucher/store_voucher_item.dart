// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/voucher/voucher_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/voucher/store_voucher_sale_item.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/voucher/store_voucher_ship_item.dart';

class StoreVoucherItem extends StatefulWidget {
  final Voucher voucher;
  final List<VoucherType> voucherType;
  const StoreVoucherItem({
    Key? key,
    required this.voucher,
    required this.voucherType,
  }) : super(key: key);

  @override
  State<StoreVoucherItem> createState() => _StoreVoucherItemState();
}

class _StoreVoucherItemState extends State<StoreVoucherItem> {
  VoucherRepository voucherRepository = VoucherRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.voucher.idTypeVoucher == 1
        ? StoreVoucherShipItem(
            voucher: widget.voucher,
            voucherType: widget.voucherType,
          )
        : StoreVoucherSaleItem(
            voucher: widget.voucher,
            voucherType: widget.voucherType,
          );
  }
}
