import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ovumb_app_version1/data/models/cart/order.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/product_category.dart';
import 'package:flutter_ovumb_app_version1/data/models/store/store_slider.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/order/order_repository.dart';
import 'package:flutter_ovumb_app_version1/data/repositories/store/store_repository.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/store/store_event.dart';
import 'package:flutter_ovumb_app_version1/logic/bloc/store/store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  StoreBloc() : super(HomeStoreInitialState(isLoading: false)) {
    StoreRepository _storeRepository = StoreRepository();
    OrderRepository orderRepository = OrderRepository();

    // vào màn cho an
    on<HomeStoreEvent>((event, emit) async {
      try {
        emit(LoadingState(isLoading: true));
        List<StoreSlider>? sliders = await _storeRepository.getSliders();
        List<ProductCategory>? products =
            await _storeRepository.getLimitProduct();
        if (sliders != null && products != null) {
          emit(HomeStoreState(
            products: products,
            sliders: sliders,
            isLoading: false,
          ));
        } else {
          emit(LoadingFailureState(
            error: 'Lỗi kết nối mạng. Kiểm tra lại kết nối',
            isLoading: false,
          ));
        }
      } catch (e) {
        emit(LoadingFailureState(
            error: 'Lỗi kết nối mạng. Kiểm tra lại kết nối', isLoading: false));
      }
    });

    //order status
    on<StoreOrderStatusEvent>((event, emit) async {
      try {
        emit(LoadingState(isLoading: true));
        List<Order>? orders = await orderRepository.getOrderStatus();
        if (orders != null) {
          emit(StoreOrderStatusState(
            orders: orders,
            isLoading: false,
          ));
        } else {
          emit(LoadingFailureState(
            error: 'Lỗi kết nối mạng. Kiểm tra lại kết nối',
            isLoading: false,
          ));
        }
      } catch (e) {
        emit(LoadingFailureState(
            error: 'Lỗi kết nối mạng. Kiểm tra lại kết nối', isLoading: false));
      }
    });

    //order history
    on<StoreOrderHistoryEvent>((event, emit) async {
      try {
        emit(LoadingState(isLoading: true));
        List<Order>? orders = await orderRepository.getOrderStatus();
        if (orders != null) {
          emit(StoreOrderHistoryState(
            orders: orders,
            isLoading: false,
          ));
        } else {
          emit(LoadingFailureState(
            error: 'Lỗi kết nối mạng. Kiểm tra lại kết nối',
            isLoading: false,
          ));
        }
      } catch (e) {
        emit(LoadingFailureState(
            error: 'Lỗi kết nối mạng. Kiểm tra lại kết nối', isLoading: false));
      }
    });
  }
}
