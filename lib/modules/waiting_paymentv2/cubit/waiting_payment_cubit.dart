import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../misc/socket.dart';
import '../../app/bloc/app_bloc.dart';
import '../../../repositories/payment_repository/models/payment_model.dart';
import '../../../repositories/payment_repository/payment_repository.dart';
import '../../notification/cubit/notification_cubit.dart';

part 'waiting_payment_state.dart';

class WaitingPaymentCubit extends Cubit<WaitingPaymentState> {
  WaitingPaymentCubit({required this.id}) : super(const WaitingPaymentState());

  final String id;

  SocketServices services = getIt<SocketServices>();

  PaymentRepository paymentRepo = PaymentRepository();

  Future<void> init(BuildContext context, int tabIndex) async {
    try {
      print("Payement id : $id");
      emit(state.copyWith(loading: true, tabIndex: tabIndex));
      var payment = await paymentRepo.findPayment(id);
      print("Payment Inv : ${payment.paymentNumber}");

      emit(state.copyWith(payment: payment, loading: false));

      services.socket?.emit('joinWaitingPayment', payment.paymentNumber);

      services.socket?.on('payment:success', (data) async {
        print('OKE success bayar');
        var payment = await paymentRepo.findPayment(id);
        emit(state.copyWith(payment: payment, loading: false));
      });
    } on SocketException catch (e) {
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(context, "Network Error: ${e.message}",
          isSuccess: false);
    } on ClientException catch (e) {
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(context, "Client Error: ${e.message}",
          isSuccess: false);
    } catch (e) {
      print("Error : $e");
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(context, "Unexpected Error: $e", isSuccess: false);
    }
  }

  Future<void> onRefresh() async {
    try {
      var payment = await paymentRepo.findPayment(id);
      emit(state.copyWith(loading: false, payment: payment));
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    }
  }

  @override
  Future<void> close() {
    services.socket?.off('payment:success');
    getIt<AppBloc>().add(InitialAppData());
    getIt<NotificationCubit>().fetchNotification();
    // getIt<NotificationCubit>().changeNotification(state.tabIndex == 0 ? "SOS" : state.tabIndex == 1 ? "PAYMENT_EXPIRE,WAITING_PAYMENT,PAYMENT_SUCCESS" : state.tabIndex == 3 ? "BROADCAST,FORUM" : "");
    return super.close();
  }
}
