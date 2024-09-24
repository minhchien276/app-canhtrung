// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/voucher/store_voucher_item.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class StoreVoucherCategory extends StatefulWidget {
  final VoucherType voucherType;
  final List<VoucherType> listVoucherType;
  const StoreVoucherCategory({
    Key? key,
    required this.voucherType,
    required this.listVoucherType,
  }) : super(key: key);

  @override
  State<StoreVoucherCategory> createState() => _StoreVoucherCategoryState();
}

class _StoreVoucherCategoryState extends State<StoreVoucherCategory> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: widget.voucherType.vouchers.length * 120 + 40,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(
            text: widget.voucherType.name,
            fontWeight: FontWeight.w600,
            size: 16,
            color: grey700,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: widget.voucherType.vouchers.length * 120,
            width: size.width,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.voucherType.vouchers.length,
              itemBuilder: (context, index) {
                return StoreVoucherItem(
                  voucher: widget.voucherType.vouchers[index],
                  voucherType: widget.listVoucherType,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
