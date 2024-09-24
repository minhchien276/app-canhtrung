// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/kinh_nguyet.dart';
import 'package:flutter_ovumb_app_version1/data/models/question/question.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/nhatky/nhatky_cubit.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/question/question_input_scroll_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/color.dart';

class ProfileUpdateKNScreen extends StatefulWidget {
  static const routeName = 'question-update-kn-screen';
  final KinhNguyet kinhNguyet;
  const ProfileUpdateKNScreen({
    Key? key,
    required this.kinhNguyet,
  }) : super(key: key);

  @override
  State<ProfileUpdateKNScreen> createState() => _ProfileUpdateKNScreenState();
}

class _ProfileUpdateKNScreenState extends State<ProfileUpdateKNScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PageController controller = PageController();
  late TextEditingController _tbnkn;
  late TextEditingController _snck;

  @override
  void initState() {
    super.initState();
    _tbnkn = TextEditingController(text: widget.kinhNguyet.tbnkn.toString());
    _snck = TextEditingController(text: widget.kinhNguyet.snck.toString());
  }

  @override
  void dispose() {
    _tbnkn.dispose();
    _snck.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: kBackButton(context),
        title: BuildText(
          text: 'Cập nhật thông tin',
          style: 18.text600,
          color: greyText,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                80.verticalSpace,
                BuildText(
                  text: 'Hãy để OvumB hiểu hơn về bạn',
                  style: 22.text700,
                  textAlign: TextAlign.center,
                  color: rose400,
                ),
                6.verticalSpace,
                BuildText(
                  text:
                      'Thông tin bạn cung cấp cần đảm bảo độ chuẩn xác để được hỗ trợ 1 cách toàn diện nhất',
                  style: 15.text400,
                  textAlign: TextAlign.center,
                  color: greyText,
                  maxLines: 3,
                ),
                30.verticalSpace,
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                QuestionInputScrollPicker(
                  text: listQuestion[0].title,
                  controller: _tbnkn,
                  beginNumber: 21,
                  endNumber: 91,
                  subtext: listQuestion[0].sub,
                ),
                10.verticalSpace,
                QuestionInputScrollPicker(
                  text: listQuestion[1].title,
                  controller: _snck,
                  beginNumber: 1,
                  endNumber: 8,
                  subtext: listQuestion[1].sub,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: KSubmitButton(
              size: Size(context.width, 50.h),
              text: 'Cập nhật',
              onTap: () => context.read<NhatKyCubit>().updateCKKNNow(
                    context: context,
                    kinhnguyetNow: widget.kinhNguyet,
                    tbnkn: int.parse(_tbnkn.text),
                    snck: int.parse(_snck.text),
                  ),
            ),
          ),
          70.verticalSpace,
        ],
      ),
    );
  }
}
