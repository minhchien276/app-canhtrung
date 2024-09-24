// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/nguoi_dung.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/auth_v2/auth_repository_v2.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/main/main_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/home/profile/profile_verify_otp.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/loading/loading_logo.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/extensions/size_extension.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/gallery_picker.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/icon_app.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/image_handler.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/styles.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kback_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/kloader_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/home/home_tabbar.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/modals/delete_account_modal.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/network_image.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';
import 'package:flutter_ovumb_app_version1/services/permission/permission.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditScreen extends StatefulWidget {
  final NguoiDung nguoiDung;
  static const String routeName = 'profile-edit-screen';
  const ProfileEditScreen({
    Key? key,
    required this.nguoiDung,
  }) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _auth = AuthRepositoryV2();
  late TextEditingController _nameController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late FocusNode _nameFocus;
  late FocusNode _weightFocus;
  late FocusNode _heightFocus;
  File? avatar;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    _nameController =
        TextEditingController(text: widget.nguoiDung.tenNguoiDung);
    _weightController = TextEditingController(
        text: (widget.nguoiDung.canNang ?? '').toString());
    _heightController = TextEditingController(
        text: (widget.nguoiDung.chieuCao ?? '').toString());
    _nameFocus = FocusNode();
    _weightFocus = FocusNode();
    _heightFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: BuildText(
                text: 'Chỉnh sửa',
                style: 18.text600,
                color: grey700,
              ),
              leading: kBackButton(context),
              backgroundColor: whiteColor,
              shadowColor: whiteColor,
              bottomOpacity: 0.1,
              elevation: 3,
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    20.verticalSpace,
                    Stack(
                      children: [
                        networkImageWithCached(
                          size: Size(100.h, 100.h),
                          url: widget.nguoiDung.avatar,
                          file: avatar,
                          borderRadius: 1000,
                          boxBorder: Border.all(color: rose200, width: 4),
                          placeholder:
                              defaultAvatar(Size(100.h, 100.h), file: avatar),
                        ),
                        Positioned(
                          bottom: -5.h,
                          right: -5.h,
                          child: IconButton(
                            onPressed: () async {
                              try {
                                final check =
                                    await PermissionHandler.photoRequest();
                                if (check) {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor:
                                        Colors.white.withOpacity(0),
                                    barrierColor: Colors.black38,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(8),
                                      ),
                                    ),
                                    builder: (context) {
                                      return PhotoPickerScrenn();
                                    },
                                  ).then((image) async {
                                    if (image != null) {
                                      print(await getFileSize(image.path, 1));
                                      avatar = await resizeImage(image, 1000);
                                      print(await getFileSize(avatar!.path, 1));
                                      setState(() {});
                                    }
                                  });
                                }
                              } catch (e) {
                                showSettingDialog(context, e.toString());
                              }
                            },
                            icon: Image.asset(
                              IconApp.edit,
                              scale: 3.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    40.verticalSpace,
                    Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _inputTextActions(
                            title: 'Họ và tên',
                            controller: _nameController,
                            focusNode: _nameFocus,
                          ),
                          14.verticalSpace,
                          _inputTextActions(
                            title: 'Cân nặng',
                            controller: _weightController,
                            textInputType: TextInputType.number,
                            formatter: [FilteringTextInputFormatter.digitsOnly],
                            focusNode: _weightFocus,
                          ),
                          14.verticalSpace,
                          _inputTextActions(
                            title: 'Chiều cao',
                            controller: _heightController,
                            textInputType: TextInputType.number,
                            formatter: [FilteringTextInputFormatter.digitsOnly],
                            focusNode: _heightFocus,
                          ),
                        ],
                      ),
                    ),
                    KLoaderButton(
                      size: Size(context.width, 50.h),
                      isLoading: state.isLoading,
                      text: 'Lưu thông tin',
                      onTap: () {
                        context.read<MainBloc>().add(
                              ProfileUpdateEvent(
                                context,
                                name: _nameController.text,
                                weight: _weightController.text,
                                height: _heightController.text,
                                avatar: avatar,
                              ),
                            );
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        showDeleteAccountModal(context, onSubmit: () async {
                          LoadingLogo().show(context: context);
                          String? email = await _auth.deleteAccount();
                          LoadingLogo().hide();
                          if (email != null) {
                            Navigator.pushNamed(
                                context, ProfileVerifyOtpScreen.routeName,
                                arguments: email);
                          } else {
                            showToast(context,
                                'Không thể gửi OTP. Vui lòng thử lại sau ít phút');
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: BuildText(
                        text: 'Xoá tài khoản',
                        style: 14.text500,
                        color: grey600,
                        textDecoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _inputTextActions({
    required TextEditingController controller,
    required String title,
    required FocusNode focusNode,
    TextInputType? textInputType,
    List<TextInputFormatter>? formatter,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildText(text: title, style: 16.text500.copyWith(color: grey600)),
          10.verticalSpace,
          TextField(
            focusNode: focusNode,
            controller: controller,
            cursorColor: grey500,
            style: 16.text500.copyWith(color: grey500),
            keyboardType: textInputType,
            inputFormatters: formatter,
            onTapOutside: (_) => focusNode.unfocus(),
            onSubmitted: (_) => focusNode.unfocus(),
            decoration: InputDecoration(
              focusColor: rose400,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 35),
              fillColor: grey100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  width: 0,
                  color: grey25,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: grey300,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      );
}
