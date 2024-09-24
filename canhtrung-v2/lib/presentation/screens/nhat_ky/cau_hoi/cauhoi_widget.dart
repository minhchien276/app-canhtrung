import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_nhatky.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_cubit.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/cau_hoi/cauhoi_button_data.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/nhat_ky/cau_hoi/cauhoi_button_empty.dart';

class CauHoiWidget extends StatefulWidget {
  const CauHoiWidget({super.key});

  @override
  State<CauHoiWidget> createState() => _CauHoiWidgetState();
}

class _CauHoiWidgetState extends State<CauHoiWidget> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NhatKyCubit>().state;

    return Container(
      //color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      //height: screenSize.height,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: question.length,
        itemBuilder: (BuildContext context, int index) {
          return state.answers[index].data == null
              ? CauHoiButtonEmpty(index: index)
              : CauhoiButtonData(index: index, state: state);
        },
      ),
    );
  }
}
