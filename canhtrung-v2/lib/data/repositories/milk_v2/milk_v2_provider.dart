import 'package:dio/dio.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/choan.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/hutsua.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/phattriencon.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/trieuchung.dart';
import 'package:flutter_ovumb_app_version1/services/models/milk_response.dart';

abstract class MilkV2Provider {
  Future<GetQRSua> getQRSua();
  Future<GetQRSua> updateQRSua(String code);

  Future<GetPosts> getPosts();
  Future<GetPosts> getVideos();

  Future<GetBabies> getBaby();
  Future<InsertBaby> insertBaby(Con con);
  Future<UpdateBaby> updateBaby(FormData data, int id);
  Future<DeleteBaby> deleteBaby(int id);
  Future<DeleteBaby> updateBabyStatus(int id);
  Future<GetListPhatTrien> insertPhattien(PhatTrienCon phatTrienCon);
  Future<GetListTrieuChung> insertTrieuchung(TrieuChung trieuChung);
  Future<GetChoAnHistory> getChoAnHistory({
    required int maCon,
    required int maLoaiChoAn,
  });
  Future<GetChoAnHistory> getChoAnHistoryByDate({
    required int maCon,
    required List<int> maLoaiChoAn,
    required DateTime date,
  });
  Future<GetChoAnHistory> insertChoAn({
    required ChoAn choAn,
  });
  Future<DeleteChoAn> deleteChoAn(int maChoAn);
  Future<UpdateChoAn> updateChoAn(ChoAn choAn);

  Future<GetListHutSua> insertHutSua(HutSua hutSua);
  Future<GetListHutSua> getListHutSua();
  Future<GetListHutSua> getListHutSuaByDate(DateTime date);

  Future<DeleteHutSua> deleteHutSua(int maHutSua);
  Future<UpdateHutSua> updateHutSua(HutSua hutSua);

  Future<GetChoAnHistory> getChoAn(int maCon, DateTime date);
  Future<GetListTrieuChung> getTrieuChung(int maCon);
  Future<GetListPhatTrien> getPhatTrien(int maCon);

  Future<UpdateQRSua> insertQrSua(String qrCode);

  Future<GetBlogs> getBlogs(String type);
}
