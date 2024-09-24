import 'dart:async';
import 'dart:convert';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/store_location.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';

class LocationProvider {
  final _dio = BaseService.instance.dio;
  static final LocationProvider _instance = LocationProvider._internal();
  factory LocationProvider() {
    return _instance;
  }
  LocationProvider._internal();
  final StreamController<List<StoreLocation>> _cityController =
      StreamController.broadcast();
  final StreamController<List<StoreLocation>> _districtController =
      StreamController.broadcast();
  final StreamController<List<StoreLocation>> _wardController =
      StreamController.broadcast();

  //get provinces
  Future<List<StoreLocation>> getProvinces() async {
    try {
      final response = await _dio.get(vnUnitGetCity);
      if (response.statusCode == 200) {
        List x = response.data['data'];
        List<StoreLocation> location =
            x.map((e) => StoreLocation.fromJson(jsonEncode(e))).toList();
        _cityController.add(location);
        return location;
      }
      return [];
    } catch (e) {
      throw e;
    }
  }

  //get districts
  Future<List<StoreLocation>> getDistricts(
    String? provinceCode,
  ) async {
    try {
      if (provinceCode != null) {
        final response = await _dio.get('$vnUnitGetDistrict/$provinceCode');
        if (response.statusCode == 200) {
          List x = response.data['data'];
          List<StoreLocation> location =
              x.map((e) => StoreLocation.fromJson(jsonEncode(e))).toList();
          _districtController.add(location);
          return location;
        }
      } else {
        _districtController.add([]);
      }
      return [];
    } catch (e) {
      throw e;
    }
  }

  //get wards
  Future<List<StoreLocation>> getWards(
    String? provinceCode,
  ) async {
    try {
      if (provinceCode != null) {
        final response = await _dio.get('$vnUnitGetWard/$provinceCode');
        if (response.statusCode == 200) {
          List x = response.data['data'];
          List<StoreLocation> location =
              x.map((e) => StoreLocation.fromJson(jsonEncode(e))).toList();
          _wardController.add(location);
          return location;
        }
      } else {
        _wardController.add([]);
      }
      return [];
    } catch (e) {
      throw e;
    }
  }

  Stream<List<StoreLocation>> cityStream() => _cityController.stream;
  Stream<List<StoreLocation>> districtStream() => _districtController.stream;
  Stream<List<StoreLocation>> wardStream() => _wardController.stream;
}
