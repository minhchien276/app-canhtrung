import 'dart:async';
import 'dart:convert';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';

class VoucherProvider {
  final _dio = BaseService.instance.dio;
  static final VoucherProvider _instance = VoucherProvider._internal();
  factory VoucherProvider() {
    return _instance;
  }
  VoucherProvider._internal();
  StreamController<List<VoucherType>> streamVoucher =
      StreamController.broadcast();
  final _prefs = SharedPreferencesService();

  //get vouchers
  Future<List<VoucherType>?> getVouchers() async {
    try {
      final maNguoiDung = await _prefs.id;

      final response = await _dio.get('$voucherGetVoucher/$maNguoiDung');
      List<VoucherType> voucherType = [];
      if (response.statusCode == 200) {
        List x = response.data['data'];
        voucherType =
            x.map((e) => VoucherType.fromJson(jsonEncode(e))).toList();
      }
      streamVoucher.add(voucherType);
      return voucherType;
    } catch (e) {
      return null;
    }
  }

  addVouchers(List<VoucherType> voucherType) {
    streamVoucher.add(voucherType);
  }

  Stream<List<VoucherType>> vouchers() => streamVoucher.stream;
}
