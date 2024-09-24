// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/enum/phase_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/question/question.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/auth/auth_event.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/indicator.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/question/question_date_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/question/question_input_scroll_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionMainScreen extends StatefulWidget {
  static const routeName = 'question-main-screen';
  final PhaseEnum phase;
  const QuestionMainScreen({
    Key? key,
    required this.phase,
  }) : super(key: key);

  @override
  State<QuestionMainScreen> createState() => _QuestionMainScreenState();
}

class _QuestionMainScreenState extends State<QuestionMainScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = PageController();
  int _currentIndex = 0;
  late TextEditingController _cknn;
  late TextEditingController _ckdn;
  late TextEditingController _snck;
  late TextEditingController _date;

  @override
  void initState() {
    _cknn = TextEditingController();
    _ckdn = TextEditingController();
    _snck = TextEditingController();
    _date = TextEditingController();

    _cknn.addListener(_onListener);
    _ckdn.addListener(_onListener);
    super.initState();
  }

  @override
  void dispose() {
    _cknn.dispose();
    _ckdn.dispose();
    _snck.dispose();
    _date.dispose();

    _ckdn.removeListener(_onListener);
    _ckdn.removeListener(_onListener);
    super.dispose();
  }

  _onListener() {
    setState(() {});
  }

  _buildBody1() {
    return Column(
      children: [
        QuestionInputScrollPicker(
          text: listQuestion[3].title,
          controller: _cknn,
          beginNumber: 21,
          endNumber: _ckdn.text.isNotEmpty ? int.parse(_ckdn.text) : 90,
          subtext: listQuestion[3].sub,
        ),
        6.verticalSpace,
        QuestionInputScrollPicker(
          text: listQuestion[4].title,
          controller: _ckdn,
          beginNumber: _cknn.text.isNotEmpty ? int.parse(_cknn.text) + 1 : 22,
          endNumber: 91,
          subtext: listQuestion[4].sub,
        ),
      ],
    );
  }

  _buildBody2() {
    return Column(
      children: [
        QuestionInputScrollPicker(
          text: listQuestion[1].title,
          controller: _snck,
          beginNumber: 1,
          endNumber: 8,
          subtext: listQuestion[1].sub,
        ),
        6.verticalSpace,
        QuestionDateScrollPicker(
          context: context,
          listQuestion: listQuestion,
          date: _date,
        ),
      ],
    );
  }

  handleSubmitPressed(int len) {
    if (_currentIndex == len - 1) {
      context.read<AuthBloc>().add(AuthEventInsertKinhNguyet(
            context,
            snck: _snck.text,
            ckdn: _ckdn.text,
            cknn: _cknn.text,
            ngayBatDau: _date.text,
            phase: widget.phase,
          ));
    } else {
      controller.animateToPage(
        _currentIndex + 1,
        curve: Curves.easeInOut,
        duration: const Duration(
          milliseconds: 300,
        ),
      );
    }
  }

  handleBackPressed() {
    if (_currentIndex != 0) {
      controller.animateToPage(
        _currentIndex - 1,
        curve: Curves.easeInOut,
        duration: const Duration(
          milliseconds: 300,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _body = [
      _buildBody1(),
      _buildBody2(),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: BuildText(text: 'Thông tin sức khỏe', style: 18.text600),
          leading: _currentIndex != 0
              ? IconButton(
                  onPressed: () => handleBackPressed(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: rose400,
                  ),
                )
              : const SizedBox(),
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
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.w),
                child: PageView(
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (value) {
                    setState(() {
                      _currentIndex = value;
                    });
                  },
                  children: [
                    _buildBody1(),
                    _buildBody2(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: KSubmitButton(
                size: Size(context.width, 50.h),
                text: _currentIndex == _body.length - 1
                    ? 'Hoàn thành'
                    : 'Tiếp tục',
                onTap: () => handleSubmitPressed(_body.length),
              ),
            ),
            40.verticalSpace,
            Container(
              height: 6.h,
              alignment: Alignment.center,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: _body.length,
                itemBuilder: (context, index) {
                  return buildIndicator(index == _currentIndex,
                      Size(context.width, context.height));
                },
              ),
            ),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }
}
