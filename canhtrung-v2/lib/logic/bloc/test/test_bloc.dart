import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/que_type.dart';
import 'package:flutter_ovumb_app_version1/data/enum/test_result_enum.dart';
import 'package:flutter_ovumb_app_version1/data/handle/test_lh.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/local/local_repository.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/ket_qua_test.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/ketquatest_v2/ketquatest_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/kinhnguyet_v2/kinhnguyet_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/thaiki_v2/thaiki_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/test/test_state.dart';
import 'package:flutter_ovumb_app_version1/logic/test/image_analyze.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_circle.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_added_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/test/test_error_screen.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/device_info.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/toast_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/result_test.dart';
import 'package:flutter_ovumb_app_version1/router/router.dart';
import 'package:flutter_ovumb_app_version1/services/exception.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc()
      : super(TestState(
          isLoading: false,
          videos: [],
          images: [],
          quanLyQueTest: null,
        )) {
    on<TestCheckEvent>(_onCheckExits);
    on<TestQRSubmitEvent>(_onQRSubmit);
    on<TestGuideEvent>(_onGetGuide);
    on<TestSubmitLHEvent>(_onTestSubmitLH);
  }

  final _test = KetQuaTestRepositoryV2();
  final _kinhnguyet = KinhNguyetRepositoryV2();
  final _thaiki = ThaiKiRepositoryV2();
  final _testLH = TestLH();
  final _imageAnalyze = ImageAnalyze();
  final _prefs = SharedPreferencesService();
  final _local = LocalRepository();

  _onCheckExits(
    TestCheckEvent event,
    Emitter<TestState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, isReset: true));
      final res = await _test.serverGetQLQT();
      if (res.isOk) {
        emit(state.copyWith(quanLyQueTest: res.data));
      }
    } on DioException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        status: LoadedStatus.disconnect,
        message: e.messageTr,
      ));
    }
  }

  _onQRSubmit(
    TestQRSubmitEvent event,
    Emitter<TestState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      LoadingCircle().show(context: event.context);
      final res = await _test.serverUpdateHopTest(event.qrcode);
      LoadingCircle().hide();
      if (res.isOk) {
        if (res.data != null) {
          emit(state.copyWith(quanLyQueTest: res.data));
          event.context.pushReplacementNamed(TestAddedScreen.routeName);
        }
      } else {
        emit(state.copyWith(status: LoadedStatus.failure));
        event.context.pushNamed(TestErrorScreen.routeName);
      }
      //event.context.pop();
    } on DioException catch (_) {
      LoadingCircle().hide();
      emit(state.copyWith(status: LoadedStatus.failure));
      event.context.pushNamed(TestErrorScreen.routeName);
    }
  }

  _onGetGuide(
    TestGuideEvent event,
    Emitter<TestState> emit,
  ) async {
    try {
      if (state.videos.isEmpty && state.images.isEmpty) {
        LoadingCircle().show(context: event.context);
        final videos = await _test.serverGetVideos();
        final images = await _test.serverGetImages();
        LoadingCircle().hide();
        if (videos.isOk && images.isOk) {
          emit(state.copyWith(
              videos: videos.data, images: images.data, isNext: event.isNext));
        }
      } else {
        emit(state.copyWith(isNext: false));
        emit(state.copyWith(isNext: event.isNext));
      }
    } on DioException catch (e) {
      LoadingCircle().hide();
      event.context.showErrorToast(e.message ?? e.messageTr);
      emit(state.copyWith(status: LoadedStatus.failure));
    }
  }

  _onTestSubmitLH(
    TestSubmitLHEvent event,
    Emitter<TestState> emit,
  ) async {
    try {
      LoadingDialog().show(context: event.context, text: 'Đang phân tích...');
      emit(state.copyWith(testResult: null, testStatus: TestStatus.begin));
      String device = await DeviceInfo.name();
      int? lh = await _imageAnalyze.splitImage(event.image);
      if (lh != null) {
        KinhNguyet? kinhNguyet = await _kinhnguyet.localGetKN(trangThai: 1);
        NguoiDung nguoiDung = await _local.getNguoiDung(_prefs.id ?? '');

        FormData formData = FormData.fromMap({
          'maNguoiDung': _prefs.id,
          'maQuanLyQueTest': event.maQuanLyQueTest,
          'maLoaiQue': event.queTestType.parseInt(),
          'thoiGian': DateTime.now().millisecondsSinceEpoch,
          'ketQua': lh.toInt(),
          'phase': nguoiDung.phase!,
          'testEnum': _testLH.getMaLoaiLH(lh, event.queTestType),
          'firstDate': kinhNguyet!.ngayBatDau!.millisecondsSinceEpoch,
          'endDate': DateTime.now().millisecondsSinceEpoch,
          'device': device,
        });

        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(
            event.file.path,
            filename: event.file.toString().split('/').last,
            contentType: MediaType.parse(
                lookupMimeType(event.file.path) ?? 'image/jpeg'),
          ),
        ));

        switch (event.queTestType) {
          case QueTestType.trung:
            final res = await _test.serverInsertKQT1(formData);
            LoadingDialog().hide();
            if (res.isOk) {
              await _test.insertKetQuaTest(
                ketQuaTest: KetQuaTest(
                  maKetQuaTest: 0,
                  maLoaiQue: event.queTestType.parseInt(),
                  lanTest: 1,
                  thoiGian: DateTime.now(),
                  ketQua: lh,
                ),
              );
              if (_testLH.checkLH(lh) == TestResultEnum.datdinh) {
                await _kinhnguyet.localResetCKKNWhenTestLH();
              }
              emit(state.copyWith(
                testResult: res.data,
                testStatus: TestStatus.success,
                queTestType: event.queTestType,
              ));
            } else {
              emit(state.copyWith(
                testStatus: TestStatus.failure,
                queTestType: event.queTestType,
              ));
            }
            break;
          case QueTestType.thai:
            final res = await _test.serverInsertKQT1(formData);
            LoadingDialog().hide();
            if (res.isOk) {
              if (_testLH.checkLH(lh) != TestResultEnum.thap) {
                _thaiki.localInsertNgayDuSinh();
              }
              emit(state.copyWith(
                testResult: res.data,
                testStatus: TestStatus.success,
                queTestType: event.queTestType,
              ));
            } else {
              emit(state.copyWith(
                testResult: testResultFailure,
                testStatus: TestStatus.failure,
                queTestType: event.queTestType,
              ));
            }
            break;
          default:
        }
      } else {
        LoadingDialog().hide();
        emit(state.copyWith(
            testResult: testScanFailure, testStatus: TestStatus.failure));
      }
    } on DioException catch (_) {
      LoadingDialog().hide();
      emit(state.copyWith(
        testResult: testResultFailure,
        testStatus: TestStatus.failure,
        queTestType: event.queTestType,
      ));
    }
  }
}
