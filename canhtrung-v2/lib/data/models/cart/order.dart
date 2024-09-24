import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Order {
  final int id;
  final String address;
  final int payment_method;
  final int status;
  final num ship_price;
  final num sale_price;
  final num total_price;
  final num final_price;
  final String name;
  final String phone;
  final String content;
  final DateTime created_at;
  Order({
    required this.id,
    required this.address,
    required this.payment_method,
    required this.status,
    required this.ship_price,
    required this.sale_price,
    required this.total_price,
    required this.final_price,
    required this.name,
    required this.phone,
    required this.content,
    required this.created_at,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'address': address,
      'payment_method': payment_method,
      'status': status,
      'ship_price': ship_price,
      'sale_price': sale_price,
      'total_price': total_price,
      'final_price': final_price,
      'name': name,
      'phone': phone,
      'content': content,
      'created_at': created_at.millisecondsSinceEpoch,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int,
      address: map['address'] as String,
      payment_method: map['payment_method'] as int,
      status: map['status'] as int,
      ship_price: map['ship_price'] as num,
      sale_price: map['sale_price'] as num,
      total_price: map['total_price'] as num,
      final_price: map['final_price'] as num,
      name: map['name'] as String,
      phone: map['phone'] as String,
      content: map['content'] as String,
      created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);
}
