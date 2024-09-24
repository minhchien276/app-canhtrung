import 'dart:convert';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/link.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';

class LinkProvider {
  final _dio = BaseService.instance.dio;

  // lấy links
  Future<List<Link>> getLink(int type) async {
    try {
      String link = linkGetConTrai;
      if (type == 2) {
        link = linkGetConGai;
      } else if (type == 3) {
        link = linkGetAnToan;
      } else if (type == 4) {
        link = linkGetMeBe;
      }

      List<Link> listLink = [];

      final response = await _dio.get(
        '$link',
      );
      if (response.statusCode == 200) {
        List x = response.data['data'];
        listLink = x.map((e) => Link.fromJson(jsonEncode(e))).toList();
      }
      return listLink;
    } catch (e) {
      throw 'Lỗi kết nối';
      //throw e;
    }
  }

  // lấy links video huong dan
  Future<List<Guide>?> getGuideVideos() async {
    try {
      List<Guide> listLink = [];

      final response = await _dio.get(videoGuideGetVideo);
      if (response.statusCode == 200) {
        List x = response.data['data'];
        listLink = x.map((e) => Guide.fromJson(jsonEncode(e))).toList();
      }
      return listLink;
    } catch (e) {
      return null;
    }
  }

  // lấy links image huong dan
  Future<List<Guide>?> getGuideImages() async {
    try {
      List<Guide> listLink = [];

      final response = await _dio.get(videoGuideGetImage);
      if (response.statusCode == 200) {
        List x = response.data['data'];
        listLink = x.map((e) => Guide.fromJson(jsonEncode(e))).toList();
      }
      return listLink;
    } catch (e) {
      return null;
    }
  }

  // lay link file mp3 bu me
  Future<Guide?> getGuideBuMe() async {
    try {
      final response = await _dio.get(videoGetBuMe);
      if (response.statusCode == 200) {
        List x = response.data['data'];
        return Guide.fromJson(jsonEncode(x.first));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
