import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/voucher/voucher_provider.dart';

class VoucherRepository {
  final _provider = VoucherProvider();
  Future<List<VoucherType>?> getVouchers() => _provider.getVouchers();

  addVouchers({required List<VoucherType> voucherType}) =>
      _provider.addVouchers(voucherType);

  Stream<List<VoucherType>> vouchers() => _provider.vouchers();
}
