

import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/validator/validator.dart';

String? addressValidator(List<TextEditingController> _listController) {
  if (checkEmpty(_listController)) {
    if (!checkPhoneNumber(_listController[4].text)) {
      return 'Số điện thoại không hợp lệ';
    } 
    return null;
  }
  return 'Vui lòng nhập đủ thông tin';
}
