import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

String randomUser() => 'User' + (Random().nextInt(999999) + 100000).toString();

extension Space on int {
  SizedBox get horizontalSpace => SizedBox(width: this.h.toDouble());
  SizedBox get verticalSpace => SizedBox(height: this.h.toDouble());
}
