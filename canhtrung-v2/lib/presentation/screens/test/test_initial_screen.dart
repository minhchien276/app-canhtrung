import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/qrcode/qrcode.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/main_store_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/connect_error_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_select_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/shimmer/test_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kmenu_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/color.dart';
import '../../widgets/title_text.dart';

// màn hình nhập code test
class TestInitialScreen extends StatefulWidget {
  static const routeName = 'test-initial-screen';
  const TestInitialScreen({
    super.key,
  });

  @override
  State<TestInitialScreen> createState() => _TestInitialScreenState();
}

class _TestInitialScreenState extends State<TestInitialScreen> {
  @override
  void initState() {
    context.read<TestBloc>().add(TestCheckEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      endDrawer: GlobalDrawer(
        size: screenSize,
        scaffoldKey: scaffoldKey,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: BuildText(
          text: 'Test',
          style: 17.text600,
          color: rose500,
        ),
        leading: kBackButton(context),
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        actions: [
          kMenuButton(
            context,
            onTap: () => scaffoldKey.currentState!.openEndDrawer(),
            color: rose400,
          )
        ],
      ),
      body: BlocBuilder<TestBloc, TestState>(
        builder: (context, state) {
          if (state.isLoading) return getShimmer(TestShimmer());
          if (state.status == LoadedStatus.disconnect)
            return ConnectErrorScreen(
                onTap: () => context.read<TestBloc>().add(TestCheckEvent()));
          if (state.quanLyQueTest != null) {
            if (state.quanLyQueTest!.hasQueTest) {
              return TestSelectScreen();
            }
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                30.verticalSpace,
                Image.asset(Imgs.qr),
                BuildText(
                  text: 'Quét mã để Test',
                  style: 24.text700,
                  color: rose400,
                  textAlign: TextAlign.center,
                ),
                BuildText(
                  text:
                      'Với mỗi hộp OvumB, bạn sẽ được cung cấp 1 mã QR để test cho nhiều lần sử dụng',
                  style: 14.text400,
                  color: grey700,
                  textAlign: TextAlign.center,
                ),
                80.verticalSpace,
                KSubmitButton(
                  size: Size(context.width, 50.h),
                  text: 'Quét mã QR',
                  icon: IconApp.qr,
                  onTap: () => context.pushNamed(QRCodeScreen.routeName),
                ),
                KSubmitButton(
                  size: Size(context.width, 50.h),
                  text: 'Mua que OvumB',
                  icon: IconApp.cartPlus,
                  bgColor: whiteColor,
                  textColor: rose400,
                  onTap: () => context.pushNamed(
                    MainStoreScreen.routeName,
                    arguments: true,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
