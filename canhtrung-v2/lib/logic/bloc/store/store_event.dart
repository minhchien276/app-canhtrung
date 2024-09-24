// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

class HomeStoreEvent extends StoreEvent {
  HomeStoreEvent();
}

class StorePaymentEvent extends StoreEvent {
  StorePaymentEvent();
}

class StoreOrderStatusEvent extends StoreEvent {
  StoreOrderStatusEvent();
}

class StoreOrderHistoryEvent extends StoreEvent {
  StoreOrderHistoryEvent();
}
