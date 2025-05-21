import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/profile_repository/models/profile_model.dart';
import '../../../repositories/profile_repository/profile_repository.dart';
import '../../../repositories/wallet_repository/model/payment_channel_model.dart';
import '../../../repositories/wallet_repository/wallet_repository.dart';
import '../widget/select_payment_channel.dart';
import '../widget/show_payment_modal.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(const WalletState());

  final WalletRepository repo = getIt<WalletRepository>();
  final ProfileRepository profile = getIt<ProfileRepository>();

  void copyState({required WalletState newState}) {
    emit(newState);
  }

  void setDenom(double amount, int selectedCard) {
    double adminFee = state.adminFee;
    emit(state.copyWith(
      amount: amount,
      selectedCard: selectedCard,
      totalAmount: amount + adminFee,
    ));
  }

  void setPaymentChannel(PaymentChannelModel e) {
    int? newAdminFee = e.fee;
    emit(state.copyWith(
      channel: e,
      adminFee: newAdminFee?.toDouble(),
      totalAmount: state.amount + newAdminFee!,
    ));
  }

  Future<void> fetchProfile() async {
    try {
      final userProfile = await profile.getProfile();
      emit(state.copyWith(profile: userProfile));
    } catch (e) {
      //
    }
  }

  Future<void> getPaymentChannel(BuildContext context) async {
    try {
      emit(state.copyWith(loadingChannel: true));
      var channels = await repo.getChannels();

      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (_) => BlocProvider<WalletCubit>.value(
            value: context.read<WalletCubit>(),
            child: const SelectPaymentChannel(),
          ),
        );
      }

      emit(state.copyWith(channels: channels, loadingChannel: false));
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.redColor,
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      emit(state.copyWith(loadingChannel: false));
    }
  }

  void updateCheckout({
    required PaymentChannelModel? e,
  }) async {
    double admin = e?.fee?.toDouble() ?? 0.0;

    double totalPrice = state.amount.toDouble() + admin;

    emit(state.copyWith(
      adminFee: admin,
      totalAmount: totalPrice,
    ));
  }

  Future<void> checkTopUp(BuildContext context) async {
    try {
      if (state.amount < 10000) {
        ShowSnackbar.snackbar(
          context,
          "Minimal Top Up 10.000",
          isSuccess: false,
        );
      } else {
        double admin = state.channel?.fee?.toDouble() ?? 0.0;

        double totalPrice = state.amount.toDouble() + admin;

        emit(state.copyWith(
          adminFee: admin,
          totalAmount: totalPrice,
        ));
        showPaymentModal(context);
      }
      return;
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.redColor,
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Future<int> topUpWallet(BuildContext context) async {
    try {
      emit(state.copyWith(loading: true));
      var paymentNumber = await repo.topUpWallet(
        amountTopup: state.amount.toInt(),
        payment: state.channel!,
      );
      emit(state.copyWith(loading: false));

      return paymentNumber;
    } catch (e) {
      Navigator.pop(context);
      emit(state.copyWith(loading: false));
      rethrow;
    }
  }
}
