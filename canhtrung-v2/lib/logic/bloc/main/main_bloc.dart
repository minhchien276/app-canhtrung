import 'package:dio/dio.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/blog/blog.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/thai_ki.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/blog/blog_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/kinhnguyet_v2/kinhnguyet_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/nguoidung_v2/nguoidung_repository_v2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/test/test_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/tvv/tvv_repository.dart';
import 'package:flutter_ovumb_app_version1/data/validator/validator.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/chart/chart_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/datetime_format.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/toast_extension.dart';
import 'package:flutter_ovumb_app_version1/services/exception.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc()
      : super(MainState(
          listCauHoi: [],
          ketQuaTest: {},
          blogTypes: [],
          blogs: [],
          tvv: [],
        )) {
    on<HomeEvent>(_onHome);
    on<ChartEvent>(_onChart);
    on<CalendarEvent>(_onCalendar);
    on<ProfileEvent>(_onProfile);
    on<ProfileUpdateEvent>(_onProfileUpdate);
    on<NgayDuSinhCheckEvent>(_onCheckNgayDuSinh);
    on<GetBlogsEvent>(_onGetBlogs);
    on<GetTvvEvent>(_onGetTvv);
  }

  final _prefs = SharedPreferencesService();
  final _localRepository = LocalRepository();
  final _tvvRepository = TVVRepository();
  final _kinhnguyet = KinhNguyetRepositoryV2();
  final _testRepository = TestRepository();
  final _userRepository = NguoiDungRepositoryV2();
  final _blogRepository = BlogRepository();

  _onHome(
    HomeEvent event,
    Emitter<MainState> emit,
  ) async {
    final id = await _prefs.id;
    if (id != null) {
      final user = await _localRepository.getNguoiDung(id);
      final listCauHoi = await _localRepository.getListCauHoi();
      emit(state.copyWith(user: user, listCauHoi: listCauHoi));
    }
  }

  _onChart(
    ChartEvent event,
    Emitter<MainState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final res = await _testRepository.getKQTests();
      List<KinhNguyet> listKN = await _kinhnguyet.localGetListKN();
      Map<String, List<ChartLHData>> data = {};
      List<ChartPeriod> chartPeriod = [];
      for (var kn in listKN) {
        if (kn.trangThai != 2) {
          String period = periodBeginAndEnd(kn.ngayBatDau!, kn.ngayKetThuc!);
          chartPeriod.add(ChartPeriod(
            begin: kn.ngayBatDau!.formatStartDate(),
            end: kn.ngayKetThuc!.formatEndDate(),
            period: period,
          ));
        }
      }
      if (res.isOk) {
        for (var e in res.data.reversed) {
          for (var p in chartPeriod) {
            if (e.thoiGian.isAfter(p.begin) && e.thoiGian.isBefore(p.end)) {
              String x = e.thoiGian.formatDayMonth();
              if (data[p.period] == null) {
                data[p.period] = [ChartLHData(x, e.ketQua, e.thoiGian)];
              } else {
                data[p.period]!.add(ChartLHData(x, e.ketQua, e.thoiGian));
              }
            }
          }
        }
      }
      emit(state.copyWith(ketQuaTest: data));
    } on DioException catch (e) {
      event.context.showErrorToast(e.messageTr);
    }
  }

  _onCalendar(
    CalendarEvent event,
    Emitter<MainState> emit,
  ) {}

  _onProfile(
    ProfileEvent event,
    Emitter<MainState> emit,
  ) {}

  _onProfileUpdate(
    ProfileUpdateEvent event,
    Emitter<MainState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      String? validate =
          Validator.updateUser([event.name, event.weight, event.height]);
      if (validate == null) {
        FormData formData = FormData.fromMap({
          'tenNguoiDung': event.name,
          'canNang': int.parse(event.weight),
          'chieuCao': int.parse(event.height),
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

        final res = await _userRepository.updateUser(formData);

        final user = state.user!.copyWith(
          tenNguoiDung: event.name,
          canNang: int.parse(event.weight),
          chieuCao: int.parse(event.height),
          avatar: res.data,
        );

        if (res.isOk) {
          _localRepository.updateNguoiDung(user);
          event.context.showSuccessToast('Cập nhật thông tin thành công');
          emit(state.copyWith(user: user));
        }
      } else {
        event.context.showToast(validate);
      }
      emit(state.copyWith(isLoading: false));
    } on DioException catch (e) {
      emit(state.copyWith(isLoading: false));
      event.context.showErrorToast(e.messageTr);
    }
  }

  _onCheckNgayDuSinh(
    NgayDuSinhCheckEvent event,
    Emitter<MainState> emit,
  ) async {
    final id = await _prefs.id;
    if (id != null) {
      ThaiKi thaiKi = await _localRepository.getThaiKi(maNguoiDung: id);
      if (thaiKi.ngayDuSinh != null) {
        emit(state.copyWith(ngayDuSinh: thaiKi.ngayDuSinh));
      } else {
        emit(state.copyWith(ngayDuSinh: null));
      }
    }
  }

  _onGetBlogs(
    GetBlogsEvent event,
    Emitter<MainState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final types = await _blogRepository.getTypeBlog(event.phase);
      if (types.isOk && types.data.isNotEmpty) {
        List<List<Blog>> listBlogs = [];
        for (int i = 0; i < types.data.length; i++) {
          final blogs = await _blogRepository.getBlogs(types.data[i].id);
          if (blogs.isOk) {
            listBlogs.add(blogs.data);
          }
        }
        for (int i = 0; i < types.data.length; i++) {
          if (listBlogs[i].isEmpty) {
            listBlogs.removeAt(i);
            types.data.removeAt(i);
          }
        }
        emit(state.copyWith(
          blogTypes: types.data,
          blogs: listBlogs,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } on DioException catch (e) {
      emit(state.copyWith(isLoading: false));
      event.context.showErrorToast(e.messageTr);
    }
  }

  _onGetTvv(
    GetTvvEvent event,
    Emitter<MainState> emit,
  ) async {
    try {
      PhaseEnum phase = PhaseEnum.getPhase(state.user!.phase);
      int type = 4;
      if (phase == PhaseEnum.trung) {
        type = 24;
      } else if (phase == PhaseEnum.antoan) {
        type = 4;
      } else if (phase == PhaseEnum.vithanhnien) {
        type = 14;
      }
      final res = await _tvvRepository.getTVV(type);
      if (res.isOk) {
        emit(state.copyWith(tvv: res.data));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } on DioException catch (e) {
      emit(state.copyWith(isLoading: false));
      event.context.showErrorToast(e.messageTr);
    }
  }
}
