import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_enum.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/calendar.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';

class CalendarV2 {
  //generate tất cả các chu kì kinh nguyệt
  static List<KinhNguyet> initListCKKN({
    required int ckdn,
    required int cknn,
    required int snck,
    int? tbnknInit,
    required DateTime ngayBatDau,
    required String maNguoiDung,
    DateTime? now,
  }) {
    DateTime begin = ngayBatDau.formatStartDate();
    int tbnkn = tbnknInit ?? (ckdn + cknn) ~/ 2;
    List<KinhNguyet> listKN = [];

    int index = 0;
    while (index < 2) {
      DateTime end = begin.add(Duration(days: tbnkn - 1));

      //lấy ngày bắt đầu có trứng dựa trên công thức
      int nct = testDay[tbnkn]! - 1;
      if (nct < snck) {
        nct = snck;
      }

      //ngày bắt đầu và ngày kết thúc kinh
      DateTime beginK = begin;
      DateTime endK = beginK.add(Duration(days: snck - 1));

      //ngày bắt đầu và ngày kết thúc trứng
      DateTime beginT = begin.add(Duration(days: nct));
      DateTime endT = beginT.add(Duration(days: 6));

      //kiểm tra chu kì nằm trong chu kì nào
      index = CalendarHandler.getIndexByDate(begin, end, now: now);

      // thêm chu kì vào list
      listKN.add(KinhNguyet(
        maNguoiDung: maNguoiDung,
        tbnkn: tbnkn,
        snck: snck,
        snct: 7,
        ckdn: ckdn,
        cknn: cknn,
        ngayBatDau: begin,
        ngayKetThuc: end,
        ngayBatDauKinh: beginK,
        ngayKetThucKinh: endK,
        ngayBatDauTrung: beginT,
        ngayKetThucTrung: endT,
        trangThai: index,
      ));

      //gán ngày bắt đầu chu kì tiếp theo
      begin = end.add(Duration(days: 1));
    }
    return listKN;
  }

  //làm mới chu kỳ kinh nguyệt
  static KinhNguyet renewKinhNguyet({
    required int ckdn,
    required int cknn,
    required int snck,
    required int tbnkn,
    required DateTime ngayBatDau,
    required String maNguoiDung,
  }) {
    DateTime begin = ngayBatDau.formatStartDate();
    DateTime end = begin.add(Duration(days: tbnkn - 1));

    //lấy ngày bắt đầu có trứng dựa trên công thức
    int nct = testDay[tbnkn]! - 1;
    if (nct < snck) {
      nct = snck;
    }

    //ngày bắt đầu và ngày kết thúc kinh
    DateTime beginK = begin;
    DateTime endK = beginK.add(Duration(days: snck - 1));

    //ngày bắt đầu và ngày kết thúc trứng
    DateTime beginT = begin.add(Duration(days: nct));
    DateTime endT = beginT.add(Duration(days: 6));

    //kiểm tra chu kì nằm trong chu kì nào
    int index = CalendarHandler.getIndexByDate(begin, end);

    // thêm chu kì vào list
    return KinhNguyet(
      maNguoiDung: maNguoiDung,
      tbnkn: tbnkn,
      snck: snck,
      snct: 7,
      ckdn: ckdn,
      cknn: cknn,
      ngayBatDau: begin,
      ngayKetThuc: end,
      ngayBatDauKinh: beginK,
      ngayKetThucKinh: endK,
      ngayBatDauTrung: beginT,
      ngayKetThucTrung: endT,
      trangThai: index,
    );
  }
}
