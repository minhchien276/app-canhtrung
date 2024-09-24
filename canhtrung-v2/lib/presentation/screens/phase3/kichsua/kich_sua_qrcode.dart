import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/kichsua/kick_sua_document.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/home/home_tabbar.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_ovumb_app_version1/services/permission/permission.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class KichSuaQRCode extends StatefulWidget {
  static const routeName = 'kich-sua-qrcode-screen';
  const KichSuaQRCode({super.key});

  @override
  State<KichSuaQRCode> createState() => _KichSuaQRCodeState();
}

class _KichSuaQRCodeState extends State<KichSuaQRCode> {
  @override
  void initState() {
    context.read<MilkBloc>().add(CheckQRExistEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _permission = PermissionHandler();
    final size = MediaQuery.of(context).size;
    return BlocBuilder<MilkBloc, MilkState>(
      builder: (context, state) {
        if (state.unlock == true) {
          return KichSuaDocument();
        }
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  Flexible(child: Image.asset(ImageApp.kichSuaQrCodeBg)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        TitleText(
                          text: 'Quét mã để nhận',
                          fontWeight: FontWeight.w700,
                          size: 24,
                          color: rose400,
                        ),
                        12.verticalSpace,
                        TitleText(
                          text:
                              'Cẩm nang kích sữa khoa học, video hướng dẫn kích sữa cùng 20+ thực đơn lợi sữa, đặc sữa cho mẹ!',
                          fontWeight: FontWeight.w400,
                          size: 16,
                          color: grey700,
                          textAlign: TextAlign.center,
                          maxLines: 5,
                        ),
                        12.verticalSpace,
                        TitleText(
                          text:
                              'Lưu ý: Thời hạn sử dụng mã QR là 10 ngày kể từ ngày quét',
                          fontWeight: FontWeight.w500,
                          size: 12,
                          color: rose400,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  30.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: KSubmitButton(
                      text: 'Quét mã QR',
                      icon: ImageApp.qrIcon,
                      size: Size(size.width, 50),
                      onTap: () async {
                        try {
                          await _permission.cameraRequest(context);
                          if (!context.mounted) return;
                          context.pushNamed(KichSuaQRCodeScanScreen.routeName);
                        } catch (e) {
                          showSettingDialog(context, e.toString());
                        }
                      },
                      // onTap: () => Navigator.pushNamed(
                      //     context, KichSuaQRCodeScanScreen.routeName),
                    ),
                  ),
                  30.verticalSpace,
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).viewPadding.top,
                child: kBackButton(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class KichSuaQRCodeScanScreen extends StatefulWidget {
  static const routeName = 'kichsua-qrcode-screen';
  const KichSuaQRCodeScanScreen({super.key});

  @override
  State<KichSuaQRCodeScanScreen> createState() =>
      _KichSuaQRCodeScanScreenState();
}

class _KichSuaQRCodeScanScreenState extends State<KichSuaQRCodeScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool check = false;
  int preventSpam = 0;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    result = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (result != null && !check && preventSpam < 10) {
      check = true;
      preventSpam++;
      context.read<MilkBloc>().add(InsertQrSua(qrCode: result!.code!));
    }
    return Scaffold(
      body: BlocConsumer<MilkBloc, MilkState>(
        listener: (context, state) {
          if (state.status == LoadedStatus.failure) {
            Future.delayed(Duration(seconds: 3), () {
              check = false;
            });
          } else if (state.status == LoadedStatus.succes &&
              state.message != null) {
            showToast(context, state.message ?? '');
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: buildQrView(context, screenSize),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Image.asset(
                      'assets/icons/back_button.png',
                      color: whiteColor,
                      scale: 3,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.all(30),
                  child: IconButton(
                    onPressed: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    },
                    icon: FutureBuilder(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        return Image.asset(
                          snapshot.data == null
                              ? 'assets/icons/flash_off.png'
                              : snapshot.data != null // snapshot.data!
                                  ? 'assets/icons/flash_on.png'
                                  : 'assets/icons/flash_off.png',
                          color: whiteColor,
                          scale: 3,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildQrView(BuildContext context, Size screenSize) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: rose500,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: screenSize.width * 0.6,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }
}
