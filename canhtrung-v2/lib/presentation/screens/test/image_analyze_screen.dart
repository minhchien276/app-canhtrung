// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/que_type.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_failure_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_guide_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_result_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kmenu_button.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class ImageAnalyzeScreen extends StatefulWidget {
  static const routeName = 'image-analyze-screen';
  final int maQuanLyQueTest;
  final QueTestType queTestType;
  final List<Guide> videos;
  final List<Guide> images;
  const ImageAnalyzeScreen({
    Key? key,
    required this.maQuanLyQueTest,
    required this.queTestType,
    required this.videos,
    required this.images,
  }) : super(key: key);

  @override
  State<ImageAnalyzeScreen> createState() => _ImageAnalyzeScreenState();
}

class _ImageAnalyzeScreenState extends State<ImageAnalyzeScreen> {
  String? _imagePath;
  bool isCheckResult = false;

  Future<void> _handleOpenCamera(BuildContext context) async {
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }
    if (!isCameraGranted) {
      return;
    }

    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

    try {
      await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: false,
        androidScanTitle: 'Quét que Test',
        androidCropTitle: 'Quét que Test',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      _imagePath = imagePath;
      File image = File(_imagePath!);
      img.Image colorImage = img.decodeImage(image.readAsBytesSync())!;
      img.Image blackAndWhiteImage = img.grayscale(colorImage);

      if (!isCheckResult) {
        _onSubmit(context, blackAndWhiteImage, image);
      }
    } catch (e) {
      print('lỗi $e');
    }
  }

  void _onSubmit(
    BuildContext context,
    img.Image image,
    File file,
  ) {
    context.read<TestBloc>().add(TestSubmitLHEvent(
        context: context,
        image: image,
        maQuanLyQueTest: widget.maQuanLyQueTest,
        queTestType: widget.queTestType,
        file: file));
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    Size screenSize = MediaQuery.of(context).size;
    return BlocConsumer<TestBloc, TestState>(
      listener: (context, state) {
        if (state.testStatus == TestStatus.success) {
          context.goName(
            TestResultScreen.routeName,
            arguments: state.testResult,
          );
        } else if (state.testStatus == TestStatus.failure) {
          context.pushNamed(
            TestFailureScreen.routeName,
            arguments: {
              'testResult': state.testResult,
              'maQuanLyQueTest': widget.maQuanLyQueTest,
              'queTestType': widget.queTestType,
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          endDrawer: GlobalDrawer(
            size: screenSize,
            scaffoldKey: scaffoldKey,
          ),
          appBar: AppBar(
            shadowColor: whiteColor,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: BuildText(
              text: 'Hướng Dẫn Test',
              style: 17.text600,
              color: rose500,
            ),
            leading: kBackButton(context),
            actions: [
              kMenuButton(context,
                  onTap: () => scaffoldKey.currentState!.openEndDrawer()),
            ],
          ),
          body: GuidePage(
            videos: state.videos,
            images: state.images,
            onSubmit: (p0) async => await _handleOpenCamera(context),
          ),
        );
      },
    );
  }
}
