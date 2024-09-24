// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_ovumb_app_version1/data/models/chat/message_model.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class UserCard extends StatelessWidget {
  final MessageModel message;
  const UserCard({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              constraints: BoxConstraints(
                maxWidth: screenSize.width - 100,
                minHeight: 30,
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    text: message.text ?? '',
                    fontWeight: FontWeight.w500,
                    size: 14,
                    color: whiteColor,
                    maxLines: 100,
                  ),
                  // if (message.image != null && message.image != '') ...[
                  //   const SizedBox(height: 6),
                  //   networkImageWithCached(
                  //     size: Size(screenSize.width - 100, 300),
                  //     url: message.image,
                  //     borderRadius: 0,
                  //   ),
                  // ],
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              height: 36,
              width: 36,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(
                IconApp.user,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
