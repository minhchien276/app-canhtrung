// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/store_location.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/location/location_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/shipping/shipping_add.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class ShippingDistrictPicker extends StatefulWidget {
  final String title;
  final String detail;
  final bool isAdressPicker;
  final List<StoreLocation> districts;
  List<TextEditingController> controllers;
  List<TextEditingController> controllersId;

  ShippingDistrictPicker({
    Key? key,
    required this.title,
    required this.detail,
    required this.isAdressPicker,
    required this.districts,
    required this.controllers,
    required this.controllersId,
  }) : super(key: key);

  @override
  State<ShippingDistrictPicker> createState() => _ShippingDistrictPickerState();
}

class _ShippingDistrictPickerState extends State<ShippingDistrictPicker> {
  LocationRepository _locationRepository = LocationRepository();

  @override
  void initState() {
    if (widget.controllers[1].text != '') {
      districtSelect = widget.controllers[1].text;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              color: grey700,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Color(0xfffafafa),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Color(0xffebebeb)),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: DropdownButton<String>(
                isExpanded: true,
                underline: SizedBox(),
                iconSize: 0,
                value: districtSelect,
                items: widget.districts.map((city) {
                  return DropdownMenuItem<String>(
                    value: city.fullName,
                    child: TitleText(
                      text: city.fullName,
                      fontWeight: FontWeight.w400,
                      size: 18,
                      color: grey400,
                      maxLines: 1,
                    ),
                    onTap: () {
                      widget.controllersId[1].text = city.code;
                      widget.controllersId[2].text = '';
                      _locationRepository.getWards(code: city.code);
                    },
                  );
                }).toList(),
                onChanged: (value) {
                  wardSelect = null;
                  districtSelect = value!;
                  widget.controllers[1].text = districtSelect!;
                  widget.controllers[2].text = '';
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
