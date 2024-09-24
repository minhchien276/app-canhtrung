// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:io';

// import 'package:edge_detection/edge_detection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_ovumb_app_version1/logic/test/image_analyze.dart';
// import 'package:image/image.dart' as img;
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_ovumb_app_version1/data/model_manhuongdan.dart';
// import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';
// import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_bloc.dart';
// import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_event.dart';
// import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_state.dart';
// import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_dialog.dart';
// import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_result_failure_screen.dart';
// import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_result_success_screen.dart';
// import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
// import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';
// import 'package:flutter_ovumb_app_version1/presentation/widgets/drawer/global_drawer.dart';
// import 'package:flutter_ovumb_app_version1/presentation/widgets/skip/skip1.dart';
// import 'package:flutter_ovumb_app_version1/presentation/widgets/skip/skip2.dart';
// import 'package:flutter_ovumb_app_version1/presentation/widgets/skip/skip3.dart';
// import 'package:flutter_ovumb_app_version1/presentation/widgets/skip/skip4.dart';
// import 'package:flutter_ovumb_app_version1/presentation/widgets/skip/skip5.dart';
// import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

// class TestScan extends StatefulWidget {
//   const TestScan({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<TestScan> createState() => _TestScanState();
// }

// class _TestScanState extends State<TestScan> {
//   final _controller = PageController(
//     initialPage: 0,
//   );
//   int index = 0;
//   String? _imagePath;
//   int? lh;
//   List<String> images = [];
//   Widget? imageWidget;
//   final ImageAnalyze _imageAnalyze = ImageAnalyze();

//   //Mở cameca và chụp để lấy image path
//   Future<void> getImage(BuildContext context) async {
//     bool isCameraGranted = await Permission.camera.request().isGranted;
//     if (!isCameraGranted) {
//       isCameraGranted =
//           await Permission.camera.request() == PermissionStatus.granted;
//     }
//     if (!isCameraGranted) {
//       // Have not permission to camera
//       return;
//     }

//     // Generate filepath for saving
//     String imagePath = join((await getApplicationSupportDirectory()).path,
//         "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");

//     try {
//       //Make sure to await the call to detectEdge.
//       await EdgeDetection.detectEdge(
//         imagePath,
//         canUseGallery: false,
//         androidScanTitle: 'Quét que Test',
//         androidCropTitle: 'Quét que Test',
//         androidCropBlackWhiteTitle: 'Black White',
//         androidCropReset: 'Reset',
//       );
//       _imagePath = imagePath;
//       print(imagePath);
//       File image = File(_imagePath!);
//       img.Image colorImage = img.decodeImage(image.readAsBytesSync())!;

//       // Chuyển đổi ảnh màu sang đen trắng
//       img.Image blackAndWhiteImage = img.grayscale(colorImage);
//       int? lh = await _imageAnalyze.splitImage(blackAndWhiteImage);
//       print('Check lh: $lh');
//       img.Image crop = await cropImage(blackAndWhiteImage);
//       imageWidget = Image.memory(Uint8List.fromList(img.encodePng(crop)));
//       setState(() {});
//     } catch (e) {
//       print('lỗi $e');
//     }
//   }

//   Future<img.Image> cropImage(img.Image image) async {
//     // Đọc ảnh từ một tệp hoặc một nguồn dữ liệu khác
//     // Tính toán kích thước mới dựa trên tỉ lệ 1/5 chiều rộng và 2/5 chiều dài
//     final int newWidth = image.width ~/ 6;
//     final int newHeight = image.height ~/ 3;

//     // Tính toán vị trí bắt đầu cắt sao cho tâm của ảnh cắt trùng với tâm của ảnh gốc
//     final int startX = (image.width - newWidth) ~/ 2;
//     final int startY = (image.height - newHeight) ~/ 2;

//     // Cắt ảnh theo kích thước mới và vị trí bắt đầu
//     final img.Image croppedImage = img.copyCrop(
//       image,
//       startX,
//       startY,
//       newWidth,
//       newHeight,
//     );
//     return croppedImage;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//     Size screenSize = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       key: scaffoldKey,
//       endDrawer: GlobalDrawer(
//         size: screenSize,
//         scaffoldKey: scaffoldKey,
//       ),
//       appBar: AppBar(
//         elevation: 2,
//         bottomOpacity: 0.1,
//         shadowColor: whiteColor,
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: TitleText(
//           text: 'Hướng Dẫn Test',
//           fontWeight: FontWeight.w600,
//           size: 20,
//           color: rose500,
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Image.asset(
//             'assets/icons/back_button.png',
//             scale: 3,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () => scaffoldKey.currentState!.openEndDrawer(),
//             icon: Image.asset(
//               'assets/icons/right_home_icon.png',
//               scale: 3,
//             ),
//           ),
//         ],
//       ),
//       body: MediaQuery(
//         data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
//         child: Container(
//           child: Column(
//             children: [
//               // 5 cai luot luot
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   alignment: Alignment.center,
//                   width: screenSize.width * 0.89,
//                   height: screenSize.height * 0.005,
//                   //color: Colors.green,
//                   child: Row(
//                     children: [
//                       if (dataManHuongDanTest[index].id == 0) ...[
//                         Skip1Widget(),
//                       ] else if (dataManHuongDanTest[index].id == 1) ...[
//                         Skip2Widget(),
//                       ] else if (dataManHuongDanTest[index].id == 2) ...[
//                         Skip3Widget(),
//                       ] else if (dataManHuongDanTest[index].id == 3) ...[
//                         Skip4Widget(),
//                       ] else if (dataManHuongDanTest[index].id == 4) ...[
//                         Skip5Widget(),
//                       ]
//                     ],
//                   ),
//                 ),
//               ),
//               //text va video va anh
//               Expanded(
//                 flex: 11,
//                 child: Container(
//                   child: Container(
//                     // child: PageView(
//                     //   physics: NeverScrollableScrollPhysics(),
//                     //   controller: _controller,
//                     //   onPageChanged: (value) {},
//                     //   children: [
//                     //     // Page1(
//                     //     //   index: index,
//                     //     //   video: widget.videos[index].link_video,
//                     //     //   image: widget.images[index].link_video,
//                     //     // ),
//                     //     SizedBox()
//                     //   ],
//                     // ),
//                     child: imageWidget != null ? imageWidget : const SizedBox(),
//                   ),
//                 ),
//               ),
//               //2 button o duoi
//               Expanded(
//                 flex: 2,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 24),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: DecoratedBox(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(36),
//                             border: Border.all(color: Palette.title),
//                           ),
//                           child: ElevatedButton(
//                               style: ButtonStyle(
//                                 overlayColor: WidgetStatePropertyAll(
//                                     Colors.transparent),
//                                 backgroundColor: WidgetStatePropertyAll(
//                                     Colors.transparent),
//                                 shadowColor: WidgetStatePropertyAll(
//                                     Colors.transparent),
//                               ),
//                               child: Text(
//                                 'Quay lại',
//                                 style: TextStyle(
//                                   fontFamily: 'Inter',
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Palette.title,
//                                 ),
//                               ),
//                               onPressed: () {
//                                 if (index == 0) {
//                                   Navigator.of(context).pop();
//                                 }
//                                 if (index > 0) {
//                                   setState(() {
//                                     index--;
//                                   });
//                                 }
//                               }),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: DecoratedBox(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(36),
//                             gradient: LinearGradient(
//                               colors: [rose500, rose300],
//                             ),
//                           ),
//                           child: ElevatedButton(
//                             style: ButtonStyle(
//                               overlayColor:
//                                   WidgetStatePropertyAll(Colors.transparent),
//                               backgroundColor:
//                                   WidgetStatePropertyAll(Colors.transparent),
//                               shadowColor:
//                                   WidgetStatePropertyAll(Colors.transparent),
//                             ),
//                             onPressed: () async {
//                               if (index == 4) {
//                                 // man camera tiep theo
//                                 await getImage(context);
//                               }
//                               if (index < 4) {
//                                 setState(() {
//                                   index++;
//                                 });
//                               }
//                             },
//                             child: Stack(
//                               children: [
//                                 if (index == 4) ...[
//                                   Text(
//                                     'Bắt đầu Test',
//                                     style: TextStyle(
//                                       fontFamily: 'Inter',
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ] else if (index != 4) ...[
//                                   Text(
//                                     'Tiếp tục',
//                                     style: TextStyle(
//                                       fontFamily: 'Inter',
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ]
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
