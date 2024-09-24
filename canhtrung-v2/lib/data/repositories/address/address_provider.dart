import 'dart:async';
import 'dart:convert';
import 'package:flutter_ovumb_app_version1/data/api_url/api_url.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/address.dart';
import 'package:flutter_ovumb_app_version1/services/base_service.dart';
import 'package:rxdart/rxdart.dart';

class AddressProvider {
  final _dio = BaseService.instance.dio;
  static final AddressProvider _instance = AddressProvider._internal();
  factory AddressProvider() {
    return _instance;
  }
  AddressProvider._internal();

  final _addressController = ReplaySubject<List<Address>>(maxSize: 1);
  final _prefs = SharedPreferencesService();

  //cart product stream
  Stream<List<Address>> get addressStream => _addressController.stream;
  Sink<List<Address>> get addressSink => _addressController.sink;

  // lấy tat ca dia chi
  Future<List<Address>?> getAllAddress() async {
    try {
      final maNguoiDung = await _prefs.id;
      List<Address> address = [];

      final response = await _dio.get(
        '$addressGetAll/$maNguoiDung',
      );
      if (response.statusCode == 200) {
        List x = response.data['data'];
        if (x.isNotEmpty) {
          address = x.map((e) => Address.fromJson(jsonEncode(e))).toList();
        }
        addressSink.add(address);
        return address;
      }
      return address;
    } catch (e) {
      return null;
    }
  }

  // insert address
  Future<bool> insert(Address address) async {
    try {
      final response = await _dio.post(
        '$addressInsert',
        data: address.toJson(),
      );
      if (response.statusCode == 200) {
        getAllAddress();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // update address
  Future<bool> update(Address address) async {
    try {
      final maNguoiDung = await _prefs.id;

      final response = await _dio.post(
        '$addressUpdate/${address.id}/$maNguoiDung',
        data: address.toJson(),
      );
      if (response.statusCode == 200) {
        getAllAddress();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // update address status
  Future<bool> updateStatus(int addressId) async {
    try {
      final maNguoiDung = await _prefs.id;

      print('$addressUpdateStatus/$addressId/$maNguoiDung');

      final response =
          await _dio.post('$addressUpdateStatus/$addressId/$maNguoiDung');
      if (response.statusCode == 200) {
        getAllAddress();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // delete address
  Future<bool> delete(int addressId) async {
    try {
      final maNguoiDung = await _prefs.id;

      final response =
          await _dio.post('$addressDelete/$addressId/$maNguoiDung');
      if (response.statusCode == 200) {
        getAllAddress();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
