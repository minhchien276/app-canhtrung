import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/tu_van/tuvanvien_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/shimmer/tvv_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class Tuvan3Screen extends StatefulWidget {
  static const routeName = 'tuvan3-screen';
  final int widgetId;
  const Tuvan3Screen({super.key, required this.widgetId});

  @override
  State<Tuvan3Screen> createState() => _Tuvan3ScreenState();
}

class _Tuvan3ScreenState extends State<Tuvan3Screen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    //shuffleModels();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<MainBloc>().add(GetTvvEvent(context));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    //OTM
    return Scaffold(
      key: scaffoldKey,
      endDrawer: GlobalDrawer(
        size: screenSize,
        scaffoldKey: scaffoldKey,
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        elevation: 3,
        title: Align(
          alignment: Alignment.center,
          child: TitleText(
            text: 'Chuyên Gia Tư Vấn',
            fontWeight: FontWeight.w600,
            size: 18,
            color: rose500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            'assets/icons/back_button.png',
            scale: 3,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => scaffoldKey.currentState!.openEndDrawer(),
            icon: Image.asset(
              'assets/icons/right_home_icon.png',
              scale: 3,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            // color: Colors.red,
            border: Border.all(color: Colors.white)),
        //margin: EdgeInsets.only(top: 25),
        //width: sizeWidth,
        child: ScrollConfiguration(
          key: PageStorageKey<String>('page'),
          behavior: ScrollBehavior(),
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (state.isLoading) {
                return getShimmer(TVVShimmer());
              } else {
                if (state.tvv.isEmpty) {
                  return Center(
                    child: BuildText(
                      text: 'Chưa có tư vấn viên nào',
                      style: 20.text600,
                      color: greyText,
                    ),
                  );
                }
                return TuVanVienScreen(listTvv: state.tvv);
              }
            },
          ),
          //child: TVVShimmer(),
        ),
      ),
    );
  }
}
