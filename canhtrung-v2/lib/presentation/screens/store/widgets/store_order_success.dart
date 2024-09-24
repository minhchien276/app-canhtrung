import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/main_store_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class StoreOrderSuccess extends StatefulWidget {
  static const routeName = 'store-order-success-screen';
  const StoreOrderSuccess({super.key});

  @override
  State<StoreOrderSuccess> createState() => _StoreOrderSuccessState();
}

class _StoreOrderSuccessState extends State<StoreOrderSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/stores/store_success.png',
              scale: 3,
            ),
            const SizedBox(height: 50),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    children: [
                      TitleText(
                        text: 'Đơn hàng đang được OvumB xác nhận',
                        fontWeight: FontWeight.w700,
                        size: 24,
                        color: grey700,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      TitleText(
                        text:
                            'Cùng OvumB bảo vệ quyền lợi của bạn - Chỉ nhận & thanh toán khi đơn mua ở trạng thái “Đang giao hàng”',
                        fontWeight: FontWeight.w500,
                        size: 16,
                        color: grey500,
                        textAlign: TextAlign.center,
                        maxLines: 5,
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () async {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            MainStoreScreen.routeName,
                            arguments: false,
                            (route) => false,
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/icons/back_icon.png', scale: 3),
                            const SizedBox(width: 10),
                            TitleText(
                              text: 'Quay lại trang chủ',
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
          ],
        ),
      ),
    );
  }
}
