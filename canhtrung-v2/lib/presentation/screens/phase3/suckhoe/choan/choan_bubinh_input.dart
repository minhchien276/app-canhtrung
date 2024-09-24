import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ovumb_app_version1/data/models/other/model_choan.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:flutter_ovumb_app_version1/presentation/utils/color.dart';
import 'package:flutter_ovumb_app_version1/presentation/widgets/title_text.dart';

class ChoAnBuBunhInput extends StatefulWidget {
  final int widgetId;
  final List<Color> colors;
  final List<Color> suaColors;
  final List<String> images;
  final List<DataBuBinh> dataBuBinh;

  ChoAnBuBunhInput({
    Key? key,
    required this.widgetId,
    required this.colors,
    required this.suaColors,
    required this.images,
    required this.dataBuBinh,
  }) : super(key: key);

  @override
  State<ChoAnBuBunhInput> createState() => _ChoAnBuBunhInputState();
}

class _ChoAnBuBunhInputState extends State<ChoAnBuBunhInput> {
  double ml = 200;

  final _numberLimit = 600;
  bool _isNumberValid = true;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.dataBuBinh[widget.widgetId].controller.addListener(() {
      final enteredNumber =
          int.tryParse(widget.dataBuBinh[widget.widgetId].controller.text);
      if (enteredNumber != null && enteredNumber > _numberLimit) {
        setState(() {
          _isNumberValid = false;
        });
      } else {
        setState(() {
          _isNumberValid = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      height: size.height,
      width: size.width,
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          // hình sóng
          Positioned(
            bottom: 5,
            top: 8,
            left: size.width * 0.36,
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.bottomCenter,
              child: BuBinhCustom(
                ml: widget.dataBuBinh[widget.widgetId].value,
                widgetId: widget.widgetId,
                colors: widget.suaColors,
              ),
            ),
          ),
          // hình cái bình
          Positioned(
            bottom: 5,
            top: 5,
            left: size.width * 0.26,
            child: Image.asset(
              widget.widgetId == 1 ? widget.images[0] : widget.images[1],
            ),
          ),
          // mũi tên chỉ vạch
          Positioned(
            left: size.width * 0.24,
            child: Container(
              height: 155,
              width: 30,
              margin: EdgeInsets.only(top: 78),
              alignment: Alignment.bottomRight,
              color: Colors.transparent,
              child: FlutterSlider(
                  axis: Axis.vertical,
                  tooltip: FlutterSliderTooltip(
                    disabled: true,
                  ),
                  touchSize: 5,
                  rtl: true,
                  values: [widget.dataBuBinh[widget.widgetId].value],
                  max: 240, // giá trị của ml, giá trị của sóng là 200
                  min: 0,
                  handlerHeight: 20,
                  handlerWidth: 20,
                  handler: FlutterSliderHandler(
                    child: Material(
                      color: Colors.transparent,
                      type: MaterialType.canvas,
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Image.asset(
                          'assets/images/down.png',
                          color: widget.colors[widget.widgetId],
                          scale: 3,
                        ),
                      ),
                    ),
                  ),
                  foregroundDecoration:
                      BoxDecoration(color: Colors.transparent),
                  trackBar: FlutterSliderTrackBar(
                    activeTrackBarHeight: 30,
                    inactiveTrackBarHeight: 30,
                    activeTrackBar: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    inactiveTrackBar: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    widget.dataBuBinh[widget.widgetId].value = lowerValue;
                    setState(() {});
                    widget.dataBuBinh[widget.widgetId].controller.text =
                        (lowerValue * 2.5).toInt().toString();
                  }),
            ),
          ),
          // chữ ml

          Positioned(
            top: 130,
            left: size.width * 0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      child: TextFormField(
                        focusNode: _focusNode,
                        onTapOutside: (event) {
                          _focusNode.unfocus();
                        },
                        showCursor: true,
                        cursorColor: grey600,
                        controller:
                            widget.dataBuBinh[widget.widgetId].controller,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: grey600, width: 1)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: grey600, width: 1)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: grey600, width: 1)),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly // Chỉ cho phép nhập số
                        ],
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            widget.dataBuBinh[widget.widgetId].value =
                                double.parse(value) / 2.5;
                            setState(() {});
                          }
                        },
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 40,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: TitleText(
                          text: 'ml',
                          fontWeight: FontWeight.w600,
                          size: 16,
                          color: widget.colors[widget.widgetId],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                _isNumberValid
                    ? SizedBox()
                    : TitleText(
                        text: 'ml quá lớn',
                        fontWeight: FontWeight.w500,
                        size: 10,
                        color: rose700,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BuBinhCustom extends StatefulWidget {
  final int widgetId;
  final double ml;
  final List<Color> colors;
  BuBinhCustom({
    Key? key,
    required this.widgetId,
    required this.ml,
    required this.colors,
  }) : super(key: key);
  @override
  _BuBinhCustomState createState() => _BuBinhCustomState();
}

class _BuBinhCustomState extends State<BuBinhCustom>
    with TickerProviderStateMixin {
  late AnimationController firstController;
  late Animation<double> firstAnimation;

  late AnimationController secondController;
  late Animation<double> secondAnimation;

  late AnimationController thirdController;
  late Animation<double> thirdAnimation;

  late AnimationController fourthController;
  late Animation<double> fourthAnimation;

  @override
  void initState() {
    super.initState();
    startTimer();
    firstController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    firstAnimation = Tween<double>(begin: 1.9, end: 2).animate(
        CurvedAnimation(parent: firstController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          firstController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          firstController.forward();
        }
      });

    secondController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    secondAnimation = Tween<double>(begin: 1.8, end: 2).animate(
        CurvedAnimation(parent: secondController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          secondController.forward();
        }
      });

    thirdController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    thirdAnimation = Tween<double>(begin: 1.8, end: 2).animate(
        CurvedAnimation(parent: thirdController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          thirdController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          thirdController.forward();
        }
      });

    fourthController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    fourthAnimation = Tween<double>(begin: 1.9, end: 2).animate(
        CurvedAnimation(parent: fourthController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          fourthController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          fourthController.forward();
        }
      });

    Timer(Duration(seconds: 2), () {
      firstController.forward();
    });

    Timer(Duration(milliseconds: 1600), () {
      secondController.forward();
    });

    Timer(Duration(milliseconds: 800), () {
      thirdController.forward();
    });

    fourthController.forward();
  }

  Timer? countdownTimer;
  Duration duration1 = Duration(minutes: 0);
  Duration duration2 = Duration(minutes: 0);

  void startTimer() {
    dataBuMe[0].second = '00';
    dataBuMe[0].minus = '00';
    dataBuMe[1].second = '00';
    dataBuMe[1].minus = '00';
    dataBuMe[0].isPlaying = false;
    dataBuMe[1].isPlaying = false;
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    final addSecond1 = 1;
    final addSecond2 = 1;

    if (dataBuMe[1].isPlaying == true) {
      final seconds1 = duration1.inSeconds + addSecond1;
      duration1 = Duration(seconds: seconds1);
      duration2 = Duration(seconds: 00);
    } else if (dataBuMe[0].isPlaying == true) {
      final seconds2 = duration2.inSeconds + addSecond2;
      duration2 = Duration(seconds: seconds2);
    }
    if (dataBuMe[0].isPlaying == false) {
      dataBuMe[0].second = dataBuMe[0].second;
      dataBuMe[0].minus = dataBuMe[0].minus;
    } else if (dataBuMe[1].isPlaying == false) {
      dataBuMe[1].second = dataBuMe[1].second;
      dataBuMe[1].minus = dataBuMe[1].minus;
    }
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      alignment: Alignment.bottomCenter,
      scale: 1.7,
      child: Container(
        height: widget.ml,
        width: 58,
        child: CustomPaint(
          painter: MyPainter(
            firstAnimation.value,
            secondAnimation.value,
            thirdAnimation.value,
            fourthAnimation.value,
            widget.colors[widget.widgetId],
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double firstValue;
  final double secondValue;
  final double thirdValue;
  final double fourthValue;
  final Color colorAnimation;

  MyPainter(
    this.firstValue,
    this.secondValue,
    this.thirdValue,
    this.fourthValue,
    this.colorAnimation,
  );

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = colorAnimation
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, size.height / firstValue)
      ..cubicTo(size.width * 0.4, size.height / secondValue, size.width * 0.7,
          size.height / thirdValue, size.width, size.height / fourthValue)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
