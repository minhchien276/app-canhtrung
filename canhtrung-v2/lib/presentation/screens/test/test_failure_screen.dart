// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/que_type.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/test_resutl.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_event.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:permission_handler/permission_handler.dart';

class TestFailureScreen extends StatefulWidget {
  static const routeName = 'test-failure-screen';
  final TestResult testResult;
  final QueTestType queTestType;
  final int maQuanLyQueTest;
  const TestFailureScreen({
    Key? key,
    required this.testResult,
    required this.queTestType,
    required this.maQuanLyQueTest,
  }) : super(key: key);

  @override
  State<TestFailureScreen> createState() => _TestFailureScreenState();
}

class _TestFailureScreenState extends State<TestFailureScreen> {
  int index = 0;
  String? _imagePath;
  int? lh;

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
      _onSubmit(context, blackAndWhiteImage, image);
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Color(int.parse(widget.testResult.backgroundColor)),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 400.h,
                child: Image.asset(
                  widget.testResult.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    children: [
                      BuildText(
                        text: widget.testResult.titleText,
                        style: 24.text700,
                        color: Color(int.parse(widget.testResult.textColor)),
                      ),
                      10.verticalSpace,
                      BuildText(
                        text: widget.testResult.subText,
                        style: 16.text400,
                        color: grey600,
                        maxLines: 5,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              60.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: KSubmitButton(
                  size: Size(context.width, 50.h),
                  text: 'Thử lại',
                  onTap: () => _handleOpenCamera(context),
                  bgColor: Color(int.parse(widget.testResult.backgroundColor)),
                  textColor: rose500,
                  border: BorderSide(color: rose400),
                ),
              ),
              50.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
