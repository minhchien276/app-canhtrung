// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/handle/number_handle.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/local_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/slider/slider_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/animated/store_cart_animated.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_cart_icon.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_cart_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_image_error.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_minus_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_plus_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_slider.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreProductItemDetail extends StatefulWidget {
  static const routeName = 'store-product-item-detail';
  final Product product;
  final String type;
  const StoreProductItemDetail({
    Key? key,
    required this.product,
    required this.type,
  }) : super(key: key);

  @override
  State<StoreProductItemDetail> createState() => _StoreProductItemDetailState();
}

class _StoreProductItemDetailState extends State<StoreProductItemDetail> {
  bool _checkAdd = true;

  int count = 1;
  late num total = 0;
  int _currentPage = 0;
  bool _dragModalBottm = false;

  int _indexTabbar = 0;
  PageController _pageController = PageController(initialPage: 0);

  Duration forwardDuration = Duration(seconds: 2);
  Duration reverseDuration = Duration(milliseconds: 100);

  List<Tabr> tabbar = [
    Tabr(title: 'Mô tả sản phẩm', width: 110),
    Tabr(title: 'Thành phần', width: 85),
    Tabr(title: 'Hướng dẫn sử dụng', width: 135),
  ];

  List<String> contents = [];

  void _addItem(
    LocalProduct product,
  ) {
    if (_checkAdd) {
      _checkAdd = false;
      setState(() {});
      sliderRepository.addCartAnimted(widget.product.image);
      sliderRepository.addCart(product);
      Future.delayed(const Duration(milliseconds: 1500), () {
        _checkAdd = true;
        setState(() {});
      });
    }
  }

  void _initialContent() {
    contents.add(widget.product.description);
    contents.add(widget.product.content);
    contents.add(widget.product.guide);
  }

  @override
  void initState() {
    total = widget.product.sale * count;
    _initialContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar();
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final appBarHeight = appBar.preferredSize.height;
    final totalAppBarHeight = appBarHeight + statusBarHeight;
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height - totalAppBarHeight;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: rose25,
          appBar: AppBar(
            title: BuildText(
              text: 'Thông tin sản phẩm',
              style: 18.text600,
              color: grey700,
            ),
            leading: kBackButton(context),
            centerTitle: true,
            backgroundColor: rose25,
            shadowColor: whiteColor,
            bottomOpacity: 0.1,
            elevation: 0,
            actions: [
              InkWell(
                onTap: () => Navigator.pushNamed(
                  context,
                  StoreCartScreen.routeName,
                  arguments: false,
                ),
                child: StoreCartIcon(
                  isPrimary: true,
                ),
              ),
            ],
          ),
          body: Container(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildImageWidget(size, screenHeight),
                    _buildBody(size, screenHeight),
                  ],
                ),
                _buildActions(),
              ],
            ),
          ),
        ),
        StoreCartAnimated(),
      ],
    );
  }

  _buildImageWidget(Size size, double screenHeight) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: _dragModalBottm ? 0.0 : 1.0,
      child: AnimatedContainer(
        width: size.width,
        height: _dragModalBottm ? 0 : screenHeight * 0.40,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.fastOutSlowIn,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: 1,
              itemBuilder: (context, index) {
                return Container(
                  height: 200,
                  width: size.width,
                  child: CachedNetworkImage(
                    imageUrl: widget.product.image,
                    errorWidget: (context, url, error) => StoreImageError(),
                  ),
                );
              },
              onPageChanged: (value) {
                _currentPage = value;
                setState(() {});
              },
            ),
            _dragModalBottm
                ? const SizedBox()
                : Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 8.h,
                      width: 100.w,
                      alignment: Alignment.center,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return buildIndicator(index == _currentPage, size);
                        },
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _buildBody(Size size, double screenHeight) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < 0) {
          // Khi vuốt lên, thay đổi giá trị _dragModalBottm
          _dragModalBottm = true;
        } else if (details.delta.dy > 0) {
          // Khi vuốt xuống, thay đổi giá trị _dragModalBottm
          _dragModalBottm = false;
        }
        setState(() {});
      },
      child: AnimatedContainer(
        width: size.width,
        height: _dragModalBottm ? screenHeight : screenHeight * 0.60,
        alignment:
            _dragModalBottm ? Alignment.center : AlignmentDirectional.topCenter,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.fastOutSlowIn,
        child: Container(
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              8.verticalSpace,
              Container(
                height: 6.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: grey200,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              16.verticalSpace,
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  width: size.width,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      BuildText(
                        text: widget.product.name,
                        style: 20.text600,
                        color: grey700,
                      ),
                      BuildText(
                        text: widget.type,
                        style: 16.text500,
                        color: grey500,
                      ),
                      25.verticalSpace,
                      Container(
                        height: 40.h,
                        width: size.width,
                        child: ListView.builder(
                          itemCount: tabbar.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                _indexTabbar = index;
                                setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 15),
                                height: 40,
                                width: tabbar[index].width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TitleText(
                                      text: tabbar[index].title,
                                      fontWeight: FontWeight.w600,
                                      size: 13,
                                      color: _indexTabbar == index
                                          ? Color(0xff7F56D9)
                                          : grey600,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      color: _indexTabbar == index
                                          ? Color(0xff7F56D9)
                                          : whiteColor,
                                      width: 120,
                                      height: 2,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      20.verticalSpace,
                      GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            _dragModalBottm = !_dragModalBottm;
                          });
                        },
                        child: Container(
                          height: 380.h,
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: TitleText(
                              text: contents[_indexTabbar],
                              fontWeight: FontWeight.w500,
                              size: 14,
                              maxLines: _dragModalBottm ? 1000 : 3,
                              color: grey500,
                            ),
                          ),
                        ),
                      ),
                      40.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildActions() {
    return Positioned(
      left: 24.w,
      right: 24.w,
      bottom: 40.h,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 35.h,
                width: 110.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xffE4E7EC),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        if (count != 0) {
                          count--;
                          total = widget.product.sale.toDouble() * count;
                          setState(() {});
                        }
                      },
                      child: StoreMinusButton(
                        height: 35,
                        width: 30,
                        backgroundColor: whiteColor,
                        iconColor: grey500,
                      ),
                    ),
                    TitleText(
                      text: count.toString(),
                      fontWeight: FontWeight.w500,
                      size: 14,
                      color: grey500,
                    ),
                    InkWell(
                      onTap: () {
                        count++;
                        total = widget.product.sale.toDouble() * count;
                        setState(() {});
                      },
                      child: StorePlusButton(
                        height: 35,
                        width: 30,
                        backgroundColor: whiteColor,
                        iconColor: grey500,
                      ),
                    ),
                  ],
                ),
              ),
              BuildText(
                text: NumberHandle().formatPrice(total, '.', '₫'),
                style: 22.text500,
                color: Color(0xff7F56D9),
              ),
            ],
          ),
          30.verticalSpace,
          KSubmitButton(
            size: Size(context.width, 50.h),
            text: 'Thêm vào giỏ hàng',
            bgColor: count == 0 ? grey400 : Color(0xff7F56D9),
            onTap: () {
              if (count != 0) {
                _addItem(
                  LocalProduct(
                    maSanPham: widget.product.product_id,
                    soLuong: count,
                    trangThai: 1,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class Tabr {
  final String title;
  final double width;
  Tabr({
    required this.title,
    required this.width,
  });
}
