import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderDetail {
  final int? id;
  final int quantity;
  final int? id_order;
  final int id_product_detail;
  final num price;
  OrderDetail({
    this.id,
    required this.quantity,
    this.id_order,
    required this.id_product_detail,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quantity': quantity,
      'id_order': id_order,
      'id_product_detail': id_product_detail,
      'price': price,
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      id: map['id'] != null ? map['id'] as int : null,
      quantity: map['quantity'] as int,
      id_order: map['id_order'] != null ? map['id_order'] as int : null,
      id_product_detail: map['id_product_detail'] as int,
      price: map['price'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetail.fromJson(String source) =>
      OrderDetail.fromMap(json.decode(source) as Map<String, dynamic>);
}
