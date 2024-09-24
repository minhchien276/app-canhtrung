import 'package:dio/dio.dart';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url_v2.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/blog/blog_list.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/choan.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/hutsua.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/phattriencon.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/post.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/trieuchung.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/milk_v2/milk_v2_provider.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:flutter_ovumb_app_version1/services/models/milk_response.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';

class MilkV2Repository implements MilkV2Provider {
  MilkV2Repository._();
  static final MilkV2Repository _instance = MilkV2Repository._();
  factory MilkV2Repository() => _instance;

  final _prefs = SharedPreferencesService();
  final _dio = BaseService.instance.dio;

  @override
  Future<GetQRSua> getQRSua() async {
    final response = await _dio.get(
      ApiUrlV2.qrSuaGet,
      data: {
        'maNguoiDung': _prefs.id,
      },
    );
    return GetQRSua(status: ApiResponseStatus.fromMap(response.data));
  }

  @override
  Future<GetQRSua> updateQRSua(String code) async {
    final response = await _dio.post(
      '${ApiUrlV2.qrSuaUpdate}/$code',
      data: {
        'maNguoiDung': _prefs.id,
      },
    );
    return GetQRSua(status: ApiResponseStatus.fromMap(response.data));
  }

  @override
  Future<GetPosts> getPosts() async {
    final response = await _dio.get(ApiUrlV2.tailieukichsuaGetImage);
    return GetPosts(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<PostModel>.from(
              response.data['data'].map((e) => PostModel.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetPosts> getVideos() async {
    final response = await _dio.get(ApiUrlV2.tailieukichsuaGetVideo);
    return GetPosts(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<PostModel>.from(
              response.data['data'].map((e) => PostModel.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<InsertBaby> insertBaby(Con con) async {
    final response = await _dio.post(
      ApiUrlV2.conInsert,
      data: {
        'ten': con.ten,
        'ngaySinh': con.ngaySinh.millisecondsSinceEpoch,
        'gioiTinh': con.gioiTinh,
        'maNguoiDung': _prefs.id,
        'thoiGian': DateTime.now().millisecondsSinceEpoch,
      },
    );
    return InsertBaby(
      status: ApiResponseStatus.fromMap(response.data),
      data: Con.fromMap(response.data['data']),
    );
  }

  @override
  Future<DeleteBaby> deleteBaby(int id) async {
    final response = await _dio.post(
      '${ApiUrlV2.conDelete}/$id/${_prefs.id}',
    );
    return DeleteBaby(status: ApiResponseStatus.fromMap(response.data));
  }

  @override
  Future<DeleteBaby> updateBabyStatus(int id) async {
    final response = await _dio.post(
      '${ApiUrlV2.conUpdateTrangThai}/$id/${_prefs.id}',
    );
    return DeleteBaby(status: ApiResponseStatus.fromMap(response.data));
  }

  @override
  Future<GetListPhatTrien> insertPhattien(PhatTrienCon phatTrienCon) async {
    DateTime date = DateTime(phatTrienCon.thoiGian!.year,
        phatTrienCon.thoiGian!.month, 1, 0, 0, 0, 0, 0);

    final response = await _dio.post(
      '${ApiUrlV2.phatTrienInsert}',
      data: {
        'maCon': phatTrienCon.maCon,
        'canNang': phatTrienCon.canNang,
        'chieuCao': phatTrienCon.chieuCao,
        'thoiGian': date.millisecondsSinceEpoch,
      },
    );
    return GetListPhatTrien(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<PhatTrienCon>.from(
              response.data['data'].map((e) => PhatTrienCon.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetListTrieuChung> insertTrieuchung(TrieuChung trieuChung) async {
    final response = await _dio.post(
      '${ApiUrlV2.trieuChungInsert}',
      data: {
        'dauHieu': trieuChung.dauHieu,
        'id_con': trieuChung.id_con,
      },
    );
    return GetListTrieuChung(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<TrieuChung>.from(
              response.data['data'].map((e) => TrieuChung.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetChoAnHistory> getChoAnHistory({
    required int maCon,
    required int maLoaiChoAn,
  }) async {
    final response = await _dio.get(
      '${ApiUrlV2.choanGetHistory}/$maCon',
      data: {
        'maLoaiChoAn': maLoaiChoAn,
      },
    );
    return GetChoAnHistory(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<ChoAn>.from(
              response.data['data'].map((e) => ChoAn.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetChoAnHistory> getChoAnHistoryByDate({
    required int maCon,
    required List<int> maLoaiChoAn,
    required DateTime date,
  }) async {
    final response = await _dio.get(
      '${ApiUrlV2.choanGetNgayTao}/$maCon/${date.formatStartDate().millisecondsSinceEpoch}',
      data: {
        'maLoaiChoAn': maLoaiChoAn,
      },
    );
    return GetChoAnHistory(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<ChoAn>.from(
              response.data['data'].map((e) => ChoAn.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetChoAnHistory> insertChoAn({
    required ChoAn choAn,
  }) async {
    final response = await _dio.post(
      '${ApiUrlV2.choanInsert}',
      data: {
        'maLoaiChoAn': choAn.maLoaiChoAn,
        'maCon': choAn.maCon,
        'trongLuong': choAn.trongLuong,
        'lanChoAn': choAn.lanChoAn,
        'thoiGian': choAn.thoiGian!.millisecondsSinceEpoch,
        'loaiThucPham': choAn.loaiThucPham,
        'vuTrai': choAn.vuTrai,
        'vuPhai': choAn.vuPhai,
        'ngayTao': choAn.thoiGian?.formatStartDate().millisecondsSinceEpoch,
      },
    );
    return GetChoAnHistory(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<ChoAn>.from(
              response.data['data'].map((e) => ChoAn.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<DeleteChoAn> deleteChoAn(int maChoAn) async {
    final response = await _dio.post(
      '${ApiUrlV2.choanDelete}/$maChoAn',
    );
    return DeleteChoAn(status: ApiResponseStatus.fromMap(response.data));
  }

  @override
  Future<UpdateChoAn> updateChoAn(ChoAn choAn) async {
    final response =
        await _dio.post('${ApiUrlV2.choanUpdate}/${choAn.maChoAn}', data: {
      'trongLuong': choAn.trongLuong,
      'vuTrai': choAn.vuTrai,
      'vuPhai': choAn.vuPhai,
    });
    return UpdateChoAn(status: ApiResponseStatus.fromMap(response.data));
  }

  @override
  Future<GetListHutSua> getListHutSua() async {
    final response = await _dio.get('${ApiUrlV2.hutSuaHistory}/${_prefs.id}');
    return GetListHutSua(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<HutSua>.from(
              response.data['data'].map((e) => HutSua.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetListHutSua> getListHutSuaByDate(DateTime date) async {
    final response = await _dio.get(
        '${ApiUrlV2.hutSuaGetNgayTao}/${_prefs.id}/${date.formatStartDate().millisecondsSinceEpoch}');
    return GetListHutSua(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<HutSua>.from(
              response.data['data'].map((e) => HutSua.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetListHutSua> insertHutSua(HutSua hutSua) async {
    final response = await _dio.post(
      '${ApiUrlV2.hutSuaInsert}',
      data: {
        'maNguoiDung': _prefs.id,
        'vuTrai': hutSua.vuTrai,
        'vuPhai': hutSua.vuPhai,
        'lanChoAn': hutSua.lanChoAn,
        'thoiGian': hutSua.ngayTao!.millisecondsSinceEpoch,
        'ngayTao': hutSua.ngayTao!.formatStartDate().millisecondsSinceEpoch,
      },
    );
    return GetListHutSua(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<HutSua>.from(
              response.data['data'].map((e) => HutSua.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<DeleteHutSua> deleteHutSua(int maHutSua) async {
    final response = await _dio.post(
      '${ApiUrlV2.hutSuaDelete}/$maHutSua',
    );
    return DeleteHutSua(status: ApiResponseStatus.fromMap(response.data));
  }

  @override
  Future<UpdateHutSua> updateHutSua(HutSua hutSua) async {
    final response = await _dio.post(
      '${ApiUrlV2.hutSuaUpdate}/${hutSua.id}',
      data: {
        'vuTrai': hutSua.vuTrai,
        'vuPhai': hutSua.vuPhai,
      },
    );
    return UpdateHutSua(status: ApiResponseStatus.fromMap(response.data));
  }

  @override
  Future<GetBabies> getBaby() async {
    final response = await _dio.get('${ApiUrlV2.conGet}/${_prefs.id}');
    return GetBabies(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<Con>.from(
              response.data['data'].map((e) => Con.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetChoAnHistory> getChoAn(int maCon, DateTime date) async {
    final response = await _dio.get(
        '${ApiUrlV2.choanGet}/$maCon/${date.formatStartDate().millisecondsSinceEpoch}');
    return GetChoAnHistory(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<ChoAn>.from(
              response.data['data'].map((e) => ChoAn.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetListPhatTrien> getPhatTrien(int maCon) async {
    final response = await _dio.get('${ApiUrlV2.phatTrienGet}/$maCon');
    return GetListPhatTrien(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<PhatTrienCon>.from(
              response.data['data'].map((e) => PhatTrienCon.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<GetListTrieuChung> getTrieuChung(int maCon) async {
    final response = await _dio.get('${ApiUrlV2.trieuChungGet}/$maCon');
    return GetListTrieuChung(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<TrieuChung>.from(
              response.data['data'].map((e) => TrieuChung.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<UpdateQRSua> insertQrSua(String qrCode) async {
    final response = await _dio.post(
      '${ApiUrlV2.qrSuaUpdate}/$qrCode',
      data: {
        'maNguoiDung': _prefs.id,
      },
    );
    return UpdateQRSua(status: ApiResponseStatus.fromMap(response.data));
  }

  @override
  Future<GetBlogs> getBlogs(String type) async {
    final response = await _dio.get('${ApiUrlV2.blogListBlogV2}/$type');
    return GetBlogs(
      status: ApiResponseStatus.fromMap(response.data),
      data: response.data['data'] != null
          ? List<BlogList>.from(
              response.data['data'].map((e) => BlogList.fromMap(e)),
            )
          : [],
    );
  }

  @override
  Future<UpdateBaby> updateBaby(FormData data, int id) async {
    final response = await _dio.post(
      '${ApiUrlV2.conUpdate}/$id',
      data: data,
    );
    return UpdateBaby(
      status: ApiResponseStatus.fromMap(response.data),
      data: Con.fromMap(response.data['data']),
    );
  }
}
