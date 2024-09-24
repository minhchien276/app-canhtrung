// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_ovumb_app_version1/data/models/blog/blog.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/network_image.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/webview.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';

class BlogItem extends StatelessWidget {
  final Blog blog;
  final bool isVertical;
  const BlogItem({
    Key? key,
    required this.blog,
    required this.isVertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String convertDate(DateTime date) {
      return '${date.day}/${date.month}/${date.year}';
    }

    return GestureDetector(
      onTap: () => context.pushNamed(
        WebviewScreen.routeName,
        arguments: {
          'title': blog.title,
          'url': blog.link,
        },
      ),
      child: Container(
        height: isVertical ? null : 150.h,
        width: isVertical ? null : 350.w,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        margin: EdgeInsets.only(
            top: 10.h, bottom: 10.h, left: 20.w, right: isVertical ? 20.w : 0),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: grey300.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: networkImageWithCached(
                size: Size(160, 130),
                url: blog.image,
                borderRadius: 0,
              ),
            ),
            Expanded(
              child: Container(
                height: 130,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BuildText(
                      text: blog.title,
                      style: 14.text700,
                      color: grey700,
                    ),
                    BuildText(
                      text: blog.content,
                      style: 12.text500,
                      color: grey500,
                    ),
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BuildText(
                          text: convertDate(blog.date),
                          style: 10.text500,
                          color: rose400,
                        ),
                        Image.asset(
                          'assets/icons/blog_next.png',
                          scale: 3,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
