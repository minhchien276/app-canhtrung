// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_cubit.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/luong_kinh/luongkinh_button_data.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/luong_kinh/luongkinh_button_empty.dart';

class LuongKinhWidget extends StatelessWidget {
  const LuongKinhWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NhatKyCubit>().state;
    return state.luongkinh == null
        ? LuongKinhButtonEmpty()
        : LuongKinhButtonData(state: state);
  }
}
