import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// màn hình thông báo khi nhập mã code vẫn còn que test
class TestAddedScreen extends StatelessWidget {
  static const routeName = 'test-added-screen';
  const TestAddedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Image.asset(
                Imgs.qrSuccess,
                fit: BoxFit.cover,
              ),
            ),
            BuildText(
              text: 'Bạn Đã Có Thêm',
              style: 22.text700,
              textAlign: TextAlign.center,
              color: rose400,
            ),
            30.verticalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: '12 lượt ',
                          style: 16.text700.copyWith(
                                color: rose400,
                              )),
                      TextSpan(
                          text: 'sử dụng que thử rụng trứng',
                          style: 16.text400.copyWith(
                                color: grey700,
                              )),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
                8.verticalSpace,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: '1 lượt ',
                          style: 16.text700.copyWith(
                                color: rose400,
                              )),
                      TextSpan(
                          text: 'sử dụng que thử thai',
                          style: 16.text400.copyWith(
                                color: grey700,
                              )),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            50.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: KSubmitButton(
                size: Size(context.width, 50.h),
                text: 'Xác nhận',
                onTap: () => context.pop(),
              ),
            ),
            50.verticalSpace,
          ],
        ),
      ),
    );
  }
}
