import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_event.dart';

class Validator {
  static bool isEmpty(List<String> values) {
    for (var value in values) {
      if (value.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }

  static String? register(AuthEventRegister event) {
    if (isEmpty([
      event.phone,
      event.password,
      event.repassword,
      event.name,
      event.email,
      event.dob
    ])) {
      if (!checkPhoneNumber(event.phone)) {
        return 'Số điện thoại không hợp lệ';
      } else if (!checkPassword(event.password)) {
        return 'Mật khẩu không được chứa kí tự đặc biệt';
      } else if (!checkLength(event.password)) {
        return 'Mật khẩu phải có độ dài từ 6 kí tự trở lên';
      } else if (event.password != event.repassword) {
        return 'Mật khẩu không khớp';
      } else if (!checkBirth(event.dob)) {
        return 'Năm sinh không hợp lệ';
      } else if (!checkEmail(event.email)) {
        return 'Email không hợp lệ';
      } else if (event.name.trim().length > 30) {
        return 'Họ và tên vượt quá độ dài 30 ký tự';
      } else if (!event.isVerify) {
        return 'Vui lòng đồng ý với Chính sách và Bảo mật';
      } else {
        return null;
      }
    }
    return 'Vui lòng nhập đủ thông tin';
  }

  static String? resetPwd(String email) {
    if (isEmpty([email])) {
      if (!checkEmail(email)) {
        return 'Email không hợp lệ';
      } else {
        return null;
      }
    }
    return 'Vui lòng nhập đủ thông tin';
  }

  static updateUser(List<String> values) {
    if (isEmpty([values[0]])) {
      if (!checkCanNang(values[1])) {
        return 'Cân nặng không hợp lệ';
      } else if (!checkChieuCao(values[2])) {
        return 'Chiều cao không hợp lệ';
      }
      if (values[0].length > 40) {
        return 'Tên không được vượt quá 40 ký tự';
      } else {
        return null;
      }
    } else {
      return 'Tên không được bỏ trống';
    }
  }
}

mixin InputValidationMixin {
  bool isNumberValid(String text) {
    String pattern = r'^[0-9]*$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(text);
  }
}

bool checkEmpty(List<TextEditingController> listController) {
  for (TextEditingController controller in listController) {
    if (controller.text.trim().isEmpty) {
      return false;
    }
  }
  return true;
}

bool checkBirth(String birth) {
  if (int.tryParse(birth) is num && birth.length == 4) {
    return true;
  }
  return false;
}

bool checkCanNang(String canNang) {
  if (double.tryParse(canNang) is num &&
      double.parse(canNang) > 1 &&
      double.parse(canNang) < 120) {
    return true;
  }
  return false;
}

bool checkChieuCao(String chieuCao) {
  if (double.tryParse(chieuCao) is num &&
      double.parse(chieuCao) > 20 &&
      double.parse(chieuCao) < 250) {
    return true;
  }
  return false;
}

bool checkPhoneNumber(String phone) {
  RegExp phoneRegex = RegExp(r'(0[3|5|7|8|9]\d{8}|(?:\+?84|\b84)\d{9})$');
  if (phoneRegex.hasMatch(phone)) {
    return true;
  }
  return false;
}

bool checkEmail(String email) {
  RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (checkNoVietnameseDiacritics(email)) {
    if (emailRegex.hasMatch(email)) {
      return true;
    }
    return false;
  }
  return false;
}

bool checkPassword(String password) {
  RegExp passwordRegex = RegExp(r'^[a-zA-Z0-9]+$');
  bool isValidPhoneNumber = passwordRegex.hasMatch(password);
  return isValidPhoneNumber;
}

bool checkLength(String string) {
  return string.length > 5 ? true : false;
}

bool checkNoVietnameseDiacritics(String input) {
  RegExp diacriticsRegex = RegExp(
      r'[áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđ]');

  if (diacriticsRegex.hasMatch(input)) {
    return false;
  }

  return true;
}
