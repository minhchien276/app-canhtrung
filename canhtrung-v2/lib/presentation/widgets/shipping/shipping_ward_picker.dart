// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/store_location.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/shipping/shipping_add.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class ShippingWardPicker extends StatefulWidget {
  final String title;
  final String detail;
  final bool isAdressPicker;
  final List<StoreLocation> wards;
  List<TextEditingController> controllers;
  List<TextEditingController> controllersId;

  ShippingWardPicker({
    Key? key,
    required this.title,
    required this.detail,
    required this.isAdressPicker,
    required this.wards,
    required this.controllers,
    required this.controllersId,
  }) : super(key: key);

  @override
  State<ShippingWardPicker> createState() => _ShippingWardPickerState();
}

class _ShippingWardPickerState extends State<ShippingWardPicker> {
  String? selectedCity = null;

  @override
  void initState() {
    if (widget.controllers[2].text != '') {
      wardSelect = widget.controllers[2].text;
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
                underline: SizedBox(),
                iconSize: 0,
                isExpanded: true,
                value: wardSelect,
                items: widget.wards.map((city) {
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
                      widget.controllersId[2].text = city.code;
                    },
                  );
                }).toList(),
                onChanged: (value) {
                  wardSelect = value!;
                  widget.controllers[2].text = wardSelect!;
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
