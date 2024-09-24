import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class ImageAnalyze {
  //crop image
  Future<img.Image> cropImage(img.Image image) async {
    // Đọc ảnh từ một tệp hoặc một nguồn dữ liệu khác
    // Tính toán kích thước mới dựa trên tỉ lệ 1/5 chiều rộng và 2/5 chiều dài
    final int newWidth = image.width ~/ 6;
    final int newHeight = image.height ~/ 3;

    // Tính toán vị trí bắt đầu cắt sao cho tâm của ảnh cắt trùng với tâm của ảnh gốc
    final int startX = (image.width - newWidth) ~/ 2;
    final int startY = (image.height - newHeight) ~/ 2;

    // Cắt ảnh theo kích thước mới và vị trí bắt đầu
    final img.Image croppedImage = img.copyCrop(
      image,
      startX,
      startY,
      newWidth,
      newHeight,
    );
    return croppedImage;
  }

  // tách ảnh ra làm 3 phần bằng nhau
  Future<int?> splitImage(img.Image inputImage) async {
    try {
      img.Image cropImage = await ImageAnalyze().cropImage(inputImage);
      List<Color> listColor = [];
      final int width = cropImage.width;
      final int height = cropImage.height;
      final int splitHeight =
          height ~/ 3; // Chia thành 3 phần bằng nhau theo hàng ngang

      for (int i = 0; i < 3; i++) {
        final img.Image splitImage =
            img.copyCrop(cropImage, 0, i * splitHeight, width, splitHeight);
        Color color = await getAverageColorFromImage(splitImage);
        listColor.add(color);
      }
      int accuracy = await calculateLHColor(listColor);
      return accuracy;
    } catch (e) {
      return null;
    }
  }

  //lấy dải màu trung bình
  Future<Color> getAverageColorFromImage(img.Image image) async {
    int totalRed = 0;
    int totalGreen = 0;
    int totalBlue = 0;
    int pixelCount = 0;

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixelColor = image.getPixel(x, y);
        totalRed += img.getRed(pixelColor);
        totalGreen += img.getGreen(pixelColor);
        totalBlue += img.getBlue(pixelColor);
        pixelCount++;
      }
    }

    final averageRed = totalRed ~/ pixelCount;
    final averageGreen = totalGreen ~/ pixelCount;
    final averageBlue = totalBlue ~/ pixelCount;

    return Color.fromRGBO(averageRed, averageGreen, averageBlue, 1.0);
  }

  // tính độ chênh lệch giữa 2 màu
  double calculateRGBDistance(Color color1, Color color2) {
    final r1 = color1.red;
    final g1 = color1.green;
    final b1 = color1.blue;
    final r2 = color2.red;
    final g2 = color2.green;
    final b2 = color2.blue;

    final deltaR = r1 - r2;
    final deltaG = g1 - g2;
    final deltaB = b1 - b2;

    return sqrt(deltaR * deltaR + deltaG * deltaG + deltaB * deltaB);
  }

  //tính độ LH theo color
  Future<int> calculateLHColor(List<Color> list) async {
    //kiểm tra giải màu trắng với vạch T
    int check = calculateRGBDistance(list[0], list[1]).round();

    // dải màu T so với C
    double x1 = calculateRGBDistance(list[0], list[2]);

    //dải màu trắng so với C
    double x2 = calculateRGBDistance(list[1], list[2]);

    int res = ((x2 - x1) / x2 * 100).round();

    int currentLH = res;
    int checkLH = check;
    if (currentLH >= 0 && currentLH <= 1) {
      currentLH = 3;
    } else if (currentLH > 80) {
      currentLH = 80;
    } else if (currentLH < 0) {
      if (checkLH > 40) {
        currentLH = 80;
      } else if (checkLH <= 3) {
        currentLH = 3;
      } else {
        currentLH = checkLH;
      }
    }

    return currentLH;
  }

  //kiểm tra kích thước ảnh kích thước
  Future<List<int>> getImageDimensions(String imagePath) async {
    File file = File(imagePath);

    if (file.existsSync()) {
      // Đọc dữ liệu của tệp tin hình ảnh
      List<int> imageData = await file.readAsBytes();

      // Đọc kích thước của hình ảnh
      img.Image? image = img.decodeImage(imageData);
      int width = image?.width ?? 0;
      int height = image?.height ?? 0;

      return [width, height];
    } else {
      return [-1, -1]; // Trả về [-1, -1] nếu tệp tin không tồn tại
    }
  }
}
