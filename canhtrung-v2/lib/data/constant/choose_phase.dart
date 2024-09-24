// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';

class ChoosePhase {
  final String image;
  final String imageUrl;
  final String title;
  final String subTitle;
  final String content;
  final PhaseEnum type;
  final Color fromColor;
  final Color toColor;
  ChoosePhase({
    required this.image,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.content,
    required this.type,
    required this.fromColor,
    required this.toColor,
  });
}

List<ChoosePhase> choosePhase = [
  ChoosePhase(
    image: 'assets/images/radio_image2.png',
    imageUrl: 'assets/images/choose_image2.png',
    title: 'Tính rụng trứng',
    subTitle: 'Hỗ trợ mang thai',
    content:
        'Theo dõi sức khỏe, đồng hành và hỗ trợ canh trứng sinh con theo ý muốn',
    type: PhaseEnum.trung,
    fromColor: rose500,
    toColor: rose400,
  ),
  ChoosePhase(
    image: 'assets/images/radio_image1.png',
    imageUrl: 'assets/images/choose_image1.png',
    title: 'Tính ngày an toàn',
    subTitle: 'Quản lý kỳ kinh',
    content: 'Theo dõi và quản lý chu kỳ kinh',
    type: PhaseEnum.antoan,
    fromColor: violet500,
    toColor: violet400,
  ),
  ChoosePhase(
    image: 'assets/images/radio_image4.png',
    imageUrl: 'assets/images/choose_image4.png',
    title: 'Theo dõi sữa mẹ',
    subTitle: 'Chăm sóc trẻ sơ sinh',
    content: 'Hướng dẫn chăm sóc mẹ và bé sau sinh',
    type: PhaseEnum.sua,
    fromColor: blue500,
    toColor: blue400,
  ),
  ChoosePhase(
    image: 'assets/images/radio_image3.png',
    imageUrl: 'assets/images/choose_image3.png',
    title: 'Theo dõi Thai kì',
    subTitle: 'Mẹ tròn con vuông',
    content: 'Quản lý và hướng dẫn chăm sóc sức khỏe mẹ bầu',
    type: PhaseEnum.thai,
    fromColor: green500,
    toColor: green300,
  ),
];
