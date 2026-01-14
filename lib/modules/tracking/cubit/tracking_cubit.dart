import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../repositories/oder_repository/models/tracking_model.dart';
import '../../../repositories/oder_repository/order_repository.dart';

part 'tracking_state.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit() : super(const TrackingState());

  OrderRepository repo = OrderRepository();

  Future<void> getDetailTracking(
      String idOrder, int initIndex, int idOrderState) async {
    try {
      emit(state.copyWith(loading: true));
      final tracking = await repo.getDetailTracking(idOrder);
      emit(state.copyWith(
          tracking: tracking, initIndex: initIndex, idOrder: idOrderState));
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } finally {
      emit(state.copyWith(loading: false));
    }
  }
}
