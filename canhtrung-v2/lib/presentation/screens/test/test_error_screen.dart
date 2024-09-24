import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/main_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// màn hình thông báo khi nhập mã code khi hết que test
class TestErrorScreen extends StatelessWidget {
  static const routeName = 'test-error-screen';
  const TestErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: size.width,
                child: Image.asset(
                  Imgs.qrError,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            BuildText(
              text: 'Mã hết lượt dùng',
              style: 22.text700,
              color: rose400,
              textAlign: TextAlign.center,
            ),
            6.verticalSpace,
            BuildText(
              text: 'Mã đã hết lượt sử dụng. Xin vui lòng thử lại!',
              style: 14.text400,
              color: grey700,
              textAlign: TextAlign.center,
            ),
            80.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: KSubmitButton(
                size: Size(context.width, 50.h),
                text: 'Thử lại',
                onTap: () => context.pop(),
              ),
            ),
            TextButton(
              onPressed: () async {
                final user = await LocalRepository()
                    .getNguoiDung(SharedPreferencesService().id ?? '');
                context.goName(MainScreen.routeName, arguments: user);
              },
              child: BuildText(
                text: 'Hủy',
                style: 15.text500,
                color: rose400,
                textDecoration: TextDecoration.underline,
              ),
            ),
            50.verticalSpace,
          ],
        ),
      ),
    );
  }
}
