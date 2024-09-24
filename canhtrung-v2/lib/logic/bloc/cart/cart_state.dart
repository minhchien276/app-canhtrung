import 'package:equatable/equatable.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/address.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/local_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';

abstract class CartState extends Equatable {
  final bool isLoading;
  final String? loadingText;
  const CartState({
    required this.isLoading,
    this.loadingText,
  });

  @override
  List<Object> get props => [];
}

class HomeCartInitialState extends CartState {
  HomeCartInitialState({
    required super.isLoading,
  });
}

class HomeCartState extends CartState {
  final List<Product> products;
  final List<LocalProduct> local;
  final List<Address> address;
  final List<VoucherType> voucherType;
  HomeCartState({
    required this.local,
    required this.products,
    required this.address,
    required this.voucherType,
    required super.isLoading,
  });
}

class LoadingState extends CartState {
  LoadingState({
    required super.isLoading,
    super.loadingText,
  });
}

class LoadingFailureState extends CartState {
  final String error;
  LoadingFailureState({
    required super.isLoading,
    required this.error,
  });
}
