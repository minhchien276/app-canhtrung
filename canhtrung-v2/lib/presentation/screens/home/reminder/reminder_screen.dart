import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/notification/notification.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/notification/notifcation_state.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/notification/notification_cubit.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/shimmer/reminder_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/services/notification/fcm_notification_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderScreen extends StatefulWidget {
  static const String routeName = 'reminder-screen';
  const ReminderScreen({super.key});
  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<NotificationCubit>(context).fetch();
    });
    super.initState();
  }

  final _navigator = NotificationNavigator();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: BuildText(
          text: 'Nhắc Nhở Quan Trọng',
          color: grey700,
          style: 18.text600,
        ),
        centerTitle: true,
        leading: kBackButton(context),
        backgroundColor: whiteColor,
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.isLoading && state.notifications.isEmpty) {
            return getShimmer(const ReminderShimmer());
          } else {
            if (state.notifications.isEmpty) {
              return Center(
                child: BuildText(
                  text: 'Chưa có thông báo',
                  style: 16.text600,
                ),
              );
            }
            return Stack(
              children: [
                ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    children: List.generate(
                      state.data.length,
                      (index) => _buidNotiByDate(
                        date: state.data.keys.toList()[index],
                        notis: state.data.values.toList()[index],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -1,
                  height: 50,
                  child: Container(
                    height: size.height * 0.075,
                    width: size.width,
                    //color: rose600.withOpacity(0.1),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          whiteColor.withOpacity(1),
                          whiteColor.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  _buidNotiByDate({
    required DateTime date,
    required List<NotificationModel> notis,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: TitleText(
            text: date.betweenNow(),
            fontWeight: FontWeight.w500,
            size: 16,
            color: grey600,
          ),
        ),
        10.verticalSpace,
        Column(
          children: List.generate(
              notis.length, (index) => _buildNotiItem(notis[index])),
        ),
        16.verticalSpace,
      ],
    );
  }

  _buildNotiItem(NotificationModel item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: () => _navigator.handleNextPressed(
          context,
          item.type,
          item.applicationId,
          notiId: item.id,
        ),
        child: Container(
          height: 80.h,
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          width: context.width,
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 1,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Image.asset(IconApp.dot),
                20.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: BuildText(
                          text: item.title ?? '',
                          style: 14.text600,
                          color: grey700,
                          maxLines: 1,
                        ),
                      ),
                      Flexible(
                        child: BuildText(
                          text: item.content ?? '',
                          style: 12.text400,
                          maxLines: 2,
                          color: grey700,
                        ),
                      ),
                    ],
                  ),
                ),
                16.horizontalSpace,
                SizedBox(
                  width: 30.w,
                  child: BuildText(
                    text: item.createdAt!.toTime(),
                    style: 10.text400,
                    color: grey700,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
