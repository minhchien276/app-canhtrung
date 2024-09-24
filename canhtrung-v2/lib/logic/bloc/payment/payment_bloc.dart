import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/address.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/address/address_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/voucher/voucher_repository.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/payment/payment_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/payment/payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitialState(isLoading: false)) {
    VoucherRepository voucherRepository = VoucherRepository();
    AddressRepository addressRepository = AddressRepository();

    // vào màn thanh toan
    on<PaymentScreenEvent>((event, emit) async {
      try {
        emit(LoadingState(isLoading: true));
        List<VoucherType>? voucherType = await voucherRepository.getVouchers();
        List<Address>? address = await addressRepository.getAllAddress();
        if (voucherType != null && address != null) {
          emit(
            PaymentScreenState(
              address: address,
              voucherType: voucherType,
              isLoading: false,
            ),
          );
        } else {
          emit(
            LoadingFailureState(
              error: 'Lỗi kết nối mạng. Kiểm tra lại kết nối',
              isLoading: false,
            ),
          );
        }
      } catch (e) {
        emit(LoadingFailureState(
            error: 'Lỗi kết nối mạng. Kiểm tra lại kết nối', isLoading: false));
      }
    });
  }
}
