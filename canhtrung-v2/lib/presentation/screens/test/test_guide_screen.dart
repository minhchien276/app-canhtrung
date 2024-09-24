// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/test_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_manhuongdan.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kmenu_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:video_player/video_player.dart';

class TestGuideScreen extends StatefulWidget {
  static const routeName = 'test-guide-screen';
  const TestGuideScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TestGuideScreen> createState() => _TestGuideScreenState();
}

class _TestGuideScreenState extends State<TestGuideScreen> {
  @override
  void initState() {
    context.read<TestBloc>().add(TestGuideEvent(context: context));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      endDrawer: GlobalDrawer(
        size: screenSize,
        scaffoldKey: scaffoldKey,
      ),
      appBar: AppBar(
        elevation: 2,
        bottomOpacity: 0.1,
        shadowColor: whiteColor,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: BuildText(
          text: 'Hướng Dẫn Test',
          style: 17.text600,
          color: grey700,
        ),
        centerTitle: true,
        leading: kBackButton(context),
        actions: [
          kMenuButton(context,
              onTap: () => scaffoldKey.currentState!.openEndDrawer()),
        ],
      ),
      body: BlocBuilder<TestBloc, TestState>(
        builder: (context, state) {
          if (state.videos.isNotEmpty) {
            return GuidePage(
              videos: state.videos,
              images: state.images,
              onSubmit: (p0) {},
            );
          }
          return Loading();
        },
      ),
    );
  }
}

class GuidePage extends StatefulWidget {
  final List<Guide> videos;
  final List<Guide> images;
  final void Function(BuildContext) onSubmit;
  const GuidePage({
    Key? key,
    required this.videos,
    required this.images,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage>
    with AutomaticKeepAliveClientMixin {
  late final _controller;
  int _index = 0;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  void _onNextPressed(BuildContext context, bool isNext) async {
    if (isNext) {
      if (_index == 4) {
        //await _handleOpenCamera(context);
        widget.onSubmit(context);
      } else {
        setState(() {
          _index++;
        });
      }
    } else {
      if (_index == 0) {
        context.pop();
      } else {
        setState(() {
          _index--;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      child: Column(
        children: [
          20.verticalSpace,
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            height: 5.h,
            child: Row(
              children: List.generate(
                  5, (index) => _buildIndicator(index == _index, screenSize)),
            ),
          ),
          20.verticalSpace,
          Expanded(
            child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: _controller,
              allowImplicitScrolling: true,
              onPageChanged: (value) {},
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return MediaPlayer(
                  index: _index,
                  video: widget.videos[_index].link_video,
                  image: widget.images[_index].link_video,
                );
              },
            ),
          ),
          40.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                Expanded(
                  child: KSubmitButton(
                    size: Size(context.width, 40.h),
                    text: 'Quay lại',
                    onTap: () => _onNextPressed(context, false),
                    bgColor: whiteColor,
                    border: BorderSide(color: rose500),
                    textColor: rose400,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: KSubmitButton(
                    size: Size(context.width, 40.h),
                    text: _index == 4 ? 'Bắt đầu Test' : 'Tiếp tục',
                    onTap: () => _onNextPressed(context, true),
                  ),
                ),
              ],
            ),
          ),
          50.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive, Size size) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceInOut,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: isActive ? Palette.title : Palette.pageView,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MediaPlayer extends StatefulWidget {
  final int index;
  final String? video;
  final String image;
  const MediaPlayer({
    Key? key,
    required this.index,
    this.video,
    required this.image,
  }) : super(key: key);

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  bool isPlayVideo = false;
  late VideoPlayerController s1;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    s1.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MediaPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video != widget.video) {
      s1.dispose();
      initialize();
    }
  }

  void initialize() {
    setState(() {
      isPlayVideo = false;
    });
    if (widget.video != null) {
      try {
        s1 = VideoPlayerController.networkUrl(Uri.parse(widget.video!))
          ..initialize().then(
            (value) {
              s1.setLooping(true);
              if (s1.value.isInitialized && !s1.value.isPlaying) {
                isPlayVideo = true;
                s1.play();
                setState(() {});
              }
            },
          );
      } catch (e) {
        print('Error initializing video player: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          BuildText(
            text: dataManHuongDanTest[widget.index].title,
            style: 24.text700,
            color: Palette.primaryColorRose500,
            textAlign: TextAlign.center,
          ),
          10.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: BuildText(
              text: dataManHuongDanTest[widget.index].describle,
              style: 16.text500,
              color: Palette.text,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
          20.verticalSpace,
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: dataManHuongDanTest[widget.index].testEnum ==
                      TestEnum.video
                  ? isPlayVideo
                      ? AspectRatio(
                          aspectRatio: s1.value.aspectRatio,
                          child: VideoPlayer(s1),
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.image,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                  : CachedNetworkImage(
                      imageUrl: widget.image,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
