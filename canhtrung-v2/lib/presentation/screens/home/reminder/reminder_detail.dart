// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/models/notification/notification.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderDetail extends StatelessWidget {
  static const String routeName = 'reminder-detail';

  final NotificationModel item;
  const ReminderDetail({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BuildText(
          text: 'Chi Tiết Thông Báo',
          color: grey700,
          style: 18.text600,
        ),
        centerTitle: true,
        leading: kBackButton(context),
        backgroundColor: whiteColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            BuildText(
              text: item.title ?? '',
              style: 18.text600,
              maxLines: 10,
              color: Colors.black,
            ),
            10.verticalSpace,
            BuildText(
              text: item.createdAt!.formatDateTime(),
              style: 12.text600,
              maxLines: 10,
              color: grey500,
            ),
            30.verticalSpace,
            BuildText(
              text: item.content ?? '',
              style: 14.text600,
              maxLines: 1000,
              color: grey700,
            ),
          ],
        ),
      ),
    );
  }
}
