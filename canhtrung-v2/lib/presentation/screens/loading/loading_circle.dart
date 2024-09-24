import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_screen_controller.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';

class LoadingCircle {
  factory LoadingCircle() => _shared;
  static final LoadingCircle _shared = LoadingCircle._sharedInstance();
  LoadingCircle._sharedInstance();

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
  }) {
    controller = showOverlay(
      context: context,
    );
  }

  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
  }) {
    final state = Overlay.of(context);
    final size = MediaQuery.of(context).size;

    final overlay = OverlayEntry(builder: (context) {
      return Center(
        child: Container(
          height: size.height,
          width: size.width,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  color: Colors.black26,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator(
                    color: whiteColor,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });

    state.insert(overlay);

    return LoadingScreenController(close: () {
      overlay.remove();
      return true;
    }, update: (text) {
      return true;
    });
  }
}
