// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/palette.dart';

class NhatKyCheckBox extends StatefulWidget {
  final NhatKyState state;
  final int titleId;
  const NhatKyCheckBox({
    Key? key,
    required this.state,
    required this.titleId,
  }) : super(key: key);

  @override
  State<NhatKyCheckBox> createState() => _NhatKyCheckBoxState();
}

class _NhatKyCheckBoxState extends State<NhatKyCheckBox> {
  @override
  Widget build(BuildContext context) {
    List<String> getchecklist() {
      List<String> list = [];
      for (int i = 0;
          i < widget.state.answers[widget.titleId].checkbox.length;
          i++) {
        if (widget.state.answers[widget.titleId].checkbox[i]) {
          list.add(widget.state.answers[widget.titleId].detailTitle[i]);
        }
      }
      return list;
    }

    Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: 30,
      width: screenSize.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: getchecklist().length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              height: 25,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: Palette.textColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                getchecklist()[i],
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
