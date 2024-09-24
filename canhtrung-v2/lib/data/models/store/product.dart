import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Product {
  final int id;
  final String name;
  final String image;
  final num price;
  final num sale;
  final String description;
  final String content;
  final String guide;
  final int product_id;
  final String type;
  final num? sold;
  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.sale,
    required this.description,
    required this.content,
    required this.guide,
    required this.product_id,
    required this.type,
    this.sold,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'sale': sale,
      'description': description,
      'content': content,
      'guide': guide,
      'product_id': product_id,
      'type': type,
      'sold': sold,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as String,
      price: map['price'] as num,
      sale: map['sale'] as num,
      description: map['description'] as String,
      content: map['content'] as String,
      guide: map['guide'] as String,
      product_id: map['product_id'] as int,
      type: map['type'] as String,
      sold: map['sold'] != null ? map['sold'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
