import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Voucher {
  final int id;
  final num discount;
  final num minPrice;
  final num maxPrice;
  final int status;
  final int idTypeVoucher;
  final String expired;
  bool isUsed = false;
  Voucher({
    required this.id,
    required this.discount,
    required this.minPrice,
    required this.maxPrice,
    required this.status,
    required this.idTypeVoucher,
    required this.expired,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'discount': discount,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'status': status,
      'idTypeVoucher': idTypeVoucher,
      'expired': expired,
    };
  }

  factory Voucher.fromMap(Map<String, dynamic> map) {
    return Voucher(
      id: map['id'] as int,
      discount: map['discount'] as num,
      minPrice: map['minPrice'] as num,
      maxPrice: map['maxPrice'] as num,
      status: map['status'] as int,
      idTypeVoucher: map['idTypeVoucher'] as int,
      expired: map['expired'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Voucher.fromJson(String source) =>
      Voucher.fromMap(json.decode(source) as Map<String, dynamic>);
}
