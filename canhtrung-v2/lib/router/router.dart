import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/enum/blog_type.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/test_resutl.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/tvv.dart';
import 'package:flutter_ovumb_app_version1/data/models/notification/notification.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/post.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_phase3_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/chart/chart_history_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/chart/chart_landscape_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/chart/chart_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/group/group_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/profile/profile_verify_otp.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/reminder/reminder_detail.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/image_analyze_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_guide_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/nhatky_screen_v2.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/splash_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/password/change_password_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase2/ngaydusinh_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase2/overall_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/forget_password_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase2/phase2_initial_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase2/phase2_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/baby/baby_add_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/home_phase3_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/hutsua/hut_sua_input.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/kichsua/kich_sua_qrcode.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/hutsua/hut_sua_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/kichsua/kick_sua_document.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/kichsua/kick_sua_video.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_detail.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/suckhoe_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/baby/baby_update_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/product/product_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/qrcode/qrcode.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/register_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/FAQ/faq_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/step/choose_home_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/home_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/main_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/profile/profile_edit_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/reminder/reminder_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/login_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/welcome_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/auth/step/question_main_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/profile/profile_update_kn_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/shipping/shipping_info.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/shipping/shipping_update.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_cart_payment.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_cart_qrcode.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_cart_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/main_store_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/order/store_order_address_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/order/store_order_detail.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/order/store_order_history_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/order/store_order_status_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/product/store_discount_product.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/product/store_product_item_detail.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/product/store_product_search_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/voucher/store_voucher_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_order_success.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_added_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_error_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_failure_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_initial_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_manage_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_que_webview.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_result_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_select_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/tu_van/canh_bao_cham_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/tu_van/giao_duc_gioi_tinh_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/tu_van/tuvan2_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/tu_van/tuvan3_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/tu_van/tuvan5_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/animations/slide_left_route.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/gallery_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/pdf_view.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/webview.dart';

extension NavigatorExtension on BuildContext {
  pushNamed(String name, {Object? arguments}) =>
      Navigator.pushNamed(this, name, arguments: arguments);

  pushReplacementNamed(String name, {Object? arguments}) =>
      Navigator.pushReplacementNamed(this, name, arguments: arguments);

  goName(String name, {Object? arguments}) =>
      Navigator.pushNamedAndRemoveUntil(this, name, (route) => false,
          arguments: arguments);
  pop({Object? value}) => Navigator.pop(this, value);
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => SplashScreen(),
      );
    case OnboardingScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const OnboardingScreen(
          isCheck: true,
        ),
      );

    case NhatkyScreenV2.routeName:
      final date = settings.arguments as DateTime;
      return MaterialPageRoute(
        builder: (context) => NhatkyScreenV2(date: date),
      );
    case QuestionMainScreen.routeName:
      final phase = settings.arguments as PhaseEnum;
      return SlideLeftRoute(
        page: QuestionMainScreen(phase: phase),
      );
    case ProfileUpdateKNScreen.routeName:
      final kinhNguyet = settings.arguments as KinhNguyet;
      return SlideLeftRoute(
        page: ProfileUpdateKNScreen(
          kinhNguyet: kinhNguyet,
        ),
      );

    // case Question3Screen.routeName:
    //   return SlideLeftRoute(
    //     page: const Question3Screen(),
    //   );

    case MainScreen.routeName:
      final user = settings.arguments as NguoiDung;
      return MaterialPageRoute(
        builder: (context) => MainScreen(
          nguoiDung: user,
        ),
      );
    case HomeScreen.routeName:
      final phase = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: HomeScreen(phase: phase),
        ),
      );
    case TestResultScreen.routeName:
      final testResult = settings.arguments as TestResult;
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: TestResultScreen(
            testResult: testResult,
          ),
        ),
      );
    case TestFailureScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final maQuanLyQueTest = arguments['maQuanLyQueTest'];
      final queTestType = arguments['queTestType'];
      final testResult = arguments['testResult'];
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: TestFailureScreen(
            testResult: testResult,
            queTestType: queTestType,
            maQuanLyQueTest: maQuanLyQueTest,
          ),
        ),
      );
    case TestAddedScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: TestAddedScreen(),
        ),
      );
    case TestErrorScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: TestErrorScreen(),
        ),
      );
    case TestSelectScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: TestSelectScreen(),
        ),
      );
    case ImageAnalyzeScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final maQuanLyQueTest = arguments['maQuanLyQueTest'];
      final queTestType = arguments['queTestType'];
      final videos = arguments['videos'];
      final images = arguments['images'];
      return SlideLeftRoute(
        page: ImageAnalyzeScreen(
          maQuanLyQueTest: maQuanLyQueTest,
          queTestType: queTestType,
          videos: videos,
          images: images,
        ),
      );

    case TestGuideScreen.routeName:
      return SlideLeftRoute(
        page: TestGuideScreen(),
      );
    case ForgetPasswordScreen.routeName:
      return SlideLeftRoute(
        page: ForgetPasswordScreen(),
      );
    case QRCodeScreen.routeName:
      return SlideLeftRoute(
        page: QRCodeScreen(),
      );
    case WelcomeScreen.routeName:
      return SlideLeftRoute(
        page: WelcomeScreen(),
      );
    case ReminderScreen.routeName:
      return SlideLeftRoute(
        page: const ReminderScreen(),
      );
    case FAQScreen.routeName:
      return SlideLeftRoute(
        page: FAQScreen(),
      );
    case ProfileEditScreen.routeName:
      final nguoiDung = settings.arguments as NguoiDung;
      return SlideLeftRoute(
        page: ProfileEditScreen(
          nguoiDung: nguoiDung,
        ),
      );
    case ProfileVerifyOtpScreen.routeName:
      final email = settings.arguments as String;
      return SlideLeftRoute(
        page: ProfileVerifyOtpScreen(email: email),
      );
    case ChooseHomeScreen.routeName:
      return SlideLeftRoute(
        page: ChooseHomeScreen(),
      );
    case ChangePasswordScreen.routeName:
      return SlideLeftRoute(
        page: const ChangePasswordScreen(),
      );
    case Tuvan2Screen.routeName:
      final phase = settings.arguments as int;
      return SlideLeftRoute(
        page: Tuvan2Screen(phase: phase),
      );
    case Tuvan3Screen.routeName:
      return SlideLeftRoute(
        page: const Tuvan3Screen(widgetId: 0),
      );
    case Tuvan5Screen.routeName:
      final tvv = settings.arguments as TVV;
      return SlideLeftRoute(
        page: Tuvan5Screen(tvv: tvv),
      );
    case ChartLandscapeScreen.routeName:
      final data = settings.arguments as Map<String, List<ChartLHData>>;
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: ChartLandscapeScreen(
            data: data,
          ),
        ),
      );
    case ChartHistoryScreen.routeName:
      final ketquatest = settings.arguments as Map<String, List<ChartLHData>>;
      return SlideLeftRoute(
        page: ChartHistoryScreen(
          ketquatest: ketquatest,
        ),
      );
    case RegisterScreen.routeName:
      return SlideLeftRoute(
        page: const RegisterScreen(),
      );
    case LoginScreen.routeName:
      return SlideLeftRoute(
        page: LoginScreen(),
      );
    case TestInitialScreen.routeName:
      return SlideLeftRoute(
        page: const TestInitialScreen(),
      );
    case TestManageScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: TestManageScreen(),
        ),
        settings: RouteSettings(name: TestManageScreen.routeName),
      );
    case GroupScreen.routeName:
      final maNguoiDung = settings.arguments as String;

      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: GroupScreen(maNguoiDung: maNguoiDung),
        ),
        settings: RouteSettings(name: GroupScreen.routeName),
      );
    case NgayDuSinhScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final maNguoiDung = arguments['maNguoiDung'];
      final DateTime? ngayDuSinh = arguments['ngayDuSinh'];
      final phase = arguments['phase'];
      return SlideLeftRoute(
        page: NgayDuSinhScreen(
          widgetId: 0,
          maNguoiDung: maNguoiDung,
          ngayDuSinh: ngayDuSinh,
          phase: phase,
        ),
      );
    case Phase2Screen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final nguoiDung = arguments['nguoiDung'];
      final phase = arguments['phase'];
      return MaterialPageRoute(
        builder: (context) => Phase2Screen(
          nguoiDung: nguoiDung,
          phase: phase,
        ),
      );
    case Phase2InitialScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final int? phase = arguments['phase'];
      return SlideLeftRoute(
        page: Phase2InitialScreen(phase: phase),
      );
    case BlogScreen.routeName:
      final phase = settings.arguments as int;
      return SlideLeftRoute(
        page: BlogScreen(phase: phase),
      );
    case OverallScreen.routeName:
      final ngayDuSinh = settings.arguments as DateTime;
      return SlideLeftRoute(
        page: OverallScreen(
          widgetId: 0,
          ngayDuSinh: ngayDuSinh,
        ),
      );
    case BlogScreen.routeName:
      final phase = settings.arguments as int;
      return SlideLeftRoute(
        page: BlogScreen(phase: phase),
      );
    case TestQueWebView.routeName:
      final url = settings.arguments as String;
      return SlideLeftRoute(
        page: TestQueWebView(
          url: url,
        ),
      );
    case HomePhase3Scren.routeName:
      return SlideLeftRoute(
        page: HomePhase3Scren(),
      );

    case BabyUpdateScreen.routeName:
      final con = settings.arguments as Con;
      return SlideLeftRoute(
        page: BabyUpdateScreen(con: con),
      );
    case BabyAddScreen.routeName:
      return SlideLeftRoute(
        page: BabyAddScreen(),
      );
    case SucKhoeScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final index = arguments['index'];
      return MaterialPageRoute(
        builder: (context) => SucKhoeScreen(
          index: index,
        ),
      );
    case ChoAnDetail.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final widgetId = arguments['widgetId'];
      final clickId = arguments['clickId'];
      return MaterialPageRoute(
        builder: (context) => ChoAnDetail(
          widgetId: widgetId,
          clickId: clickId,
        ),
      );
    case HutSuaScreen.routeName:
      final con = settings.arguments as Con;
      return MaterialPageRoute(
        builder: (context) => HutSuaScreen(con: con),
      );
    case HutSuaInput.routeName:
      return MaterialPageRoute(
        builder: (context) => HutSuaInput(),
      );
    case CanhBaoChamScreen.routeName:
      final currentIndex = settings.arguments as int;
      return SlideLeftRoute(
        page: CanhBaoChamScreen(currentIndex: currentIndex),
      );
    case GiaoDucGioiTinhScreen.routeName:
      final maNguoiDung = settings.arguments as String;
      return SlideLeftRoute(
        page: GiaoDucGioiTinhScreen(maNguoiDung: maNguoiDung),
      );
    case ProductScreen.routeName:
      final title = settings.arguments as String;
      return SlideLeftRoute(
        page: ProductScreen(appbarTitle: title),
      );
    case MainStoreScreen.routeName:
      final isBack = settings.arguments as bool;
      return SlideLeftRoute(
        page: MainStoreScreen(isBack: isBack),
      );
    case StoreProductItemDetail.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final product = arguments['product'];
      final type = arguments['type'];
      return SlideLeftRoute(
        page: StoreProductItemDetail(
          product: product,
          type: type,
        ),
      );
    case StoreCartScreen.routeName:
      final isShowHome = settings.arguments as bool;
      return SlideLeftRoute(
        page: StoreCartScreen(isShowHome: isShowHome),
      );
    case StoreCartPayment.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final products = arguments['products'];
      final locals = arguments['locals'];
      final voucherType = arguments['voucherType'];
      return SlideLeftRoute(
        page: StoreCartPayment(
          products: products,
          locals: locals,
          voucherType: voucherType,
        ),
      );
    case StoreCartQRcode.routeName:
      final order = settings.arguments as Order;
      return SlideLeftRoute(
        page: StoreCartQRcode(order: order),
      );
    case ShippingInfo.routeName:
      return SlideLeftRoute(
        page: ShippingInfo(),
      );
    case ShippingUpdate.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final address = arguments['products'];
      final length = arguments['length'];
      return SlideLeftRoute(
        page: ShippingUpdate(
          address: address,
          length: length,
        ),
      );
    case StoreVoucherScreen.routeName:
      return SlideLeftRoute(
        page: StoreVoucherScreen(),
      );
    case StoreOrderSuccess.routeName:
      return SlideLeftRoute(
        page: StoreOrderSuccess(),
      );
    case StoreOrderStatusScreen.routeName:
      return SlideLeftRoute(
        page: StoreOrderStatusScreen(),
      );
    case StoreOrderHistoryScreen.routeName:
      return SlideLeftRoute(
        page: StoreOrderHistoryScreen(),
      );
    case StoreOrderDetailScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final order = arguments['order'];
      final orders = arguments['orders'];
      final index = arguments['index'];
      return SlideLeftRoute(
        page: StoreOrderDetailScreen(
          index: index,
          order: order,
          orders: orders,
        ),
      );
    case StoreOrderAddressScreen.routeName:
      return SlideLeftRoute(
        page: StoreOrderAddressScreen(),
      );
    case StoreDiscountProductScreen.routeName:
      final products = settings.arguments as List<Product>;
      return SlideLeftRoute(
        page: StoreDiscountProductScreen(products: products),
      );
    case StoreProductSearchScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final search = arguments['search'];
      final title = arguments['title'];
      final isSearch = arguments['isSearch'];
      return SlideLeftRoute(
        page: StoreProductSearchScreen(
          search: search,
          title: title,
          isSearch: isSearch,
        ),
      );
    case KichSuaQRCode.routeName:
      return SlideLeftRoute(
        page: KichSuaQRCode(),
      );
    case KichSuaDocument.routeName:
      return SlideLeftRoute(
        page: KichSuaDocument(),
      );
    case KichSuaVideo.routeName:
      final video = settings.arguments as PostModel;
      return SlideLeftRoute(
        page: KichSuaVideo(video: video),
      );
    case KichSuaQRCodeScanScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => KichSuaQRCodeScanScreen(),
      );
    case BlogPhase3Screen.routeName:
      final type = settings.arguments as BlogType;
      return MaterialPageRoute(
        builder: (context) => BlogPhase3Screen(type: type),
      );
    case WebviewScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final title = arguments['title'];
      final url = arguments['url'];
      return SlideLeftRoute(
        page: WebviewScreen(
          title: title,
          url: url,
        ),
      );
    case PdfView.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final title = arguments['title'];
      final url = arguments['url'];
      return SlideLeftRoute(
        page: PdfView(
          title: title,
          url: url,
        ),
      );
    case ReminderDetail.routeName:
      final item = settings.arguments as NotificationModel;
      return SlideLeftRoute(
        page: ReminderDetail(item: item),
      );
    case PhotoPickerScrenn.routeName:
      return SlideLeftRoute(
        page: PhotoPickerScrenn(),
      );
    default:
      final nguoiDung = settings.arguments as NguoiDung;
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: MainScreen(nguoiDung: nguoiDung),
        ),
      );
  }
}
