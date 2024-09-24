import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/checkbox_enum.dart';
import 'package:flutter_ovumb_app_version1/data/enum/nhatky_enum.dart';
import 'package:flutter_ovumb_app_version1/data/handle/calender_handle.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/luong_kinh.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_nhatky.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/calendar/calendar_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/kinhnguyet_v2/kinhnguyet_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/luongkinh_v2/luongkinh_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/nhatky_v2/nhatky_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_state.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_v2.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/toast_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';

class NhatKyCubit extends Cubit<NhatKyState> {
  static final NhatKyCubit _singleton = NhatKyCubit._internal();

  factory NhatKyCubit() {
    return _singleton;
  }

  // Constructor private để không ai khác có thể tạo ra thể hiện mới
  NhatKyCubit._internal()
      : super(NhatKyState(answers: answer, listLuongkinh: answerLuongKinh));

  final _nhatky = NhatKyRepositoryV2();
  final _luongkinh = LuongKinhRepositoryV2();
  final _calendar = CalendarRepositoryV2();
  final _kinhnguyet = KinhNguyetRepositoryV2();
  final _prefs = SharedPreferencesService();

  Data listLuongkinh = answerLuongKinh;
  List<Data> listAnswer = [];
  List<String> listCheckbox = [];
  DateTime selectedDate = DateTime.now();

  //init luong kinh
  void initLuongKinh(String? luongKinh) {
    listLuongkinh = answerLuongKinh.copyWith();
    if (luongKinh != null) {
      // nếu đã có trong db rồi thì đặt giá trị khi hiện
      for (int i = 0; i < listLuongkinh.detailTitle.length; i++) {
        if (listLuongkinh.detailTitle[i] == luongKinh) {
          listLuongkinh.checkbox[i] = true;
          return;
        }
      }
    }
  }

  //init nhat ky
  void initNhatKy() {
    listAnswer.clear();
    answer.map((item) => listAnswer.add(item.copyWith())).toList();
  }

  //set luong kinh
  void setLuongKinh(String? luongKinh) {
    listLuongkinh = answerLuongKinh;
    if (luongKinh != null) {
      // nếu đã có trong db rồi thì đặt giá trị khi hiện
      for (int i = 0; i < listLuongkinh.detailTitle.length; i++) {
        if (listLuongkinh.detailTitle[i] == luongKinh) {
          listLuongkinh.checkbox[i] = true;
        } else {
          listLuongkinh.checkbox[i] = false;
        }
      }
    }
    emit(NhatKyState(
      answers: listAnswer,
      luongkinh: luongKinh,
      listLuongkinh: listLuongkinh,
      date: selectedDate,
    ));
  }

  //set radio value
  void setRadioValue(int titleId, int index, String? luongKinh) {
    for (int i = 0; i < listAnswer[titleId].checkbox.length; i++) {
      listAnswer[titleId].checkbox[i] = false;
    }
    listAnswer[titleId].checkbox[index] = !listAnswer[titleId].checkbox[index];
    listAnswer[titleId].data = listAnswer[titleId].detailTitle[index];

    emit(NhatKyState(
      answers: listAnswer,
      luongkinh: luongKinh,
      listLuongkinh: listLuongkinh,
      date: selectedDate,
    ));
  }

  //set picker
  void setPickerValue(String value, int titleId, int index, String? luongKinh) {
    if (listAnswer[titleId].data == null) {
      listAnswer[titleId].data = ['35', '0'];
    }
    listAnswer[titleId].data[index] = value;
    emit(NhatKyState(
      answers: listAnswer,
      luongkinh: luongKinh,
      listLuongkinh: listLuongkinh,
      date: selectedDate,
    ));
  }

  //set checkbox value
  void setCheckboxValue(int titleId, int index, String? luongKinh) {
    listAnswer[titleId].checkbox[index] = !listAnswer[titleId].checkbox[index];
    listAnswer[titleId].data = null;

    for (int i = 0; i < listAnswer[titleId].checkbox.length; i++) {
      //checkbox dac biet
      if (question[titleId].checkboxType == CheckboxEnum.special) {
        //nếu chọn vào "không" thì bỏ hết tích
        if (index == 0) {
          listAnswer[titleId].data = true;
          if (i != 0) {
            listAnswer[titleId].checkbox[i] = false;
          }
        } else {
          if (listAnswer[titleId].checkbox[i]) {
            listAnswer[titleId].checkbox[0] = false;
            listAnswer[titleId].data = true;
          }
        }
      } else {
        //checkbox thuong
        if (listAnswer[titleId].checkbox[i]) {
          listAnswer[titleId].data = true;
        }
      }
    }

    emit(NhatKyState(
      answers: listAnswer,
      luongkinh: luongKinh,
      listLuongkinh: listLuongkinh,
      date: selectedDate,
    ));
  }

  fecthList(DateTime date) async {
    selectedDate = date;
    listCheckbox = [];
    initNhatKy();
    final luongkinh = await _luongkinh.getLuongKinh(date: date, trangThai: 0);
    final answers = await _nhatky.getListCauTraLoi(date: date);
    if (answers.isNotEmpty) {
      for (int index = 0; index < answers.length; index++) {
        if (answers[index].cauTraLoi != '') {
          if (index == 0) {
            listAnswer[index].data = ['35', '0'];
            final c = answers[index].cauTraLoi!.split('.');
            if (c.isNotEmpty) {
              listAnswer[index].data = c;
              listAnswer[index].checkbox.first = true;
            }
          } else {
            if (question[index].type == NhatKyEnum.radiobutton) {
              final sub = answers[index].cauTraLoi ?? '';
              for (int i = 0; i < listAnswer[index].detailTitle.length; i++) {
                if (sub == listAnswer[index].detailTitle[i]) {
                  listAnswer[index].checkbox[i] = true;
                  listAnswer[index].data = sub;
                }
              }
            } else if (question[index].type == NhatKyEnum.checkbox) {
              final subList = spiltAnswer(answers[index].cauTraLoi ?? '');
              if (subList.isNotEmpty) {
                subList.forEach((sub) {
                  for (int i = 0;
                      i < listAnswer[index].detailTitle.length;
                      i++) {
                    if (sub == listAnswer[index].detailTitle[i]) {
                      listAnswer[index].checkbox[i] = true;
                      listAnswer[index].data = true;
                    }
                  }
                });
              }
            }
          }
        }
      }
    }
    initLuongKinh(luongkinh?.luongKinh);
    emit(NhatKyState(
      answers: listAnswer,
      luongkinh: luongkinh?.luongKinh,
      listLuongkinh: listLuongkinh,
      date: date,
    ));
  }

  saveData(BuildContext context) async {
    //save lượng kinh
    if (state.luongkinh != null) {
      LuongKinh? luongkinhSelected =
          await _luongkinh.getLuongKinh(date: selectedDate, trangThai: 0);
      if (state.luongkinh == 'Không có') {
        if (luongkinhSelected != null) {
          await _luongkinh.deleteLuongKinh(date: selectedDate);
        }
      } else {
        if (luongkinhSelected == null) {
          await updateLuongkinhAndCKKN();
        }
        await _luongkinh.insertLuongKinh(
          date: selectedDate,
          luongkinh: state.luongkinh,
        );
      }
      _prefs.setSyncLuongKinh(false);
    }

    //save nhật ký, câu trả lời
    List<String>? finalAnswer = getFinalAnswers();
    if (finalAnswer != null) {
      await _nhatky.insertListCauTraLoi(
        cauTraLoi: finalAnswer,
        date: selectedDate,
      );
      _prefs.setSyncNhatKy(false);
    }
    _calendar.getCalendarData();
    Navigator.pop(context);
  }

  List<String>? getFinalAnswers() {
    // lấy các câu trả lời đã pick
    List<String> finalAnswer = [];
    bool checkEmpty = true;
    for (int index = 0; index < listAnswer.length; index++) {
      String res = '';
      if (listAnswer[index].data != null) {
        checkEmpty = false;
        if (question[index].type == NhatKyEnum.radiobutton) {
          res = listAnswer[index].data; //radiobutton luôn lấy thằng cuối
        } else if (question[index].type == NhatKyEnum.checkbox) {
          List<String> resCheckbox = [];
          for (int i = 0; i < listAnswer[index].checkbox.length; i++) {
            if (listAnswer[index].checkbox[i]) {
              resCheckbox.add(listAnswer[index].detailTitle[i]);
            }
          }
          res = joinAnswer(resCheckbox); //checkbox lấy hết
        } else {
          res = listAnswer[index].data[0] +
              '.' +
              listAnswer[index].data[1]; //nhiệt độ thì cộng
        }
      }
      finalAnswer.add(res);
    }
    if (!checkEmpty) {
      return finalAnswer;
    } else {
      return null;
    }
  }

  //cập nhật lượng kinh và chu kỳ kinh nguyệt
  updateLuongkinhAndCKKN() async {
    //lấy ra kinh nguyệt của ngày đang chọn
    selectedDate = selectedDate.formatStartDate();
    print('selectedDate: ${selectedDate.millisecondsSinceEpoch}');
    KinhNguyet? kinhnguyetSelected =
        await _kinhnguyet.localGetKNByDate(date: selectedDate);

    //case1: nếu ngày đang chọn có nằm trong 1 chu kì kinh nguyệt
    if (kinhnguyetSelected != null) {
      debugPrint(
          'kinhnguyetSelected: ' + kinhnguyetSelected.toJson().toString());
      debugPrint('case1: nếu ngày đang chọn có nằm trong 1 chu kì kinh nguyệt');
      //kiểm tra chu kì kinh nguyệt đã có lượng kinh chưa
      List<LuongKinh> luongkinhSelected = await _luongkinh.getListLuongKinh(
        begin: kinhnguyetSelected.ngayBatDauKinh!,
        end: kinhnguyetSelected.ngayKetThucKinh!,
      );

      //case2: đã có lượng kinh
      if (luongkinhSelected.isNotEmpty) {
        debugPrint('case2: đã có lượng kinh');
        int daysFromSelectedToFirst =
            selectedDate.difference(luongkinhSelected.last.thoiGian).inDays + 1;

        //case3: kiểm tra ngày chọn cách ngày cuối cùng có nhập kinh bao nhiêu ngày
        //số ngày ở giữa 2 ngày đã nhập kinh trên 5 ngày thì reject
        if (daysFromSelectedToFirst >= 7) {
          debugPrint(
              'case3: kiểm tra ngày chọn cách ngày cuối cùng có nhập kinh bao nhiêu ngày, số ngày ở giữa 2 ngày đã nhập kinh trên 5 ngày thì reject');
          KinhNguyet? kinhNguyetNext =
              await _kinhnguyet.localGetNextKNFromDate(date: selectedDate);
          if (kinhNguyetNext != null) {
            debugPrint('kinhNguyetNext: ' + kinhNguyetNext.toJson().toString());
            //case4: nếu chu kì kế tiếp là chu kỳ đã qua thì chỉ cập nhật lượng kinh
            if (kinhNguyetNext.trangThai == 0) {
              debugPrint(
                  'case4:nếu chu kì kế tiếp là chu kỳ đã qua thì chỉ cập nhật lượng kinh');
            }
            //case5: nếu chu kì kế tiếp là chu kỳ hiện tại hoặc tương lai thì đẩy lên nhưng vẫn giữ lại thông tin chu kỳ
            else {
              debugPrint(
                  'case4: nếu chu kì kế tiếp là chu kỳ hiện tại hoặc tương lai thì đẩy lên nhưng vẫn giữ lại thông tin chu kỳ');
              //xoá kinh nguyệt cũ và tạo kinh nguyệt với tương ứng với ngày chọn
              await _kinhnguyet.localDeleteKNFromDate(date: selectedDate);
              List<KinhNguyet> initListCKKN = CalendarV2.initListCKKN(
                ckdn: kinhNguyetNext.ckdn,
                cknn: kinhNguyetNext.cknn,
                snck: kinhNguyetNext.snck,
                tbnknInit: kinhNguyetNext.tbnkn,
                ngayBatDau: selectedDate,
                maNguoiDung: kinhNguyetNext.maNguoiDung!,
              );
              await _kinhnguyet.localInsertListKN(listKinhNguyet: initListCKKN);
              _prefs.setSyncKinhNguyet(false);
            }
          }
        }
        //case3: dưới 5 ngày thì cập ngày số ngày có kinh và ngày kết thúc kinh
        else {
          debugPrint(
              'case3: dưới 5 ngày thì cập ngày số ngày có kinh và ngày kết thúc kinh');
          bool check =
              await _kinhnguyet.localUpdateNgayKinh(date: selectedDate);
          if (check) {
            //gọi đồng bộ
            _prefs.setSyncKinhNguyet(false);
          }
        }
      }
      //case2: chưa nhập lượng kinh nào
      else {
        debugPrint('case2: chưa nhập lượng kinh nào');
        //kiểm tra xem ngày chọn có là ngày bắt đầu không
        //case3: có - chỉ insert lượng kinh
        if (checkTheSameDay(kinhnguyetSelected.ngayBatDauKinh!, selectedDate)) {
          debugPrint(
              'case3:kiểm tra xem ngày chọn có là ngày bắt đầu không,có - chỉ insert lượng kinh');
        }
        //case3: không - cập nhật lại chu kì kinh
        else {
          debugPrint('case3:không - cập nhật lại chu kì kinh');
          //case4: kiểm tra ngày chọn với ngày kết thúc chu kì có đủ 21 ngày không
          int daysLeft =
              kinhnguyetSelected.ngayKetThuc!.difference(selectedDate).inDays +
                  1;
          //case4:lớn hơn 21 ngày => dịch ngày bắt đầu là ngày hiện tại
          if (daysLeft >= 21) {
            debugPrint(
                'case4:lớn hơn 21 ngày => dịch ngày bắt đầu là ngày hiện tại');
            //cập nhật lại ngày bắt đầu và độ dài chu kì kinh nguyệt
            await _kinhnguyet.localUpdateKinhNguyet(
              maKinhNguyet: kinhnguyetSelected.maKinhNguyet!,
              kinhNguyet: CalendarV2.renewKinhNguyet(
                ckdn: kinhnguyetSelected.ckdn,
                cknn: kinhnguyetSelected.cknn,
                snck: kinhnguyetSelected.snck,
                tbnkn: daysLeft,
                ngayBatDau: selectedDate,
                maNguoiDung: kinhnguyetSelected.maNguoiDung!,
              ),
            );
            //cập nhật lại tbnkn của chu kỳ dự đoán
            await updateCKKNFuture();
            _prefs.setSyncKinhNguyet(false);
          }
          //case4: nhỏ hơn 21 ngày
          else {
            debugPrint('case4:nhỏ hơn 21 ngày');
            KinhNguyet? kinhNguyetNext =
                await _kinhnguyet.localGetNextKNFromDate(date: selectedDate);
            if (kinhNguyetNext != null) {
              debugPrint(
                  'kinhNguyetNext: ' + kinhNguyetNext.toJson().toString());
              int daysLeft =
                  kinhNguyetNext.ngayKetThuc!.difference(selectedDate).inDays +
                      1;

              //case5: nếu chu kì kế tiếp là chu kỳ đã qua thì cộng dồn vào chu kì tiếp theo
              if (kinhNguyetNext.trangThai == 0) {
                debugPrint(
                    'case5:nếu chu kì kế tiếp là chu kỳ đã qua thì cộng dồn vào chu kì tiếp theo');
                //xoá chu kỳ đã chọn
                await _kinhnguyet.localDeleteKN(
                    maKinhNguyet: kinhnguyetSelected.maKinhNguyet!);
                debugPrint('case5:xoá chu kỳ đã chọn ' +
                    kinhnguyetSelected.toJson().toString());
                //cập nhật ngày bắt đầu và độ dài kinh nguyệt
                await _kinhnguyet.localUpdateKinhNguyet(
                  maKinhNguyet: kinhnguyetSelected.maKinhNguyet!,
                  kinhNguyet: CalendarV2.renewKinhNguyet(
                    ckdn: kinhnguyetSelected.ckdn,
                    cknn: kinhnguyetSelected.cknn,
                    snck: kinhnguyetSelected.snck,
                    tbnkn: daysLeft,
                    ngayBatDau: selectedDate,
                    maNguoiDung: kinhnguyetSelected.maNguoiDung!,
                  ),
                );
                //cập nhật lại tbnkn của chu kỳ dự đoán
                await updateCKKNFuture();
                _prefs.setSyncKinhNguyet(false);
              }
              //case5: nếu chu kì kế tiếp là chu kỳ hiện tại hoặc tương lai thì đẩy lên nhưng vẫn giữ lại thông tin chu kỳ
              else {
                debugPrint(
                    'case5: nếu chu kì kế tiếp là chu kỳ hiện tại hoặc tương lai thì đẩy lên nhưng vẫn giữ lại thông tin chu kỳ');
                //xoá kinh nguyệt cũ và tạo kinh nguyệt với tương ứng với ngày chọn
                await _kinhnguyet.localDeleteKNFromDate(date: selectedDate);
                List<KinhNguyet> initListCKKN = CalendarV2.initListCKKN(
                  ckdn: kinhNguyetNext.ckdn,
                  cknn: kinhNguyetNext.cknn,
                  snck: kinhNguyetNext.snck,
                  tbnknInit: kinhNguyetNext.tbnkn,
                  ngayBatDau: selectedDate,
                  maNguoiDung: kinhNguyetNext.maNguoiDung!,
                );
                await _kinhnguyet.localInsertListKN(
                  listKinhNguyet: initListCKKN,
                );
                _prefs.setSyncKinhNguyet(false);
              }
            }
          }
        }
      }
    }
    //case1: nếu ngày đang chọn không trong 1 chu kì kinh nguyệt
    else {
      debugPrint('case1: nếu ngày đang chọn không trong 1 chu kì kinh nguyệt');
      KinhNguyet? kinhnguyetNext =
          await _kinhnguyet.localGetNextKNFromDate(date: selectedDate);
      if (kinhnguyetNext != null) {
        debugPrint('kinhnguyetNext: ' + kinhnguyetNext.toJson().toString());
        //case2: nếu chu kỳ là chu kỳ đã qua
        if (kinhnguyetNext.trangThai == 0) {
          debugPrint('case2: nếu chu kỳ là chu kỳ đã qua');
          List<LuongKinh> luongkinhInRange = await _luongkinh.getListLuongKinh(
            begin: selectedDate,
            end: kinhnguyetNext.ngayBatDau!.subtract(Duration(days: 1)),
          );
          //case3: nếu có lượng kinh thì lấy ngày đầu tiên của lượng kinh để renew
          if (luongkinhInRange.isNotEmpty) {
            debugPrint(
                'case3: nếu có lượng kinh thì lấy ngày đầu tiên của lượng kinh để renew');
            int daysLeft = luongkinhInRange.first.thoiGian
                    .difference(selectedDate)
                    .inDays +
                1;
            if (daysLeft > 21) {
              await _kinhnguyet.localInsertKN(
                kinhNguyet: CalendarV2.renewKinhNguyet(
                  ckdn: daysLeft - 1,
                  cknn: daysLeft - 1,
                  snck: 4,
                  tbnkn: daysLeft - 1,
                  ngayBatDau: selectedDate,
                  maNguoiDung: kinhnguyetNext.maNguoiDung!,
                ),
              );
              _prefs.setSyncKinhNguyet(false);
            }
          }
          //case3: nếu không có lượng kinh thì lấy ngày đầu tiên của chu kỳ tiếp theo
          else {
            debugPrint(
                'case3: nếu không có lượng kinh thì lấy ngày đầu tiên của chu kỳ tiếp theo');
            int daysLeft =
                kinhnguyetNext.ngayBatDau!.difference(selectedDate).inDays + 1;
            if (daysLeft > 21) {
              await _kinhnguyet.localInsertKN(
                kinhNguyet: CalendarV2.renewKinhNguyet(
                  ckdn: daysLeft - 1,
                  cknn: daysLeft - 1,
                  snck: 4,
                  tbnkn: daysLeft - 1,
                  ngayBatDau: selectedDate,
                  maNguoiDung: kinhnguyetNext.maNguoiDung!,
                ),
              );
              _prefs.setSyncKinhNguyet(false);
            }
          }
        }
        //case2: nếu không phải là chu kỳ đã qua
        else {
          debugPrint(
              'case2: nếu không phải là chu kỳ đã qua, đẩy lên nhưng vẫn giữ lại thông tin chu kỳ');
          await _kinhnguyet.localDeleteKNFromDate(date: selectedDate);
          List<KinhNguyet> initListCKKN = CalendarV2.initListCKKN(
            ckdn: kinhnguyetNext.ckdn,
            cknn: kinhnguyetNext.cknn,
            snck: kinhnguyetNext.snck,
            tbnknInit: kinhnguyetNext.tbnkn,
            ngayBatDau: selectedDate,
            maNguoiDung: kinhnguyetNext.maNguoiDung!,
          );
          await _kinhnguyet.localInsertListKN(
            listKinhNguyet: initListCKKN,
          );
          _prefs.setSyncKinhNguyet(false);
        }
      }
    }
  }

  //tính trung bình chu kỳ kinh nguyệt
  caculatorTBNKN() async {
    int count = 0;
    List<KinhNguyet> threeLastestCKKN = [];

    //lấy ra list kinh nguyệt
    List<KinhNguyet> listKinhNguyet = await _kinhnguyet.localGetListKN();

    //đảo ngược và remove kinh nguyệt dự đoán
    listKinhNguyet = listKinhNguyet.reversed.toList();
    listKinhNguyet.removeAt(0);

    //mặc đinh là 1 chu kỳ
    int tbnknNew = listKinhNguyet.first.tbnkn;

    //lấy 3 chu kỳ gần nhất
    for (int i = 0; i < listKinhNguyet.length; i++) {
      if (count == 3) break;
      threeLastestCKKN.add(listKinhNguyet[i]);
      count++;
    }

    //nêú có 2 chu kỳ thì trung bình của 2
    if (count == 2) {
      tbnknNew = 0;
      threeLastestCKKN.forEach((e) => tbnknNew += e.tbnkn);
      tbnknNew = tbnknNew ~/ 2;
    }
    //có 3 chu kỳ thì trung bình của 3
    else if (count == 3) {
      tbnknNew = 0;
      threeLastestCKKN.forEach((e) => tbnknNew += e.tbnkn);
      tbnknNew = tbnknNew ~/ 3;
    }
    return tbnknNew;
  }

  //cập nhật lại chu kỳ kinh nguyệt dự đoán
  updateCKKNFuture({DateTime? ngayBatDau}) async {
    int tbnknNew = await caculatorTBNKN();

    //lấy ra kinh nguyệt dự đoán để update
    KinhNguyet? kinhnguyetFuture = await _kinhnguyet.localGetKN(trangThai: 2);
    if (kinhnguyetFuture != null) {
      await _kinhnguyet.localUpdateKinhNguyet(
        maKinhNguyet: kinhnguyetFuture.maKinhNguyet!,
        kinhNguyet: CalendarV2.renewKinhNguyet(
          ckdn: tbnknNew,
          cknn: tbnknNew,
          snck: kinhnguyetFuture.snck,
          tbnkn: tbnknNew,
          ngayBatDau: ngayBatDau ?? kinhnguyetFuture.ngayBatDau!,
          maNguoiDung: kinhnguyetFuture.maNguoiDung!,
        ),
      );
    }
  }

  //cập nhật lại chu kỳ kinh nguyệt hiện tại
  updateCKKNNow({
    required BuildContext context,
    required int tbnkn,
    required int snck,
    required KinhNguyet kinhnguyetNow,
  }) async {
    if (tbnkn == kinhnguyetNow.tbnkn && snck == kinhnguyetNow.snck) {
      showToast(context, 'Bạn chưa thay đổi thông tin gì');
    } else {
      //lấy ra kinh nguyệt hiện tại để update
      KinhNguyet current = CalendarV2.renewKinhNguyet(
        ckdn: tbnkn,
        cknn: tbnkn,
        snck: kinhnguyetNow.snck,
        tbnkn: tbnkn,
        ngayBatDau: kinhnguyetNow.ngayBatDau!,
        maNguoiDung: kinhnguyetNow.maNguoiDung!,
      );
      await _kinhnguyet.localUpdateKinhNguyet(
        maKinhNguyet: kinhnguyetNow.maKinhNguyet!,
        kinhNguyet: current,
      );
      //nếu khi update mà vẫn giữ được là chu kỳ hiện tại thì chỉ update
      if (current.trangThai == 1) {
        //update kinh nguyệt dự đoán
        await updateCKKNFuture(
            ngayBatDau: current.ngayKetThuc!.add(Duration(days: 1)));
      }
      //nếu update mà tbnkn giảm đi và kỳ kinh hiện tại trở thành đã qua
      else if (current.trangThai == 0) {
        int tbnknNew = await caculatorTBNKN();
        List<KinhNguyet> initKinhNguyet = CalendarV2.initListCKKN(
          ckdn: tbnkn,
          cknn: tbnkn,
          snck: snck,
          tbnknInit: tbnknNew,
          ngayBatDau: current.ngayKetThuc!.add(Duration(days: 1)),
          maNguoiDung: current.maNguoiDung!,
        );
        //xoá kinh nguyệt dự đoán
        await _kinhnguyet.localDeleteKNFromDate(
            date: current.ngayKetThuc!.add(Duration(days: 1)));
        //insert lại hiện tại và dự đoán
        await _kinhnguyet.localInsertListKN(listKinhNguyet: initKinhNguyet);
      }
      _prefs.setSyncKinhNguyet(false);
      context.showSuccessToast('Cập nhật thông tin kinh nguyệt thành công');
      context.pop();
    }
  }
}
