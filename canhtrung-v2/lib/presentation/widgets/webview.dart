// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_circle.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/constant/link.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class WebviewScreen extends StatefulWidget {
  static const routeName = 'webview-screen';
  final String? title;
  final String? url;
  const WebviewScreen({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  bool loadSuccess = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: whiteColor,
        shadowColor: whiteColor.withOpacity(0.4),
        title: TitleText(
          text: widget.title ?? 'OvumB',
          fontWeight: FontWeight.w600,
          size: 18,
          color: rose500,
          maxLines: 1,
        ),
        centerTitle: true,
        leading: kBackButton(context),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse(widget.url ?? linkOvumb),
            ),
            onLoadStart: (controller, url) {
              LoadingCircle().show(context: context);
            },
            onLoadStop: (controller, url) {
              LoadingCircle().hide();
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                log("Error ${message.toString()}");

                LoadingCircle().hide();
                loadSuccess = false;
              });
            },
            onProgressChanged: (controller, progress) {
              log('progress: ${progress.toString()}');
            },
            onLoadHttpError: (controller, url, statusCode, description) {
              print("HTTP Error $statusCode: $description");
            },
          ),
          if (!loadSuccess) ...[
            Center(
              child: TitleText(
                text: 'Truy cập thất bại\nVui lòng thử lại',
                fontWeight: FontWeight.w600,
                size: 24,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
