import 'package:flutter_ovumb_app_version1/data/models/blog/blog_list.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/choan.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/hutsua.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/phattriencon.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/post.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/trieuchung.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';

class GetQRSua extends ApiResponse<bool> {
  GetQRSua({required super.status, super.data = true});
}

class GetPosts extends ApiResponse<List<PostModel>> {
  GetPosts({required super.status, required super.data});
}

class GetBabies extends ApiResponse<List<Con>> {
  GetBabies({required super.status, required super.data});
}

class InsertBaby extends ApiResponse<Con> {
  InsertBaby({required super.status, required super.data});
}

class UpdateBaby extends ApiResponse<Con> {
  UpdateBaby({required super.status, required super.data});
}

class DeleteBaby extends ApiResponse<bool> {
  DeleteBaby({required super.status, super.data = true});
}

class GetListPhatTrien extends ApiResponse<List<PhatTrienCon>> {
  GetListPhatTrien({required super.status, required super.data});
}

class GetListTrieuChung extends ApiResponse<List<TrieuChung>> {
  GetListTrieuChung({required super.status, required super.data});
}

class GetChoAnHistory extends ApiResponse<List<ChoAn>> {
  GetChoAnHistory({required super.status, required super.data});
}

class DeleteChoAn extends ApiResponse<bool> {
  DeleteChoAn({required super.status, super.data = true});
}

class UpdateChoAn extends ApiResponse<bool> {
  UpdateChoAn({required super.status, super.data = true});
}

class GetListHutSua extends ApiResponse<List<HutSua>> {
  GetListHutSua({required super.status, required super.data});
}

class DeleteHutSua extends ApiResponse<bool> {
  DeleteHutSua({required super.status, super.data = true});
}

class UpdateHutSua extends ApiResponse<bool> {
  UpdateHutSua({required super.status, super.data = true});
}

class UpdateQRSua extends ApiResponse<bool> {
  UpdateQRSua({required super.status, super.data = true});
}

class GetBlogs extends ApiResponse<List<BlogList>> {
  GetBlogs({required super.status, required super.data});
}
