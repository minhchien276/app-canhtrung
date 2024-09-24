// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NguoiDung {
  final String maNguoiDung;
  final int? maTvv;
  String tenNguoiDung;
  final String? email;
  final int namSinh;
  int? chieuCao;
  int? canNang;
  final int? phase;
  final DateTime? ngayTao;
  final int? trangThai;
  final String? avatar;
  NguoiDung({
    required this.maNguoiDung,
    this.maTvv,
    required this.tenNguoiDung,
    this.email,
    required this.namSinh,
    this.chieuCao,
    this.canNang,
    this.phase,
    this.ngayTao,
    this.trangThai,
    this.avatar,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'maNguoiDung': maNguoiDung,
      'maTvv': maTvv,
      'tenNguoiDung': tenNguoiDung,
      'email': email,
      'namSinh': namSinh,
      'chieuCao': chieuCao,
      'canNang': canNang,
      'phase': phase,
      'ngayTao': ngayTao?.millisecondsSinceEpoch,
      'trangThai': trangThai,
      'avatar': avatar,
    };
  }

  factory NguoiDung.fromMap(Map<String, dynamic> map) {
    return NguoiDung(
      maNguoiDung: map['maNguoiDung'] as String,
      maTvv: map['maTvv'] != null ? map['maTvv'] as int : null,
      tenNguoiDung: map['tenNguoiDung'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      namSinh: map['namSinh'] as int,
      chieuCao: map['chieuCao'] != null ? map['chieuCao'] as int : null,
      canNang: map['canNang'] != null ? map['canNang'] as int : null,
      phase: map['phase'] != null ? map['phase'] as int : null,
      ngayTao: map['ngayTao'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['ngayTao'] as int)
          : null,
      trangThai: map['trangThai'] != null ? map['trangThai'] as int : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NguoiDung.fromJson(String source) =>
      NguoiDung.fromMap(json.decode(source) as Map<String, dynamic>);

  copyWith({
    String? maNguoiDung,
    int? maTvv,
    String? tenNguoiDung,
    String? email,
    int? namSinh,
    int? chieuCao,
    int? canNang,
    int? phase,
    DateTime? ngayTao,
    int? trangThai,
    String? avatar,
  }) {
    return NguoiDung(
      maNguoiDung: maNguoiDung ?? this.maNguoiDung,
      tenNguoiDung: tenNguoiDung ?? this.tenNguoiDung,
      namSinh: namSinh ?? this.namSinh,
      email: email ?? this.email,
      chieuCao: chieuCao ?? this.chieuCao,
      canNang: canNang ?? this.canNang,
      phase: phase ?? this.phase,
      ngayTao: ngayTao ?? this.ngayTao,
      trangThai: trangThai ?? this.trangThai,
      avatar: avatar ?? this.avatar,
    );
  }
}
