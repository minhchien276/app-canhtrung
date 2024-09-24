import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/local_data/repositories/product/local_product_repository.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/address.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/local_product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/voucher_type.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/address/address_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/store/store_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/voucher/voucher_repository.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/cart/cart_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/cart/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(HomeCartInitialState(isLoading: false)) {
    StoreRepository storeRepository = StoreRepository();
    LocalProductRepository localProductRepository = LocalProductRepository();
    VoucherRepository voucherRepository = VoucherRepository();
    AddressRepository addressRepository = AddressRepository();

    // vào màn cho an
    on<HomeCartEvent>((event, emit) async {
      try {
        emit(LoadingState(isLoading: true));
        List<LocalProduct> local = await localProductRepository.getAllProduct();
        if (local.isNotEmpty) {
          List<Product> products =
              await storeRepository.getProductByListId(products: local);
          List<VoucherType>? voucherType =
              await voucherRepository.getVouchers();
          List<Address>? address = await addressRepository.getAllAddress();

          if (voucherType != null && address != null) {
            emit(
              HomeCartState(
                products: products,
                local: local,
                voucherType: voucherType,
                address: address,
                isLoading: false,
              ),
            );

            localProductRepository.addPrice(
              products: products,
            );
            localProductRepository.addCartProduct(
                products: products, locals: local);
            localProductRepository.addVoucher(
              voucherType: voucherType,
            );
          } else {
            emit(LoadingFailureState(
                error: 'Lỗi kết nối mạng. Kiểm tra lại kết nối',
                isLoading: false));
          }
        } else {
          emit(
            HomeCartState(
              products: [],
              local: local,
              voucherType: [],
              address: [],
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
