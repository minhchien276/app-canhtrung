import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScreen extends StatefulWidget {
  static const routeName = 'qrcode-screen';
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool check = false;

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

  _onSubmit() {
    if (result?.code != null && !check) {
      context
          .read<TestBloc>()
          .add(TestQRSubmitEvent(qrcode: result!.code!, context: context));
      check = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return BlocListener<TestBloc, TestState>(
      listener: (context, state) async {
        if (!state.isLoading) {
          await Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              check = false;
            });
          });
        }
      },
      child: Scaffold(
        body: Stack(
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
                child: kBackButton(context),
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
                            ? IconApp.flashOff
                            : snapshot.data != null
                                ? IconApp.flashOn
                                : IconApp.flashOff,
                        color: whiteColor,
                        scale: 3,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
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
        _onSubmit();
      });
    });
  }
}
