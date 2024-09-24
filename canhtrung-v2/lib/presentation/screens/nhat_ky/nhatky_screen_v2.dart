// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_cubit.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/cau_hoi/cauhoi_widget.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/luong_kinh/luongkinh_widget.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/nhatky_button.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';

class NhatkyScreenV2 extends StatefulWidget {
  static const routeName = 'nhat-ky-v2-screen';
  final DateTime date;

  const NhatkyScreenV2({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  State<NhatkyScreenV2> createState() => _NhatkyScreenV2State();
}

//index =
class _NhatkyScreenV2State extends State<NhatkyScreenV2> {
  String celsius = "\u00B0";

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    context.read<NhatKyCubit>().fecthList(widget.date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    //scroll
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
      child: Scaffold(
        key: scaffoldKey,
        endDrawer: GlobalDrawer(
          size: screenSize,
          scaffoldKey: scaffoldKey,
        ),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          bottomOpacity: 0.1,
          centerTitle: true,
          shadowColor: whiteColor,
          title: Text(
            'Ngày ${convertDateTime(widget.date)}',
            style: const TextStyle(
              color: Color(0xff333e52),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              decoration: TextDecoration.none,
            ),
          ),
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
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
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            LuongKinhWidget(),
            const SizedBox(height: 10),
            CauHoiWidget(),
          ],
        ),
        bottomNavigationBar: Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: NhatKyButton(
            textButton: 'Lưu thông tin',
            onTap: () => context.read<NhatKyCubit>().saveData(context),
          ),
        ),
      ),
    );
  }
}
