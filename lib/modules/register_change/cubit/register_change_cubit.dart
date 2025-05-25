import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/auth_repository/auth_repository.dart';

part 'register_change_state.dart';

class RegisterChangeCubit extends Cubit<RegisterChangeState> {
  RegisterChangeCubit() : super(RegisterChangeState());

  final AuthRepository repo = getIt<AuthRepository>();

  void onEmailChanged(String value) {
    emit(state.copyWith(emailNew: value));
  }

  Future<void> resendEmail({
    required BuildContext context,
    required String emailOld,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      if (state.emailNew.trim().isEmpty) {
        ShowSnackbar.snackbar(
          context,
          "Email baru tidak boleh kosong",
          isSuccess: false,
        );
        return;
      }

      await repo.resendEmail(emailOld, state.emailNew);

      if (!context.mounted) return;

      ShowSnackbar.snackbar(
        context,
        "Kode OTP telah dikirim ke email baru.",
        isSuccess: true,
      );

      Navigator.pop(
          context, state.emailNew); // arahkan ke halaman OTP jika perlu
    } catch (e) {
      if (!context.mounted) return;
      ShowSnackbar.snackbar(
        context,
        e.toString(),
        isSuccess: false,
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
