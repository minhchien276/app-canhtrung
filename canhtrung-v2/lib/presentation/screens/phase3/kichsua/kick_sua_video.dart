// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/post.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/chart/chart_landscape_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class KichSuaVideo extends StatefulWidget {
  static const routeName = 'kich-sua-video-screen';
  final PostModel video;
  const KichSuaVideo({
    Key? key,
    required this.video,
  }) : super(key: key);
  @override
  _KichSuaVideoState createState() => _KichSuaVideoState();
}

class _KichSuaVideoState extends State<KichSuaVideo> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  bool _muted = false;
  bool _isPlayerReady = false;
  late String idVideo;

  @override
  void initState() {
    super.initState();
    idVideo = widget.video.videoId;
    _controller = YoutubePlayerController(
      initialVideoId: idVideo,
      flags: const YoutubePlayerFlags(
        useHybridComposition: false,
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: false,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
          SystemUiOverlay.top,
        ]);
        setPortraitOrientation();
      },
      onEnterFullScreen: () {
        setLandscapeOrientation();
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller.load(idVideo);
        },
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: TitleText(
            text: 'Video kích sữa',
            fontWeight: FontWeight.w600,
            size: 18,
            color: rose500,
            maxLines: 1,
          ),
          centerTitle: true,
          leading: kBackButton(context),
        ),
        body: Container(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              player,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: rose300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.fast_rewind,
                            color: whiteColor,
                          ),
                          onPressed: _isPlayerReady
                              ? () => _controller.seekTo(Duration(
                                  seconds:
                                      _controller.value.position.inSeconds -
                                          10))
                              : null,
                        ),
                        IconButton(
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: whiteColor,
                          ),
                          onPressed: _isPlayerReady
                              ? () {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                  setState(() {});
                                }
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.fast_forward,
                            color: whiteColor,
                          ),
                          onPressed: _isPlayerReady
                              ? () => _controller.seekTo(Duration(
                                  seconds:
                                      _controller.value.position.inSeconds +
                                          10))
                              : null,
                        ),
                        IconButton(
                          icon: Icon(
                            _muted ? Icons.volume_off : Icons.volume_up,
                            color: whiteColor,
                          ),
                          onPressed: _isPlayerReady
                              ? () {
                                  _muted
                                      ? _controller.unMute()
                                      : _controller.mute();
                                  setState(() {
                                    _muted = !_muted;
                                  });
                                }
                              : null,
                        ),
                        FullScreenButton(
                          controller: _controller,
                          color: whiteColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Image.asset(Imgs.kichsuaBg),
                      ),
                      ListView(
                        children: [
                          TitleText(
                            text: (widget.video.title ?? '').toUpperCase(),
                            fontWeight: FontWeight.w700,
                            size: 18,
                            color: rose500,
                          ),
                          TitleText(
                            text: widget.video.content ?? '',
                            fontWeight: FontWeight.w500,
                            size: 14,
                            color: grey700,
                            maxLines: 1000,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
