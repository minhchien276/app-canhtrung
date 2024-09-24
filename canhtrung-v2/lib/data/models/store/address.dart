import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Address {
  final int id;
  final String provinces;
  final String districts;
  final String wards;
  final String address_specific;
  final int status;
  final String username;
  final String phone;
  final String maNguoiDung;
  final String provinceId;
  final String districtId;
  final String wardId;
  Address({
    required this.id,
    required this.provinces,
    required this.districts,
    required this.wards,
    required this.address_specific,
    required this.status,
    required this.username,
    required this.phone,
    required this.maNguoiDung,
    required this.provinceId,
    required this.districtId,
    required this.wardId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'provinces': provinces,
      'districts': districts,
      'wards': wards,
      'address_specific': address_specific,
      'status': status,
      'username': username,
      'phone': phone,
      'maNguoiDung': maNguoiDung,
      'provinceId': provinceId,
      'districtId': districtId,
      'wardId': wardId,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] as int,
      provinces: map['provinces'] as String,
      districts: map['districts'] as String,
      wards: map['wards'] as String,
      address_specific: map['address_specific'] as String,
      status: map['status'] as int,
      username: map['username'] as String,
      phone: map['phone'] as String,
      maNguoiDung: map['maNguoiDung'] as String,
      provinceId: map['provinceId'] as String,
      districtId: map['districtId'] as String,
      wardId: map['wardId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) =>
      Address.fromMap(json.decode(source) as Map<String, dynamic>);
}
