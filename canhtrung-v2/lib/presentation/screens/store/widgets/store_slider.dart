// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/store_slider.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_image_error.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreSliderScreen extends StatefulWidget {
  final List<StoreSlider> sliders;
  const StoreSliderScreen({
    Key? key,
    required this.sliders,
  }) : super(key: key);

  @override
  State<StoreSliderScreen> createState() => _StoreSliderScreenState();
}

class _StoreSliderScreenState extends State<StoreSliderScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 240.h,
      width: size.width,
      child: Stack(
        children: [
          CarouselSlider(
            items: List.generate(
              widget.sliders.length,
              (index) => Container(
                color: grey300,
                width: size.width,
                child: CachedNetworkImage(
                  imageUrl: widget.sliders[index].image,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => StoreImageError(),
                ),
              ),
            ),
            options: CarouselOptions(
              height: 240.h,
              scrollDirection: Axis.horizontal,
              autoPlay: true,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _index = index;
                });
              },
            ),
          ),
          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
            child: Container(
              height: 8,
              width: 100,
              alignment: Alignment.center,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: widget.sliders.length,
                itemBuilder: (context, index) {
                  return buildIndicator(index == _index, size);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// indicator của chân trang question
Widget buildIndicator(bool isActive, Size size) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    curve: Curves.bounceInOut,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    width: 8,
    height: 8,
    decoration: BoxDecoration(
      color: isActive ? rose500 : Color(0xffF2F4F7),
      borderRadius: const BorderRadius.all(Radius.circular(100)),
    ),
  );
}
