import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/blog_type.dart';
import 'package:flutter_ovumb_app_version1/data/enum/choan_enum.dart';
import 'package:flutter_ovumb_app_version1/data/handle/choan_chart.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/choan.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/hutsua.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/link/link_v2_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/milk/milk_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/milk_v2/milk_v2_repository.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/logic/calendar/calendar_logic.dart';
import 'package:flutter_ovumb_app_version1/services/exception.dart';
import 'package:flutter_ovumb_app_version1/services/models/api_response.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class MilkBloc extends Bloc<MilkEvent, MilkState> {
  MilkBloc()
      : super(MilkState(
          isLoading: LoadingStatus.all,
          choAn: [],
          choAnHistory: [],
          trieuChung: [],
          phatTrienCon: [],
          babies: [],
          chartDataChoAn: [],
          hutSua: [],
          hutSuaByDay: [],
          blogsBiQuyet: null,
          blogsQuanHe: null,
          posts: null,
          videos: null,
          unlock: null,
          status: LoadedStatus.initial,
        )) {
    on<CheckBabyExistEvent>(_onGetBaby);
    on<CheckQRExistEvent>(_onGetUnlock);
    on<UpdateBabyEvent>(_onUpdateBaby);
    on<AddBabyEvent>(_onAddBaby);
    on<DeleteBabyEvent>(_onDeleteBaby);
    on<SwitchBabyEvent>(_onSwitchBaby);
    on<InsertPhattrienEvent>(_onInsertPhattrien);
    on<SwitchPhatTrienEvent>(_onSwitchPhattrien);
    on<InsertTrieuchungEvent>(_onInsertTrieuchung);
    on<GetChoAnHistoryEvent>(_onGetChoAnHistory);
    on<BackChoAnInputEvent>(_onBackChoAnInput);
    on<InsertChoAnEvent>(_onInsertChoAn);
    on<GetBumeLinkEvent>(_onGetBumeLink);
    on<DeleteChoAnEvent>(_onDeleteChoAn);
    on<UpdateChoAnEvent>(_onUpdateChoAn);
    on<GetHutSuaEvent>(_onGetHutSua);
    on<GetHutSuaHistoryEvent>(_onGetHutSuaHistory);
    on<InsertHutSuaEvent>(_onInsertHutSua);
    on<DeleteHutSuaEvent>(_onDeleteHutSua);
    on<UpdateHutSuaEvent>(_onUpdateHutSua);
    on<InsertQrSua>(_onInsertQrSua);
    on<GetPostsEvent>(_onGetPosts);
    on<GetVideosEvent>(_onGetVideos);
    on<GetBlogsEvent>(_onGetBlogs);
  }
  final _milk = MilkRepository();
  final _milkV2 = MilkV2Repository();
  final _linkV2 = LinkV2Repository();

  _onGetBaby(
    CheckBabyExistEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: LoadingStatus.all));
      final res = await _milkV2.getBaby();
      if (res.isOk) {
        Con? current = res.data.isNotEmpty ? res.data.first : null;
        emit(state.copyWith(
          currentBaby: current,
          babies: res.data,
          isLoading: LoadingStatus.stop,
        ));
        if (current != null) {
          final choAn = await _milkV2.getChoAn(current.id, DateTime.now());
          final trieuChung = await _milkV2.getTrieuChung(current.id);
          final phatTrienCon = await _milkV2.getPhatTrien(current.id);
          emit(state.copyWith(
            choAn: choAn.data,
            trieuChung: trieuChung.data,
            phatTrienCon: phatTrienCon.data,
          ));
        }
      } else {
        emit(state.copyWith(
          message: res.status.message,
          status: LoadedStatus.disconnect,
          isLoading: LoadingStatus.stop,
        ));
      }
    } on DioException catch (e) {
      emit(state.copyWith(
        message: e.messageTr,
        status: LoadedStatus.disconnect,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onGetUnlock(
    CheckQRExistEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      if (state.unlock == null) {
        emit(state.copyWith(
          isLoading: LoadingStatus.begin,
        ));
        final res = await _milkV2.getQRSua();
        if (res.isOk) {
          emit(state.copyWith(
            unlock: true,
            status: LoadedStatus.succes,
          ));
        } else {
          emit(state.copyWith(
            message: res.status.message,
            status: LoadedStatus.failure,
            isLoading: LoadingStatus.stop,
          ));
        }
      }
    } on DioException catch (e) {
      emit(state.copyWith(
        message: ApiResponseStatus.fromMap(e.response?.data).message,
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onUpdateBaby(
    UpdateBabyEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: LoadingStatus.begin, message: null));
      FormData formData = FormData.fromMap({
        'ten': event.con.ten,
        'ngaySinh': event.con.ngaySinh.millisecondsSinceEpoch,
        'gioiTinh': event.con.gioiTinh,
      });
      if (event.avatar != null) {
        String? mineType = lookupMimeType(event.avatar!.path);
        formData.files.add(MapEntry(
          "image",
          await MultipartFile.fromFile(
            event.avatar!.path,
            filename: event.avatar.toString().split('/').last,
            contentType: MediaType.parse(mineType ?? 'image/jpeg'),
          ),
        ));
      }

      final res = await _milkV2.updateBaby(formData, event.con.id);
      List<Con> tmp = [];
      for (var e in state.babies) {
        if (e.id != res.data.id) {
          tmp.add(e);
        }
      }
      tmp.add(res.data);
      if (res.isOk) {
        emit(state.copyWith(
          currentBaby: res.data,
          babies: tmp,
          isLoading: LoadingStatus.stop,
          message: 'Cập nhật thông tin bé thành công',
        ));
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onAddBaby(
    AddBabyEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: LoadingStatus.begin, message: null));
      final res = await _milkV2.insertBaby(event.con);
      if (res.isOk) {
        state.babies.forEach((e) {
          e.trangThai = 0;
        });
        state.babies.add(res.data);
        emit(state.copyWith(
          currentBaby: res.data,
          babies: state.babies,
          isLoading: LoadingStatus.stop,
          message:
              'Thêm bé thành công. Bạn đã chuyển sang bé ${event.con.ten} ',
          event: event.event,
          choAn: [],
          choAnHistory: [],
          trieuChung: [],
          phatTrienCon: [],
          chartDataChoAn: [],
          hutSua: [],
          hutSuaByDay: [],
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onDeleteBaby(
    DeleteBabyEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: LoadingStatus.begin, message: null));
      final res = await _milkV2.deleteBaby(event.con.id);
      if (res.isOk) {
        List<Con> res = await _milk.get();
        emit(state.copyWith(
          currentBaby: res.isNotEmpty ? res.first : null,
          babies: res,
          isLoading: LoadingStatus.stop,
          message: 'Thông tin của bé ${event.con.ten} đã được xóa thành công',
        ));
        if (res.isNotEmpty) {
          final choAn = await _milk.getChoAnByDay(
              maCon: res.first.id, date: DateTime.now());
          final trieuChung = await _milk.getTrieuChung(maCon: res.first.id);
          final phatTrienCon = await _milk.getPhatTrien(maCon: res.first.id);

          emit(state.copyWith(
            choAn: choAn,
            trieuChung: trieuChung,
            phatTrienCon: phatTrienCon,
            isLoading: LoadingStatus.stop,
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onSwitchBaby(
    SwitchBabyEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      if (event.con.trangThai == 0) {
        emit(state.copyWith(
          isLoading: LoadingStatus.begin,
        ));
        final res = await _milkV2.updateBabyStatus(event.con.id);
        if (res.isOk) {
          Con? tmp;
          state.babies.forEach((e) {
            if (e.id == event.con.id) {
              e.trangThai = 1;
              tmp = e;
            } else {
              e.trangThai = 0;
            }
          });
          emit(state.copyWith(
            currentBaby: tmp,
            babies: state.babies,
            isLoading: LoadingStatus.stop,
            message: 'Bạn đã chuyển sang bé ${event.con.ten} ',
          ));
          final choAn = await _milk.getChoAnByDay(
              maCon: event.con.id, date: DateTime.now());
          final trieuChung = await _milk.getTrieuChung(maCon: event.con.id);
          final phatTrienCon = await _milk.getPhatTrien(maCon: event.con.id);
          emit(state.copyWith(
            choAn: choAn,
            trieuChung: trieuChung,
            phatTrienCon: phatTrienCon,
            isLoading: LoadingStatus.stop,
            choAnHistory: [],
            chartDataChoAn: [],
            hutSua: [],
            hutSuaByDay: [],
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onInsertPhattrien(
    InsertPhattrienEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: LoadingStatus.begin, message: null));
      final res = await _milkV2.insertPhattien(event.phatTrienCon);
      if (res.isOk) {
        emit(state.copyWith(
          isLoading: LoadingStatus.stop,
          phatTrienCon: res.data,
          message:
              'Đã cập nhật thể trạng bé trong tháng ${event.phatTrienCon.thoiGian?.month ?? ''}',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onSwitchPhattrien(
    SwitchPhatTrienEvent event,
    Emitter<MilkState> emit,
  ) async {
    emit(state.copyWith(
      indexPhatTrien: event.index,
    ));
  }

  _onInsertTrieuchung(
    InsertTrieuchungEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: LoadingStatus.begin, message: null));
      final res = await _milkV2.insertTrieuchung(event.trieuChung);
      if (res.isOk) {
        emit(state.copyWith(
          isLoading: LoadingStatus.stop,
          trieuChung: res.data,
          message: 'Đã cập nhật triệu chứng bé',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onGetChoAnHistory(
    GetChoAnHistoryEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      if (state.currentBaby != null) {
        emit(state.copyWith(
          isLoading: LoadingStatus.begin,
          message: null,
        ));
        final res = await _milkV2.getChoAnHistoryByDate(
          maCon: state.currentBaby!.id,
          maLoaiChoAn: event.maLoaiChoAn,
          date: event.date,
        );

        if (res.isOk) {
          emit(state.copyWith(
            isLoading: LoadingStatus.stop,
            choAnEnum: event.choAnEnum,
            choAnHistory: res.data,
            chartDataChoAn:
                ChoanChart().handleDataChoAn(res.data, event.choAnEnum),
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
        choAnEnum: event.choAnEnum,
      ));
    }
  }

  _onBackChoAnInput(
    BackChoAnInputEvent event,
    Emitter<MilkState> emit,
  ) async {
    emit(state.copyWith(choAnEnum: ChoAnEnum.none));
  }

  _onInsertChoAn(
    InsertChoAnEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: LoadingStatus.begin, message: null));
      if (state.choAn.length < 10) {
        final res = await _milkV2.insertChoAn(choAn: event.choAn);
        if (res.isOk) {
          emit(state.copyWith(
            isLoading: LoadingStatus.stop,
            choAn: res.data,
            message: 'Thêm dữ liệu thành công',
          ));
        } else {
          emit(state.copyWith(
            isLoading: LoadingStatus.stop,
            message: 'Thêm dữ liệu không thành công ${res.status.message}',
          ));
        }
      } else {
        emit(state.copyWith(
          isLoading: LoadingStatus.stop,
          message:
              'Bạn đã nhập đủ 10 lần của ngày hôm nay. Vui lòng nhập tiếp vào ngày hôm sau',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onGetBumeLink(
    GetBumeLinkEvent event,
    Emitter<MilkState> emit,
  ) async {
    if (state.bumeLink == null) {
      final res = await _linkV2.getBuMeLink();
      if (res.isOk) {
        emit(state.copyWith(
          isLoading: LoadingStatus.stop,
          bumeLink: res.data,
        ));
      }
    }
  }

  _onDeleteChoAn(
    DeleteChoAnEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: LoadingStatus.begin, message: null));
      final res = await _milkV2.deleteChoAn(event.maChoAn);
      if (res.isOk) {
        ChoAn? tmp;
        ChoAn? tmp1;
        state.choAn.forEach((e) {
          if (e.maChoAn == event.maChoAn) tmp = e;
        });
        state.choAnHistory.forEach((e) {
          if (e.maChoAn == event.maChoAn) tmp1 = e;
        });
        if (tmp != null) {
          state.choAn.remove(tmp);
        }
        if (tmp1 != null) {
          state.choAnHistory.remove(tmp1);
        }
        emit(state.copyWith(
          choAn: state.choAn,
          choAnHistory: state.choAnHistory,
          chartDataChoAn:
              ChoanChart().handleDataChoAn(state.choAnHistory, state.choAnEnum),
          isLoading: LoadingStatus.stop,
          message: 'Đã xoá thành công',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onUpdateChoAn(
    UpdateChoAnEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: LoadingStatus.begin, message: null));
      final res = await _milkV2.updateChoAn(event.choAn);
      if (res.isOk) {
        for (int i = 0; i < state.choAn.length; i++) {
          if (state.choAn[i].maChoAn == event.choAn.maChoAn) {
            state.choAn[i] = event.choAn;
          }
        }
        for (int i = 0; i < state.choAnHistory.length; i++) {
          if (state.choAnHistory[i].maChoAn == event.choAn.maChoAn) {
            state.choAnHistory[i] = event.choAn;
          }
        }
        emit(state.copyWith(
          isLoading: LoadingStatus.stop,
          choAn: state.choAn,
          choAnHistory: state.choAnHistory,
          chartDataChoAn:
              ChoanChart().handleDataChoAn(state.choAnHistory, state.choAnEnum),
          message: 'Cập nhật dữ liệu thành công',
        ));
      } else {
        emit(state.copyWith(
          isLoading: LoadingStatus.stop,
          message: 'Cập nhật dữ liệu không thành công ${res.status.message}',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onGetHutSua(
    GetHutSuaEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      if (state.hutSua.isEmpty || state.hutSuaByDay.isEmpty) {
        if (state.currentBaby != null) {
          emit(state.copyWith(
            isLoading: LoadingStatus.begin,
            message: null,
          ));
          final hutSua = await _milkV2.getListHutSua();
          final hutSuaByDay = await _milkV2.getListHutSuaByDate(event.date);

          if (hutSua.isOk && hutSuaByDay.isOk) {
            emit(state.copyWith(
              isLoading: LoadingStatus.stop,
              hutSua: hutSua.data,
              hutSuaByDay: hutSuaByDay.data,
            ));
          }
        }
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onGetHutSuaHistory(
    GetHutSuaHistoryEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      if (state.currentBaby != null) {
        emit(state.copyWith(
          isLoading: LoadingStatus.begin,
          message: null,
        ));
        final hutSuaByDay = await _milkV2.getListHutSuaByDate(event.date);

        if (hutSuaByDay.isOk) {
          emit(state.copyWith(
            isLoading: LoadingStatus.stop,
            hutSuaByDay: hutSuaByDay.data,
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onInsertHutSua(
    InsertHutSuaEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: LoadingStatus.begin, message: null));
      if (state.hutSuaByDay.length < 12) {
        final res = await _milkV2.insertHutSua(event.hutSua);
        if (res.isOk) {
          emit(state.copyWith(
            isLoading: LoadingStatus.stop,
            hutSuaByDay: res.data,
            message: 'Thêm dữ liệu thành công',
          ));
          if (checkTheSameDay(event.hutSua.ngayTao!, DateTime.now())) {
            final hutSua = await _milkV2.getListHutSua();
            if (hutSua.isOk) {
              emit(state.copyWith(
                isLoading: LoadingStatus.stop,
                hutSua: hutSua.data,
              ));
            }
          }
        } else {
          emit(state.copyWith(
            isLoading: LoadingStatus.stop,
            message: 'Thêm dữ liệu không thành công ${res.status.message}',
          ));
        }
      } else {
        emit(state.copyWith(
          isLoading: LoadingStatus.stop,
          message:
              'Bạn đã nhập đủ 12 lần của ngày hôm nay. Vui lòng nhập tiếp vào ngày hôm sau',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onDeleteHutSua(
    DeleteHutSuaEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: LoadingStatus.begin, message: null));
      final res = await _milkV2.deleteHutSua(event.maHutSua);
      if (res.isOk) {
        HutSua? tmp;
        HutSua? tmp1;
        state.hutSua.forEach((e) {
          if (e.id == event.maHutSua) tmp = e;
        });
        state.hutSuaByDay.forEach((e) {
          if (e.id == event.maHutSua) tmp1 = e;
        });
        if (tmp != null) {
          state.hutSua.remove(tmp);
        }
        if (tmp1 != null) {
          state.hutSuaByDay.remove(tmp1);
        }
        emit(state.copyWith(
          hutSua: state.hutSua,
          hutSuaByDay: state.hutSuaByDay,
          isLoading: LoadingStatus.stop,
          message: 'Đã xoá thành công',
          popContext: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onUpdateHutSua(
    UpdateHutSuaEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: LoadingStatus.begin, message: null));
      final res = await _milkV2.updateHutSua(event.hutSua);
      if (res.isOk) {
        for (int i = 0; i < state.hutSua.length; i++) {
          if (state.hutSua[i].id == event.hutSua.id) {
            state.hutSua[i] = event.hutSua;
          }
        }
        for (int i = 0; i < state.hutSuaByDay.length; i++) {
          if (state.hutSuaByDay[i].id == event.hutSua.id) {
            state.hutSuaByDay[i] = event.hutSua;
          }
        }
        emit(state.copyWith(
          hutSua: state.hutSua,
          hutSuaByDay: state.hutSuaByDay,
          isLoading: LoadingStatus.stop,
          message: 'Cập nhật dữ liệu thành công',
          popContext: true,
        ));
      } else {
        emit(state.copyWith(
          isLoading: LoadingStatus.stop,
          message: 'Cập nhật dữ liệu không thành công ${res.status.message}',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        message: e.toString(),
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onInsertQrSua(
    InsertQrSua event,
    Emitter<MilkState> emit,
  ) async {
    try {
      emit(state.copyWith(
        isLoading: LoadingStatus.begin,
      ));
      final res = await _milkV2.insertQrSua(event.qrCode);
      if (res.isOk) {
        emit(state.copyWith(
          unlock: true,
          status: LoadedStatus.succes,
          message: res.status.message,
          isLoading: LoadingStatus.stop,
        ));
      } else {
        emit(state.copyWith(
          message: res.status.message,
          status: LoadedStatus.failure,
          isLoading: LoadingStatus.stop,
        ));
      }
    } on DioException catch (e) {
      emit(state.copyWith(
        message: ApiResponseStatus.fromMap(e.response?.data).message,
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onGetPosts(
    GetPostsEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      if (state.posts == null) {
        emit(state.copyWith(
          isLoading: LoadingStatus.begin,
        ));
        final res = await _milkV2.getPosts();
        if (res.isOk) {
          emit(state.copyWith(
            status: LoadedStatus.succes,
            posts: res.data,
            isLoading: LoadingStatus.stop,
          ));
        } else {
          emit(state.copyWith(
            message: res.status.message,
            status: LoadedStatus.failure,
            isLoading: LoadingStatus.stop,
          ));
        }
      }
    } on DioException catch (e) {
      emit(state.copyWith(
        message: ApiResponseStatus.fromMap(e.response?.data).message,
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onGetVideos(
    GetVideosEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      if (state.videos == null) {
        emit(state.copyWith(
          isLoading: LoadingStatus.begin,
        ));
        final res = await _milkV2.getVideos();
        if (res.isOk) {
          emit(state.copyWith(
            status: LoadedStatus.succes,
            videos: res.data,
            isLoading: LoadingStatus.stop,
          ));
        } else {
          emit(state.copyWith(
            message: res.status.message,
            status: LoadedStatus.failure,
            isLoading: LoadingStatus.stop,
          ));
        }
      }
    } on DioException catch (e) {
      emit(state.copyWith(
        message: ApiResponseStatus.fromMap(e.response?.data).message,
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }

  _onGetBlogs(
    GetBlogsEvent event,
    Emitter<MilkState> emit,
  ) async {
    try {
      switch (event.type) {
        case BlogType.quanhe:
          if (state.blogsQuanHe == null) {
            emit(state.copyWith(
              isLoading: LoadingStatus.begin,
            ));
            final res = await _milkV2.getBlogs(event.type.endpoint());
            if (res.isOk) {
              emit(state.copyWith(
                status: LoadedStatus.succes,
                isLoading: LoadingStatus.stop,
                blogsQuanHe: res.data,
              ));
            }
          }
          break;
        case BlogType.biquyet:
          if (state.blogsBiQuyet == null) {
            emit(state.copyWith(
              isLoading: LoadingStatus.begin,
            ));
            final res = await _milkV2.getBlogs(event.type.endpoint());
            if (res.isOk) {
              emit(state.copyWith(
                status: LoadedStatus.succes,
                isLoading: LoadingStatus.stop,
                blogsBiQuyet: res.data,
              ));
            }
          }
          break;
        default:
      }
    } on DioException catch (e) {
      emit(state.copyWith(
        message: ApiResponseStatus.fromMap(e.response?.data).message,
        status: LoadedStatus.failure,
        isLoading: LoadingStatus.stop,
      ));
    }
  }
}
