import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Future<File> resizeImage(File imageFile, int maxSize) async {
  const int quality = 80;
  print('imageFile $imageFile');
  img.Image? image = img.decodeImage(await imageFile.readAsBytes());
  print('image $image');

  if (image != null) {
    double ratio = image.width / image.height;
    int targetWidth = image.width;
    int targetHeight = image.height;
    if (image.width > maxSize || image.height > maxSize) {
      if (ratio > 1) {
        targetWidth = maxSize;
        targetHeight = (maxSize / ratio).round();
      } else {
        targetHeight = maxSize;
        targetWidth = (maxSize * ratio).round();
      }
    }
    // Resize
    img.Image resizedImage =
        img.copyResize(image, width: targetWidth, height: targetHeight);

    int timePath = DateTime.now().millisecondsSinceEpoch;

    File resizedFile = File(
        '${(await getTemporaryDirectory()).path}/${timePath}resized_image.jpg');
    await resizedFile
        .writeAsBytes(img.encodeJpg(resizedImage, quality: quality));

    return resizedFile;
  }
  return imageFile;
}

getFileSize(String filepath, int decimals) async {
  var file = File(filepath);
  int bytes = await file.length();
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}
