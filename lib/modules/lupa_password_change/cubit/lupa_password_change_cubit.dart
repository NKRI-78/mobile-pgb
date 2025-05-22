import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/auth_repository/auth_repository.dart';
import '../../../router/builder.dart';

part 'lupa_password_change_state.dart';

class LupaPasswordChangeCubit extends Cubit<LupaPasswordChangeState> {
  LupaPasswordChangeCubit({required this.email, required this.otp})
      : super(LupaPasswordChangeState());

  final String email;
  final String otp;

  AuthRepository repo = getIt<AuthRepository>();

  void copyState({required LupaPasswordChangeState newState}) {
    emit(newState);
  }

  bool submissionValidation(
    BuildContext context, {
    required String password,
    required String passwordConfirm,
  }) {
    debugPrint("Password $password Confirm Password $passwordConfirm");
    if (password.length < 8) {
      ShowSnackbar.snackbar(
        context,
        "Kata Sandi minimal 8 character",
        isSuccess: false,
      );
      return false;
    } else if (passwordConfirm.length < 8) {
      ShowSnackbar.snackbar(
        context,
        "Konfirmasi Kata Sandi minimal 8 character",
        isSuccess: false,
      );
      return false;
    } else if (passwordConfirm != password) {
      ShowSnackbar.snackbar(
        context,
        "Kata Sandi tidak cocok",
        isSuccess: false,
      );
      return false;
    }

    return true;
  }

  Future<void> submit(BuildContext context) async {
    try {
      emit(state.copyWith(loading: true));

      final bool isClear = submissionValidation(context,
          password: state.password, passwordConfirm: state.passwordConfirm);

      if (isClear) {
        await repo.forgotPasswordChangePass(email, otp, state.password);
        if (context.mounted) {
          ShowSnackbar.snackbar(
            context,
            "Password berhasil diubah",
            isSuccess: true,
          );
          LoginRoute().go(context);
        }
      }
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(
        context,
        e.toString(),
        isSuccess: false,
      );
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(
        isConfirmPasswordObscured: !state.isConfirmPasswordObscured));
  }
}
