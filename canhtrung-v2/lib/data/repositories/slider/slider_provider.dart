import 'dart:async';

import 'package:flutter_ovumb_app_version1/data/models/store/local_product.dart';
import 'package:rxdart/rxdart.dart';

class SliderProvider {
  static final SliderProvider _instance = SliderProvider._internal();
  factory SliderProvider() {
    return _instance;
  }
  SliderProvider._internal();

  final _streamSlider = ReplaySubject<bool>(maxSize: 2);

  final StreamController<LocalProduct> _streamCart =
      StreamController.broadcast();
  final StreamController<String> _streamCartAnimated =
      StreamController.broadcast();

  //cart product stream
  Stream<bool> get slideStream => _streamSlider.stream;
  Sink<bool> get slideSink => _streamSlider.sink;

  void add(bool event) {
    slideSink.add(event);
  }

  void addCart(LocalProduct event) {
    _streamCart.add(event);
  }

  void addCartAnimted(String event) {
    _streamCartAnimated.sink.add(event);
  }

  void cancelStream() => _streamSlider.close();

  Stream<LocalProduct> streamCart() => _streamCart.stream;
  Stream<String> streamCartAnimated() => _streamCartAnimated.stream;
}
