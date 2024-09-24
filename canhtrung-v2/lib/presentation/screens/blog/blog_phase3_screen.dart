// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/blog_type.dart';
import 'package:flutter_ovumb_app_version1/data/models/blog/blog_list.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/blogs/blog_category.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class BlogPhase3Screen extends StatefulWidget {
  final BlogType type;
  static const routeName = 'blog-phase3-screen';
  const BlogPhase3Screen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<BlogPhase3Screen> createState() => _BlogPhase3ScreenState();
}

class _BlogPhase3ScreenState extends State<BlogPhase3Screen> {
  @override
  void initState() {
    context.read<MilkBloc>().add(GetBlogsEvent(type: widget.type));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: kBackButton(context),
        centerTitle: true,
        title: TitleText(
          text: widget.type.parseTitle(),
          fontWeight: FontWeight.w600,
          size: 18,
          color: rose500,
        ),
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        elevation: 3,
      ),
      body: BlocBuilder<MilkBloc, MilkState>(
        builder: (context, state) {
          if (state.isLoading == LoadingStatus.stop) {
            List<BlogList> blogs = (widget.type == BlogType.quanhe
                    ? state.blogsQuanHe
                    : state.blogsBiQuyet) ??
                [];
            if (blogs.isNotEmpty) {
              return Container(
                height: context.height,
                width: context.width,
                child: ListView.builder(
                  itemCount: blogs.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return BlogCategory(
                      type: blogs[index].name ?? '',
                      blogs: blogs[index].blogs,
                      isVertical: blogs[index].isVertical,
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: TitleText(
                  text: 'Chưa có bài viết',
                  fontWeight: FontWeight.w600,
                  size: 20,
                ),
              );
            }
          } else {
            return getShimmer(BlogShimmer());
          }
        },
      ),
    );
  }
}
