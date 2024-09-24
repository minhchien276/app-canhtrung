// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/models/blog/blog.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/blogs/blog_item.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlogCategory extends StatelessWidget {
  final String type;
  final List<Blog> blogs;
  final bool isVertical;
  const BlogCategory({
    Key? key,
    required this.type,
    required this.blogs,
    required this.isVertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isVertical ? context.height : 260.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isVertical) ...[
            30.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                type,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: grey900,
                ),
              ),
            ),
            8.verticalSpace,
            Container(
              height: 180.h,
              width: context.width,
              child: ListView.builder(
                itemCount: blogs.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return BlogItem(
                    isVertical: isVertical,
                    blog: blogs[index],
                  );
                },
              ),
            ),
          ] else ...[
            Expanded(
              child: ListView.builder(
                itemCount: blogs.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return BlogItem(
                    isVertical: isVertical,
                    blog: blogs[index],
                  );
                },
              ),
            ),
            100.verticalSpace,
          ],
        ],
      ),
    );
  }
}
