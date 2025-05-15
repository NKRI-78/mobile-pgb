import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/auth_repository/auth_repository.dart';
import '../../../router/builder.dart';
import '../../app/bloc/app_bloc.dart';
import '../../register_akun/model/extrack_ktp_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  AuthRepository repo = getIt<AuthRepository>();

  void copyState({required LoginState newState}) {
    emit(newState);
  }

  Future<void> submit(BuildContext context) async {
    if (!_validateInputs(context)) return;

    try {
      emit(state.copyWith(loading: true));

      final loggedIn =
          await repo.login(email: state.email, password: state.password);

      if (context.mounted) {
        getIt<AppBloc>()
            .add(SetUserData(user: loggedIn.user, token: loggedIn.token));
        HomeRoute().go(context);
        ShowTopSnackbar.snackbar(
          isSuccess: true,
          context,
          "Login berhasil",
        );
      }
    } on EmailNotActivatedFailure {
      if (!context.mounted) {
        return;
      }
      RegisterOtpRoute(
        $extra: ExtrackKtpModel(),
        email: state.email,
        isLogin: true,
      ).push(context);
    } catch (e) {
      if (!context.mounted) return;

      String errorMessage;

      if (e is EmailNotFoundFailure) {
        errorMessage =
            "Email ini tidak terdaftar. Silakan coba lagi atau daftar akun baru.";
      } else if (e.toString().toLowerCase().contains("user not found")) {
        errorMessage =
            "Email ini tidak terdaftar. Pastikan email yang Anda masukkan benar.";
      } else {
        errorMessage = e.toString();
      }

      ShowTopSnackbar.snackbar(
        isSuccess: false,
        context,
        errorMessage,
      );
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  /// 🔹 Validasi email dan password sebelum login
  bool _validateInputs(BuildContext context) {
    if (state.email.isEmpty) {
      ShowTopSnackbar.snackbar(
        isSuccess: false,
        context,
        "Email tidak boleh kosong",
      );
      return false;
    }
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        .hasMatch(state.email)) {
      ShowTopSnackbar.snackbar(
        context,
        isSuccess: false,
        "Format email tidak valid",
      );
      return false;
    }
    if (state.password.isEmpty) {
      ShowTopSnackbar.snackbar(
        context,
        isSuccess: false,
        "Password tidak boleh kosong",
      );
      return false;
    }
    if (state.password.length < 8) {
      ShowTopSnackbar.snackbar(
        context,
        isSuccess: false,
        "Password harus minimal 8 karakter",
      );
      return false;
    }
    return true;
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }
}
