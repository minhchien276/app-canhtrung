import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_provider.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/cau_hoi.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/thai_ki.dart';

class LocalRepository {
  final localProvider = LocalProvider();

  //người dùng
  Future insertNguoiDung(NguoiDung nguoiDung) =>
      localProvider.insertNguoiDung(nguoiDung);

  Future<NguoiDung> getNguoiDung(String id) => localProvider.getNguoiDung(id);

  Future updateNguoiDung(NguoiDung nguoiDung) =>
      localProvider.updateNguoiDung(nguoiDung);

  Future updatePhase(
    int phase,
  ) =>
      localProvider.updatePhase(phase);

  Future updateTrangThaiWhenSynced() =>
      localProvider.updateTrangThaiWhenSynced();

  //get list câu hỏi
  Future<List<CauHoi>> getListCauHoi() => localProvider.getListCauHoi();
  //insert câu hỏi
  Future insertCauHoi({required List<CauHoi> listCauHoi}) =>
      localProvider.insertCauHoi(listCauHoi);

  //insert list câu trả lời
  Future insertListCauTraLoi({
    required int maNhatKy,
    required List<String> listCauTraLoi,
    required bool connected,
  }) =>
      localProvider.insertListCauTraLoi(maNhatKy, listCauTraLoi, connected);

  // xóa tât cả dữ liệu khi đăng xuất
  Future deleteAll() => localProvider.deleteAll();

  Future insertThaiKi({
    required ThaiKi thaiKi,
  }) =>
      localProvider.insertThaiKi(thaiKi);

  Future getThaiKi({
    required String maNguoiDung,
  }) =>
      localProvider.getThaiKi(maNguoiDung);

  Future updateThaiKi({
    required ThaiKi thaiKi,
  }) =>
      localProvider.updateThaiKi(thaiKi);

  Future deleteThaiKi({
    required String maNguoiDung,
  }) =>
      localProvider.deleteThaiKi(maNguoiDung);
}
