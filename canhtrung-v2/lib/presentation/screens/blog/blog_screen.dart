// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/blog/blog_shimmer.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/blogs/blog_category.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class BlogScreen extends StatefulWidget {
  final int phase;
  static const routeName = 'blog-screen';
  const BlogScreen({
    Key? key,
    required this.phase,
  }) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  bool isLoaded = false;
  List<String> title = [
    'Quan Hệ An Toàn',
    'Kiến Thức Sinh Sản',
    'Kiến Thức Tuổi Dậy Thì'
  ];

  String convertDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<MainBloc>().add(GetBlogsEvent(context, phase: widget.phase));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      endDrawer: GlobalDrawer(
        size: screenSize,
        scaffoldKey: scaffoldKey,
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: kBackButton(context),
        centerTitle: true,
        title: TitleText(
          text: title[widget.phase - 1],
          fontWeight: FontWeight.w600,
          size: 18,
          color: rose500,
        ),
        backgroundColor: whiteColor,
        shadowColor: whiteColor,
        bottomOpacity: 0.1,
        elevation: 3,
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
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          if (state.isLoading) {
            return getShimmer(BlogShimmer());
          } else {
            if (state.blogs.isEmpty) {
              return Center(
                child: BuildText(
                  text: 'Hiện tại chưa có bài viết nào',
                  style: 20.text600,
                  color: greyText,
                ),
              );
            } else {
              return Container(
                height: context.height,
                width: context.width,
                child: ListView.builder(
                  itemCount: state.blogs.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return BlogCategory(
                      type: state.blogTypes[index].type,
                      blogs: state.blogs[index].reversed.toList(),
                      isVertical: state.blogTypes[index].isVertical,
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
