import 'package:flutter_ovumb_app_version1/data/models/nguoidung/cau_tra_loi.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nhat_ky.dart';

abstract class NhatKyProviderV2 {
  Future<NhatKy?> getNhatKy({required DateTime date});
  Future<int?> insertNhatKy({required DateTime date});
  Future<List<NhatKy>> getListNhatKyNotSync();
  Future<List<CauTraLoi>> getListCauTraLoi({required DateTime date});
  Future<CauTraLoi?> getCauTraLoi(
      {required int maNhatKy, required int maCauHoi});
  Future insertListCauTraLoi(
      {required List<String> cauTraLoi, required DateTime date});
  Future serverSynchronizedNhatKy();
  Future updateNhatKyWhenSynced();
}
