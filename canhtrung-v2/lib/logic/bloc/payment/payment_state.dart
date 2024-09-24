import 'package:equatable/equatable.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/address.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';

abstract class PaymentState extends Equatable {
  final bool isLoading;
  final String? loadingText;
  const PaymentState({
    required this.isLoading,
    this.loadingText,
  });

  @override
  List<Object> get props => [];
}

class PaymentInitialState extends PaymentState {
  PaymentInitialState({
    required super.isLoading,
  });
}

class PaymentScreenState extends PaymentState {
  final List<Address> address;
  final List<VoucherType> voucherType;
  PaymentScreenState({
    required this.address,
    required this.voucherType,
    required super.isLoading,
  });

  @override
  List<Object> get props => [address, voucherType, isLoading];
}

class LoadingState extends PaymentState {
  LoadingState({
    required super.isLoading,
    super.loadingText,
  });
}

class LoadingFailureState extends PaymentState {
  final String error;
  LoadingFailureState({
    required super.isLoading,
    required this.error,
  });
}
