// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/presentation/screens/store/main_store_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class StoreCartEmpty extends StatefulWidget {
  final bool isShowHome;
  const StoreCartEmpty({
    Key? key,
    required this.isShowHome,
  }) : super(key: key);

  @override
  State<StoreCartEmpty> createState() => _StoreCartEmptyState();
}

class _StoreCartEmptyState extends State<StoreCartEmpty> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Image.asset(
              'assets/stores/cart_empty.png',
              scale: 3,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    children: [
                      TitleText(
                        text: 'Giỏ Hàng Trống',
                        fontWeight: FontWeight.w700,
                        size: 24,
                        color: grey700,
                      ),
                      const SizedBox(height: 10),
                      TitleText(
                        text:
                            'Có vẻ như bạn vẫn chưa thêm gì vào giỏ hàng. Hãy lựa chọn thêm sản phẩm nhé!',
                        fontWeight: FontWeight.w500,
                        size: 16,
                        color: grey500,
                        textAlign: TextAlign.center,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          if (widget.isShowHome) {
                            Navigator.pushReplacementNamed(
                              context,
                              MainStoreScreen.routeName,
                              arguments: true,
                            );
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/back_icon.png', scale: 3),
                            const SizedBox(width: 10),
                            TitleText(
                              text: 'Quay lại trang sản phẩm',
                              fontWeight: FontWeight.w500,
                              size: 16,
                              color: rose400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
