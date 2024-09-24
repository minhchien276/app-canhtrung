// ignore_for_file: public_member_api_docs, sort_constructors_first
// dữ liệu của chu kì kinh đã quay xử lí
import 'package:flutter/material.dart';

class CKKNDisplay {
  final int snkcl; // số ngày kinh còn lại
  final int sntcl; // số ngày trứng còn lại
  final List<String> titleKinh; // title của kinh
  final List<String> titleTrung; // titlte của trứng
  final List<String> subKinh; // subtitle của kinh
  final List<String> subTrung; // subtitle của trứng
  final double kinhPercent; // tỉ lệ kinh
  final double trungPercent; // tỉ lệ trứng
  final Color color;
  final Color bgColor;
  final String icon1;
  final String icon2;

  CKKNDisplay(
    this.snkcl,
    this.sntcl,
    this.titleKinh,
    this.titleTrung,
    this.subKinh,
    this.subTrung,
    this.kinhPercent,
    this.trungPercent,
    this.color,
    this.bgColor,
    this.icon1,
    this.icon2,
  );
}
