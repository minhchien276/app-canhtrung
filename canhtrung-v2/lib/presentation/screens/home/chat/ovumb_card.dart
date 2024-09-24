// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_ovumb_app_version1/data/enum/message_enum.dart';

import 'package:flutter_ovumb_app_version1/data/models/chat/message_model.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/chat/chat_repository.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class OvumbCard extends StatelessWidget {
  final MessageModel message;
  const OvumbCard({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width - 100;
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.asset(
              IconApp.support,
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: EdgeInsets.only(bottom: 4),
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                  minHeight: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(2),
                  ),
                ),
                child: TitleText(
                  text:
                      'Chào Hiệp! Mời bạn bấm vào các nút bên dưới để khám phá các tính năng mà mình hỗ trợ nhé!',
                  fontWeight: FontWeight.w500,
                  size: 14,
                  color: whiteColor,
                  maxLines: 100,
                ),
              ),
              if (message.questions != null) ...[
                const SizedBox(height: 10),
                // if (message.index == 1) ...[
                //   ovumbGridView(message.questions!),
                // ],
                // if (message.index == 2) ...[
                //   Column(
                //     children: [
                //       Container(
                //         constraints: BoxConstraints(
                //           minHeight: 30,
                //         ),
                //         child: TitleText(
                //           text: 'Thay đổi độ dài chu kỳ kinh nguyệt',
                //           fontWeight: FontWeight.w400,
                //           size: 12,
                //           color: grey700,
                //           maxLines: 100,
                //         ),
                //       ),
                //     ],
                //   ),
                // ],
                Row(
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 30,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(color: grey300),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: TitleText(
                          text: 'Thay đổi độ dài chu kỳ kinh nguyệt',
                          fontWeight: FontWeight.w400,
                          size: 12,
                          color: grey700,
                          maxLines: 100,
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 30,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(color: grey300),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: TitleText(
                          text: 'Thay đổi độ dài chu kỳ kinh nguyệt',
                          fontWeight: FontWeight.w400,
                          size: 12,
                          color: grey700,
                          maxLines: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget ovumbGridView(List<OvumbCardModel> data) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        data.length ~/ 2,
        (index) => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            questionCard(data[index]),
            questionCard(data[index + 1]),
          ],
        ),
      ));

  Widget questionCard(OvumbCardModel item) => InkWell(
        onTap: () {
          ChatRepository().sendMessage(
            MessageModel(
              senderType: SenderType.user,
              text: item.text,
              index: 1,
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4),
          margin: EdgeInsets.only(bottom: 6, left: 6),
          width: 140,
          constraints: BoxConstraints(
            minHeight: 46,
          ),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(2),
            ),
            border: Border.all(color: grey300),
          ),
          child: Row(
            children: [
              Container(
                height: 20,
                margin: EdgeInsets.symmetric(horizontal: 6),
                child: Image.asset('assets/icons/chu_thich3.png'),
              ),
              Expanded(
                child: TitleText(
                  text: item.text,
                  fontWeight: FontWeight.w400,
                  size: 12,
                  color: grey700,
                  maxLines: 100,
                ),
              ),
            ],
          ),
        ),
      );
}

class OvumbCardModel {
  final int id;
  final String text;
  OvumbCardModel({
    required this.id,
    required this.text,
  });
}

final List<OvumbCardModel> ovumbCardData = [
  OvumbCardModel(id: 1, text: 'Hỗ trợ chu kỳ kinh nguyệt'),
  OvumbCardModel(id: 2, text: 'Hỗ trợ tính năng test'),
  OvumbCardModel(id: 3, text: 'Liên hệ tư vấn viên'),
  OvumbCardModel(id: 4, text: 'Liên hê kỹ thuật viên'),
];

final List<OvumbCardModel> ovumbType1 = [
  OvumbCardModel(id: 1, text: 'Thay đổi độ dài chu kỳ kinh nguyệt'),
  OvumbCardModel(id: 2, text: 'Chỉnh ngày bắt đầu có kinh'),
  OvumbCardModel(id: 3, text: 'Liên hệ tư vấn viên'),
  OvumbCardModel(id: 4, text: 'Liên hê kỹ thuật viên'),
];

List<MessageModel> chatList = [
  MessageModel(
    id: 1,
    index: 1,
    text:
        'Chào Hiệp! Mời bạn bấm vào các nút bên dưới để khám phá các tính năng mà mình hỗ trợ nhé!',
    questions: ovumbCardData,
    senderType: SenderType.ovumb,
  ),
  MessageModel(
    id: 1,
    index: 2,
    text: 'Vui lòng chọn chi tiết hỗ trợ',
    questions: ovumbCardData,
    senderType: SenderType.ovumb,
  ),
];
