// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_ovumb_app_version1/data/models/phase3/connnnn.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/phattriencon.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/phattrien/phattrien_chitiet.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/phattrien/phattrien_input.dart';

class PhatTrien extends StatefulWidget {
  final int widgetId;
  final Con? con;
  final List<PhatTrienCon> phatTrienCon;
  const PhatTrien({
    Key? key,
    required this.widgetId,
    required this.con,
    required this.phatTrienCon,
  }) : super(key: key);

  @override
  State<PhatTrien> createState() => _PhatTrienState();
}

class _PhatTrienState extends State<PhatTrien> {
  double a = 12.0;
  RegExp regExp = RegExp(r'([.]*0)(?!.*\d)');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      PhatTrienInput(),
      PhatTrienChiTiet(),
    ];
    return widgets[context.watch<MilkBloc>().state.indexPhatTrien];
  }
}

class ChartData {
  ChartData(
    this.x,
    this.y,
    this.date,
  );
  final String x;
  final num y;
  final DateTime? date;
}
