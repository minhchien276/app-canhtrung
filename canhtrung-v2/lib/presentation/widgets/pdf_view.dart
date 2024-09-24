// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {
  static const routeName = 'pdf-view-screen';
  final String? title;
  final String? url;
  const PdfView({
    Key? key,
    this.title,
    this.url,
  }) : super(key: key);

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: whiteColor,
        shadowColor: whiteColor.withOpacity(0.4),
        title: TitleText(
          text: widget.title ?? '',
          fontWeight: FontWeight.w600,
          size: 18,
          color: rose500,
          maxLines: 1,
        ),
        centerTitle: true,
        leading: kBackButton(context),
      ),
      body: SfPdfViewer.network(widget.url ?? ''),
    );
  }
}
