// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_shipping.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/address.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/address/address_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_store.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/shipping/shipping_update.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/dialog/error_dialog.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/shipping/shipping_status.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/shipping/shipping_textImage.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';

class ShippingAddress extends StatefulWidget {
  final Address address;
  final int length;
  final double height;
  ShippingAddress({
    Key? key,
    required this.address,
    required this.length,
    required this.height,
  }) : super(key: key);

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  AddressRepository _addressRepository = AddressRepository();
  String currentOption = dataShipping[0].option;

  String parseAddress(Address address) {
    return '${address.address_specific}, ${address.wards}, ${address.districts}, ${address.provinces}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 30),
      height: 150,
      width: size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 6,
            blurRadius: 9,
            offset: Offset(2, 2),
          ),
        ],
      ),
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 5, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    if (widget.address.status == 0) {
                      LoadingStore().show(context: context);
                      bool check = await _addressRepository.updateStatus(
                          addressId: widget.address.id);
                      LoadingStore().hide();
                      if (check) {
                        showStoreSuccessToast(
                            context, 'Cập nhật địa chỉ thành công');
                      } else {
                        showErrorDialog(
                            context, 'Cập nhật địa chỉ không thành công');
                      }
                    }
                  },
                  child: Container(
                    width: 50,
                    child: Image.asset(
                      widget.address.status == 1
                          ? 'assets/stores/check.png'
                          : 'assets/stores/un_check.png',
                      scale: 3,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.address.username,
                              style: TextStyle(
                                color: grey700,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 15),
                          Container(
                            width: 2.0,
                            height: 20.0,
                            color: grey200,
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              widget.address.phone,
                              style: TextStyle(
                                color: grey700,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        parseAddress(widget.address),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: grey400,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: size.width * 0.06,
                  height: 60,
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: Image.asset(
                      'assets/stores/location_penedit.png',
                      scale: 3,
                    ),
                    onTap: () {
                      dataShipping[0].isDeleted = true;
                      setState(() {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          barrierColor: Colors.white.withOpacity(0.001),
                          backgroundColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            return Container(
                              height: widget.height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: ShippingUpdate(
                                address: widget.address,
                                length: widget.length,
                              ),
                            );
                          },
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(color: grey200),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShippingTextImage(
                  image: 'assets/stores/location_km.png',
                  number: '',
                  text: 'km',
                  color: rose400,
                ),
                SizedBox(width: 5),
                Container(
                  width: 2.0,
                  height: 20.0,
                  color: grey200,
                ),
                SizedBox(width: 5),
                ShippingTextImage(
                  image: 'assets/stores/location_alarm.png',
                  number: '',
                  text: 'ngày',
                  color: grey400,
                ),
                SizedBox(width: size.width * 0.1),
                ShippingStatus(
                  text: widget.address.status == 1 ? 'Mặc định' : 'Địa chỉ phụ',
                  colorText: widget.address.status == 1
                      ? violet500
                      : Color(0xffEDA177),
                  colorBackground: widget.address.status == 1
                      ? violet100
                      : Color(0xffFFF5EB),
                  width: 75,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
