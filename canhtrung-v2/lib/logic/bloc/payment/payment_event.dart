// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentScreenEvent extends PaymentEvent {
  PaymentScreenEvent();
}
