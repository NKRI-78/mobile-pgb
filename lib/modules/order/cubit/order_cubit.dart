import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../misc/pagination.dart';
import '../../../repositories/app_repository/app_repository.dart';
import '../../../repositories/oder_repository/models/order_model.dart';
import '../../../repositories/oder_repository/models/waiting_payment_model.dart';
import '../../../repositories/oder_repository/order_repository.dart';
import '../../app/models/badges_order_model.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderState());

  OrderRepository repo = OrderRepository();
  AppRepository appRepo = AppRepository();

  static RefreshController refreshCtrl = RefreshController();

  void init(int initIndex) {
    emit(state.copyWith(tabIndex: initIndex));

    if (initIndex == 0) {
      getPaymentWaiting();
    } else if (initIndex == 1) {
      getOrderUser("WAITING_CONFIRM");
    } else if (initIndex == 2) {
      getOrderUser("ON_PROCESS");
    } else if (initIndex == 3) {
      getOrderUser("DELIVERY");
    } else if (initIndex == 4) {
      getOrderUser("DELIVERED");
    } else if (initIndex == 5) {
      getOrderUser("FINISHED");
    } else if (initIndex == 6) {
      getOrderUser("CANCEL");
    }

    getBadges();
    refreshCtrl.refreshCompleted();
  }

  void copyState({required OrderState newState}) {
    emit(newState);
  }

  Future<void> getOrderUser(String status) async {
    try {
      emit(state.copyWith(loading: true));
      var value = await repo.getOrderStatus(status: status);
      var list = value.list;
      var pagination = value.pagination;

      emit(state.copyWith(
        order: list,
        nexPageOrder: pagination.next,
        loading: false,
        pagination: pagination,
      ));
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> loadMoreOrderUser(String status) async {
    try {
      emit(state.copyWith(loading: true));
      var value = await repo.getOrderStatus(
          status: status,
          page: state.nexPageOrder == 0
              ? state.nexPageOrder + 1
              : state.nexPageOrder);
      var list = value.list;
      var pagination = value.pagination;

      emit(state.copyWith(
        order: list,
        nexPageOrder: pagination.next,
        loading: false,
        pagination: pagination,
      ));
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> loadMorePaymentWaiting(String status) async {
    try {
      emit(state.copyWith(loading: true));
      var value = await repo.getOrderStatus(
          status: status,
          page: state.nexPageOrder == 0
              ? state.nexPageOrder + 1
              : state.nexPageOrder);
      var list = value.list;
      var pagination = value.pagination;

      emit(state.copyWith(
        order: list,
        nexPageOrder: pagination.next,
        loading: false,
        pagination: pagination,
      ));
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> getPaymentWaiting() async {
    try {
      emit(state.copyWith(loading: true));
      var waitingPayment = await repo.getPayment();
      emit(state.copyWith(waitingPayment: waitingPayment, loading: false));
    } catch (e) {
      rethrow;
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> getBadges() async {
    try {
      emit(state.copyWith(loading: true));
      BadgesOrderModel badges = await appRepo.getBadgesOrder();

      emit(state.copyWith(badges: badges, loading: false));
    } catch (e) {
      print("Error : $e");
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    // getIt<ProfileCubit>().getBadges();
    return super.close();
  }
}
