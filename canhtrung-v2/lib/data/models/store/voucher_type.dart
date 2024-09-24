// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_ovumb_app_version1/data/models/store/voucher.dart';

class VoucherType {
  final int id;
  final String name;
  final List<Voucher> vouchers;
  VoucherType({
    required this.id,
    required this.name,
    required this.vouchers,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'vouchers': vouchers.map((x) => x.toMap()).toList(),
    };
  }

  factory VoucherType.fromMap(Map<String, dynamic> map) {
    return VoucherType(
      id: map['id'] as int,
      name: map['name'] as String,
      vouchers: (map['data'] as List<dynamic>?)
              ?.map((e) => Voucher.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory VoucherType.fromJson(String source) =>
      VoucherType.fromMap(json.decode(source) as Map<String, dynamic>);
}
