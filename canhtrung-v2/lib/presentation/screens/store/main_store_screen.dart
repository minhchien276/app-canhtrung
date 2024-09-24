import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/slider/slider_repository.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/store/store_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/store/store_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/store/store_state.dart';
import 'package:flutter_ovumb_app_version1/main.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/main_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase2/phase2_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/home_phase3_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_cart_icon.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/cart/store_cart_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/order/store_order_address_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/order/store_order_history_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/order/store_order_status_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/product/store_product_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_menu_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_search_input.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/store/widgets/store_slider.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/shimmer/store_home_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainStoreScreen extends StatefulWidget {
  static const routeName = 'main-store-screen';
  final bool isBack;
  const MainStoreScreen({
    super.key,
    required this.isBack,
  });

  @override
  State<MainStoreScreen> createState() => _MainStoreScreenState();
}

class _MainStoreScreenState extends State<MainStoreScreen> with RouteAware {
  late FocusNode _focusNode;
  final ScrollController _scrollController = ScrollController();

  List<String> images = [
    'assets/stores/menu_icon1.png',
    'assets/stores/menu_icon2.png',
    'assets/stores/menu_icon3.png',
    'assets/stores/menu_icon4.png',
  ];
  List<String> titles = [
    'Trạng thái\nđơn hàng',
    'Lịch sử\nđơn hàng',
    'Địa chỉ\ngiao hàng',
    'Thông tin\nthanh toán',
  ];

  List<Product> searchs = [];
  bool isShowSearch = true;

  @override
  void initState() {
    // _focusNode.addListener(() {
    sliderRepository.add(true);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
    context.read<StoreBloc>().add(HomeStoreEvent());
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _focusNode.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    double scrollPosition = _scrollController.position.pixels;

    // Bắt sự kiện khi cuộn qua vị trí 300
    if (scrollPosition > 100) {
      isShowSearch = false;
      setState(() {});
      // Thực hiện các hành động cần thiết khi cuộn qua vị trí 300
    } else {
      isShowSearch = true;
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void didPush() {}

  @override
  void didPopNext() {
    sliderRepository.add(true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: BuildText(
          text: 'Cửa hàng OvumB',
          style: 18.text600,
          color: rose500,
        ),
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        elevation: 3,
        centerTitle: true,
        leading: IconButton(
          color: Color(0xfffd6f8e),
          icon: Image.asset(
            'assets/icons/back_button.png',
            scale: 3.5,
          ),
          onPressed: () async {
            if (widget.isBack) {
              context.pop();
            } else {
              final id = await SharedPreferencesService().id ?? '';
              NguoiDung nguoiDung = await LocalRepository().getNguoiDung(id);
              if (nguoiDung.phase == 1 ||
                  nguoiDung.phase == 2 ||
                  nguoiDung.phase == 5) {
                context.goName(
                  MainScreen.routeName,
                  arguments: nguoiDung,
                );
              } else if (nguoiDung.phase == 3) {
                context.goName(
                  Phase2Screen.routeName,
                  arguments: {
                    'nguoiDung': nguoiDung,
                    'phase': null,
                  },
                );
              } else if (nguoiDung.phase == 4) {
                context.goName(
                  HomePhase3Scren.routeName,
                );
              }
            }
          },
        ),
        actions: [
          InkWell(
            onTap: () {
              sliderRepository.add(false);
              context.pushNamed(
                StoreCartScreen.routeName,
              );
            },
            child: StoreCartIcon(
              isPrimary: true,
            ),
          ),
        ],
      ),
      body: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          if (state is HomeStoreState) {
            return Stack(
              children: [
                Container(
                  height: size.height,
                  width: size.width,
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    controller: _scrollController,
                    children: [
                      StoreSliderScreen(sliders: state.sliders),
                      30.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (index) => InkWell(
                            onTap: () {
                              sliderRepository.add(false);
                              switch (index) {
                                case 0:
                                  context.pushNamed(
                                    StoreOrderStatusScreen.routeName,
                                  );
                                  break;
                                case 1:
                                  context.pushNamed(
                                    StoreOrderHistoryScreen.routeName,
                                  );
                                  break;
                                case 2:
                                  context.pushNamed(
                                    StoreOrderAddressScreen.routeName,
                                  );
                                  break;
                                case 3:
                                  showMessageToast(
                                    context,
                                    'Tính năng đang được phát triển',
                                  );
                                  break;
                                default:
                                  context.pushNamed(
                                    StoreOrderStatusScreen.routeName,
                                  );
                              }
                            },
                            child: StoreMenuButton(
                              title: titles[index],
                              image: images[index],
                            ),
                          ),
                        ),
                      ),
                      30.verticalSpace,
                      StoreProductScreen(productCategory: state.products),
                    ],
                  ),
                ),
                _focusNode.hasFocus
                    ? InkWell(
                        onTap: () {
                          _focusNode.unfocus();
                          setState(() {});
                        },
                        child: Container(
                          height: size.height,
                          width: size.width,
                          color: Colors.black.withOpacity(0.4),
                        ),
                      )
                    : const SizedBox(),
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: !isShowSearch ? 0.0 : 1.0,
                    child: AnimatedContainer(
                      width: size.width,
                      height: size.height, // Đây là chiều cao thay đổi
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.fastOutSlowIn,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: StoreSearchInput(
                          name: 'Tìm kiếm sản phẩm',
                          iconUrl: 'assets/stores/search.png',
                          focusNode: _focusNode,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return getShimmer(StoreHomeShimmer());
        },
      ),
    );
  }
}
