// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_ovumb_app_version1/data/enum/choan_enum.dart';
import 'package:flutter_ovumb_app_version1/data/models/nguoidung/guide.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_choan.dart';
import 'package:flutter_ovumb_app_version1/data/models/phase3/choan.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_bloc.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/milk/milk_state.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_history.dart';
import 'package:flutter_ovumb_app_version1/presentation/screens/phase3/suckhoe/choan/choan_bume_input.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/size.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/buttons/ksubmit_button.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/toast.dart';

class ChoAnBuMe extends StatefulWidget {
  final ChoAnEnum type;
  const ChoAnBuMe({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<ChoAnBuMe> createState() => _ChoAnBuMeState();
}

class _ChoAnBuMeState extends State<ChoAnBuMe> with TickerProviderStateMixin {
  List<int> a = [];
  late AnimationController animationController;
  late Animation<double> animation;
  int time = 0;
  int second = int.parse(dataBuMe[0].second) + int.parse(dataBuMe[1].second);
  int minus = int.parse(dataBuMe[0].minus) + int.parse(dataBuMe[1].minus);
  Duration duration = Duration(minutes: 0);
  TextEditingController _stopMilkController = TextEditingController();
  Guide? guide;
  final player = AudioPlayer();
  bool isPlay = true;
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  void initState() {
    context.read<MilkBloc>().add(GetBumeLinkEvent());
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _initialMP3(Guide? value) async {
    if (guide == null && value != null) {
      guide = value;
      await player.play(UrlSource(guide!.link_video));
      player.setVolume(1);
    }
  }

  void _pause() {
    player.pause();
  }

  void _resume() {
    player.resume();
  }

  handleNextPressed(MilkState state) {
    int totalMilk = dataBuMe[1].ml + dataBuMe[0].ml;
    if (totalMilk != 0) {
      dataBuMe[0].isPlaying = false;
      dataBuMe[1].isPlaying = false;
      _stopMilkController.text = getRandomString(5);
      sound[0].player.stop();
      sound[0].player.setVolume(0);
      context.read<MilkBloc>().add(InsertChoAnEvent(
            choAn: ChoAn(
              maLoaiChoAn: getMaChoAn(widget.type),
              maCon: state.currentBaby?.id ?? 0,
              trongLuong: totalMilk,
              lanChoAn: state.choAn.length + 1,
              thoiGian: dateMilk,
              ngayTao: dateMilk,
              vuTrai: dataBuMe[1].ml,
              vuPhai: dataBuMe[0].ml,
            ),
          ));
    } else {
      showToast(
          context, 'Lượng sữa hiện tại đang là 0ml. Vui lòng thêm lượng sữa');
    }
  }

  _resetData() {
    checkTimeChange = true;
    timeMilk =
        TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    dateMilk = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String strDigits1(int n) => n.toString().padLeft(2, '0');
    minus = int.parse(strDigits1(duration.inMinutes.remainder(60)));
    second = int.parse(strDigits1(duration.inSeconds.remainder(60)));

    return BlocConsumer<MilkBloc, MilkState>(
      listener: (context, state) {
        if (state.message != null && state.status == LoadedStatus.succes) {
          _resetData();
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        _initialMP3(state.bumeLink);
        if (state.choAnEnum == ChoAnEnum.bume) {
          return ChoAnHistory();
        }
        return Container(
          height: 1200,
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            padding: const EdgeInsets.only(top: 30),
            physics: const ClampingScrollPhysics(),
            children: [
              Container(
                height: 500,
                width: size.width,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dataNhapDuLieu[0].title,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: grey700,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              dataNhapDuLieu[0].descripble,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: grey400,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Image.asset(
                            isPlay
                                ? 'assets/images/volume.png'
                                : 'assets/images/mute.png',
                            scale: 5,
                            color: rose400,
                          ),
                          onPressed: () {
                            if (isPlay) {
                              _pause();
                              isPlay = !isPlay;
                            } else {
                              _resume();
                              isPlay = !isPlay;
                            }
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    ChoAnBuMeInput(
                      con: state.currentBaby,
                      stopMilkController: _stopMilkController,
                    ),
                  ],
                ),
              ),
              50.verticalSpace,
              KSubmitButton(
                size: Size(size.width, 50),
                text: 'Hoàn tất',
                onTap: () => handleNextPressed(state),
              ),
              100.verticalSpace,
            ],
          ),
        );
      },
    );
  }
}

List<int> listChartHangNgay = [0, 0, 0, 0, 0, 0, 0];
