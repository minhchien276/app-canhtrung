import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderItem {
  final String name;
  final String image;
  final String type;
  final num sale;
  final num quantity;
  OrderItem({
    required this.name,
    required this.image,
    required this.type,
    required this.sale,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'type': type,
      'sale': sale,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] as String,
      image: map['image'] as String,
      type: map['type'] as String,
      sale: map['sale'] as num,
      quantity: map['quantity'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
