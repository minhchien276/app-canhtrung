// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/store_location.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/address.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/address/address_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/location/location_repository.dart';
import 'package:flutter_ovumb_app_version1/data/validator/address_validator.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_store.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/shipping/shipping_loading.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/error_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/shipping/shipping_address_input.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/shipping/shipping_city_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/shipping/shipping_district_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/shipping/shipping_ward_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';

String? citySelect = null;
String? districtSelect = null;
String? wardSelect = null;

class ShippingUpdate extends StatefulWidget {
  static const routeName = 'shipping-update';
  final Address address;
  final int length;
  const ShippingUpdate({
    Key? key,
    required this.address,
    required this.length,
  }) : super(key: key);

  @override
  State<ShippingUpdate> createState() => _ShippingUpdateState();
}

class _ShippingUpdateState extends State<ShippingUpdate> {
  final _prefs = SharedPreferencesService();
  bool isAdd = false;
  bool isSwitch = false;
  LocationRepository _locationRepository = LocationRepository();
  AddressRepository _addressRepository = AddressRepository();
  List<StoreLocation> cities = [];
  List<StoreLocation> districts = [];
  List<StoreLocation> wards = [];

  late List<TextEditingController> controllers;
  late List<TextEditingController> controllersId;

  @override
  void initState() {
    controllers = [
      TextEditingController(text: widget.address.provinces),
      TextEditingController(text: widget.address.districts),
      TextEditingController(text: widget.address.wards),
      TextEditingController(text: widget.address.username),
      TextEditingController(text: widget.address.phone),
      TextEditingController(text: widget.address.address_specific),
    ];

    controllersId = [
      TextEditingController(text: widget.address.provinceId.toString()),
      TextEditingController(text: widget.address.districtId.toString()),
      TextEditingController(text: widget.address.wardId.toString()),
    ];

    citySelect = null;
    districtSelect = null;
    wardSelect = null;
    isSwitch = widget.address.status == 1;

    _locationRepository.getProvinces();
    _locationRepository.getDistricts(
        code: widget.address.provinceId.toString());
    _locationRepository.getWards(code: widget.address.districtId.toString());
    super.initState();
  }

  @override
  void dispose() {
    //disposeController();
    super.dispose();
  }

  void disposeController() {
    controllers.forEach((e) {
      e.dispose();
    });
    controllersId.forEach((e) {
      e.dispose();
    });
    citySelect = null;
    districtSelect = null;
    wardSelect = null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 6,
            blurRadius: 9,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chỉnh sửa địa chỉ',
                      style: TextStyle(
                        color: grey700,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nhập thông tin các mục bên dưới',
                      style: TextStyle(
                        color: grey400,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  'assets/images/location_map.png',
                  scale: 3,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Divider(
            color: Color(0xffEBEBEB),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ShippingAddressInput(
                    title: 'Tên người nhận',
                    detail: '',
                    width: size.width,
                    isAdressPicker: false,
                    selectedValue: 'a',
                    controller: controllers[3],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ShippingAddressInput(
                    title: 'Số điện thoại',
                    detail: '',
                    width: size.width,
                    isAdressPicker: false,
                    selectedValue: 'a',
                    controller: controllers[4],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: ShippingAddressInput(
              title: 'Địa chỉ',
              detail: 'a',
              width: size.width,
              isAdressPicker: false,
              selectedValue: '',
              controller: controllers[5],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: StreamBuilder<List<StoreLocation>>(
              stream: _locationRepository.cityStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  cities = [];
                  cities.addAll(snapshot.data!.toList());
                  return ShippingCityPicker(
                    title: 'Thành phố/Tỉnh',
                    detail: '',
                    isAdressPicker: true,
                    cities: cities,
                    controllers: controllers,
                    controllersId: controllersId,
                  );
                }
                return ShippingLoading(title: 'Thành phố/Tỉnh');
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: StreamBuilder<List<StoreLocation>>(
                    stream: _locationRepository.districtStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        districts = [];
                        districts.addAll(snapshot.data!.toList());
                        return ShippingDistrictPicker(
                          title: 'Quận/Huyện',
                          detail: '',
                          isAdressPicker: true,
                          districts: districts,
                          controllers: controllers,
                          controllersId: controllersId,
                        );
                      }
                      return ShippingLoading(title: 'Quận/Huyện');
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: StreamBuilder<List<StoreLocation>>(
                    stream: _locationRepository.wardStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        wards = [];
                        wards.addAll(snapshot.data!.toList());
                        return ShippingWardPicker(
                          title: 'Phường/Xã',
                          detail: '',
                          isAdressPicker: true,
                          wards: wards,
                          controllers: controllers,
                          controllersId: controllersId,
                        );
                      }
                      return ShippingLoading(title: 'Phường/Xã');
                    },
                  ),
                ),
              ],
            ),
          ),
          if (widget.length != 1 && widget.address.status == 0) ...[
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    color: Colors.transparent,
                    child: CupertinoSwitch(
                      activeColor: violet600,
                      value: isSwitch,
                      onChanged: (value) {
                        setState(() {
                          isSwitch = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Đặt làm địa chỉ mặc định',
                    style: TextStyle(
                      color: grey400,
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Padding(
            padding: EdgeInsets.only(top: 22, left: 10, right: 10),
            child: TextButton(
              child: Container(
                height: 50,
                width: size.width,
                decoration: BoxDecoration(
                  color: violet600,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Xác Nhận Địa Chỉ Mới',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              onPressed: () async {
                String? validate = addressValidator(controllers);
                String maNguoiDung = await _prefs.id ?? '';
                if (validate == null) {
                  LoadingStore().show(context: context);
                  bool check = await _addressRepository.update(
                    Address(
                      id: widget.address.id,
                      provinces: controllers[0].text.trim(),
                      districts: controllers[1].text.trim(),
                      wards: controllers[2].text.trim(),
                      username: controllers[3].text.trim(),
                      phone: controllers[4].text.trim(),
                      address_specific: controllers[5].text.trim(),
                      status: isSwitch ? 1 : 0,
                      maNguoiDung: maNguoiDung,
                      provinceId: controllersId[0].text.trim(),
                      districtId: controllersId[1].text.trim(),
                      wardId: controllersId[2].text.trim(),
                    ),
                  );
                  LoadingStore().hide();
                  Navigator.pop(context);
                  if (check) {
                    showStoreSuccessToast(
                        context, 'Cập nhật địa chỉ thành công');
                  } else {
                    showErrorDialog(
                        context, 'Cập nhật địa chỉ không thành công');
                  }
                } else {
                  showToast(context, validate, seconds: 3);
                }
              },
            ),
          ),
          TextButton(
            child: Container(
              height: 40,
              width: size.width,
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/trash.png',
                    scale: 3,
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Xóa địa chỉ',
                    style: TextStyle(
                      color: rose500,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () async {
              LoadingStore().show(context: context);
              bool check = await _addressRepository.delete(widget.address.id);
              LoadingStore().hide();
              if (check) {
                showStoreSuccessToast(context, 'Xóa địa chỉ thành công');
                Navigator.pop(context);
              } else {
                showErrorDialog(context, 'Xóa địa chỉ không thành công');
              }
            },
          ),
        ],
      ),
    );
  }
}
