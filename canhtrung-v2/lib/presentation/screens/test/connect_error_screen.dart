// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConnectErrorScreen extends StatelessWidget {
  static const routeName = 'connect-error-screen';
  final VoidCallback onTap;
  const ConnectErrorScreen({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(
              height: 400.h,
              child: Image.asset(Imgs.disconnect),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildText(
                  text: 'Không Có Kết Nối Internet',
                  style: 26.text600,
                  color: rose500,
                ),
                6.verticalSpace,
                BuildText(
                  text: 'Hãy thử các bước sau để kết nối lại:',
                  style: 15.text400,
                  color: greyText,
                ),
                BuildText(
                  text: '\u2022 Kiểm tra modem và bộ định tuyến',
                  style: 15.text400,
                  color: greyText,
                ),
                BuildText(
                  text: '\u2022 Kết nối lại Wifi',
                  style: 15.text400,
                  color: greyText,
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: KSubmitButton(
                    size: Size(context.width, 40.h),
                    text: 'Quay lại',
                    onTap: () => context.pop(),
                    bgColor: whiteColor,
                    textColor: Palette.title,
                    border: BorderSide(color: Palette.title),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: KSubmitButton(
                    size: Size(context.width, 40.h),
                    text: 'Thử lại',
                    onTap: onTap,
                  ),
                ),
              ],
            ),
            50.verticalSpace,
          ],
        ),
      ),
    );
  }
}
