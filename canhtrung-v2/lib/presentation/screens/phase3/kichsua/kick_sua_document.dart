// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_ovumb_app_version1/data/models/phase3/post.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/kichsua/kick_sua_video.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/network_image.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/pdf_view.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/webview.dart';

class KichSuaDocument extends StatefulWidget {
  static const routeName = 'kich-sua-document-screen';
  KichSuaDocument({
    Key? key,
  }) : super(key: key);

  @override
  State<KichSuaDocument> createState() => _KichSuaDocumentState();
}

class _KichSuaDocumentState extends State<KichSuaDocument>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: whiteColor,
      key: scaffoldKey,
      endDrawer: GlobalDrawer(
        size: size,
        scaffoldKey: scaffoldKey,
      ),
      body: BlocBuilder<MilkBloc, MilkState>(
        builder: (context, state) {
          return Stack(
            children: [
              Positioned(
                top: 0,
                child: SizedBox(
                  height: size.height * 0.25,
                  width: size.width,
                  child: Image.asset(
                    Imgs.phase4HeaderLogoBg,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).viewPadding.top,
                child: SizedBox(
                  height: kToolbarHeight,
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Image.asset(
                          'assets/buttons/back.png',
                          scale: 3,
                          color: rose25,
                        ),
                      ),
                      TitleText(
                        text: 'Cẩm nang kích sữa & lợi sữa',
                        fontWeight: FontWeight.w600,
                        size: 18,
                        color: rose25,
                      ),
                      IconButton(
                        onPressed: () =>
                            scaffoldKey.currentState!.openEndDrawer(),
                        icon: Image.asset(
                          'assets/buttons/menu.png',
                          scale: 3,
                          color: rose25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: size.width,
                margin: EdgeInsets.only(
                  top: size.height * 0.2,
                ),
                decoration: BoxDecoration(color: Colors.transparent),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 24),
                        height: 55,
                        decoration: BoxDecoration(
                          color: grey100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TabBar(
                          controller: tabController,
                          physics: ClampingScrollPhysics(),
                          padding: EdgeInsets.all(6),
                          unselectedLabelColor: grey400,
                          labelColor: grey700,
                          indicatorColor: whiteColor,
                          dividerColor: Colors.transparent,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Tab(
                              text: 'Cẩm nang kích sữa',
                            ),
                            Tab(
                              text: 'Video kích sữa',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            PostPage(posts: state.posts ?? []),
                            VideoPage(posts: state.videos ?? []),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PostPage extends StatefulWidget {
  final List<PostModel> posts;
  const PostPage({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  void initState() {
    context.read<MilkBloc>().add(GetPostsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: widget.posts.isEmpty
          ? Center(
              child: TitleText(
                text: 'Chưa có dữ liệu',
                fontWeight: FontWeight.w600,
                size: 20,
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 30),
              shrinkWrap: true,
              itemCount: widget.posts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: () {
                      if (widget.posts[index].isPdf()) {
                        Navigator.pushNamed(
                          context,
                          PdfView.routeName,
                          arguments: {
                            'title': widget.posts[index].title,
                            'url': widget.posts[index].link,
                          },
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          WebviewScreen.routeName,
                          arguments: {
                            'title': widget.posts[index].title,
                            'url': widget.posts[index].link,
                          },
                        );
                      }
                    },
                    splashColor: grey200,
                    child: Ink(
                      child: Container(
                        height: 120,
                        child: Row(
                          children: [
                            SizedBox(
                              child: networkImageWithCached(
                                size: Size(77, 120),
                                url: widget.posts[index].image,
                                borderRadius: 0,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: TitleText(
                                      text: widget.posts[index].title ?? '',
                                      fontWeight: FontWeight.w700,
                                      size: 14,
                                      color: grey700,
                                    ),
                                  ),
                                  Flexible(
                                    child: TitleText(
                                      text: widget.posts[index].content ?? '',
                                      fontWeight: FontWeight.w500,
                                      size: 14,
                                      color: grey400,
                                      maxLines: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class VideoPage extends StatefulWidget {
  final List<PostModel> posts;
  const VideoPage({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  void initState() {
    context.read<MilkBloc>().add(GetVideosEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: widget.posts.isEmpty
          ? Center(
              child: TitleText(
                text: 'Chưa có dữ liệu',
                fontWeight: FontWeight.w600,
                size: 20,
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 30),
              itemCount: widget.posts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      KichSuaVideo.routeName,
                      arguments: widget.posts[index],
                    ),
                    splashColor: grey200,
                    child: Ink(
                      child: Container(
                        height: 90,
                        child: Row(
                          children: [
                            SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  networkImageWithCached(
                                    size: Size(90, 90),
                                    url: widget.posts[index].image,
                                    borderRadius: 16,
                                  ),
                                  Container(
                                    height: 90,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.black26,
                                    ),
                                  ),
                                  Image.asset(
                                    IconApp.pause,
                                    scale: 3,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: TitleText(
                                      text: widget.posts[index].title ?? '',
                                      fontWeight: FontWeight.w700,
                                      size: 14,
                                      color: grey700,
                                    ),
                                  ),
                                  Flexible(
                                    child: TitleText(
                                      text: widget.posts[index].content ?? '',
                                      fontWeight: FontWeight.w500,
                                      size: 14,
                                      color: grey400,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
