import 'package:flutter/material.dart';

class AddressWidgetShimmer extends StatelessWidget {
  const AddressWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: 40,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 15,
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.black,
            ),
          ),
          Container(
            height: 15,
            width: size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
