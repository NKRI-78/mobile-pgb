import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/auth_repository/auth_repository.dart';
import '../../../router/builder.dart';

part 'lupa_password_otp_state.dart';

class LupaPasswordOtpCubit extends Cubit<LupaPasswordOtpState> {
  LupaPasswordOtpCubit() : super(LupaPasswordOtpState()) {
    _startTimer();
  }

  AuthRepository repo = getIt<AuthRepository>();
  Timer? _timer;
  int _start = 180;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start > 0) {
        _start--;
        emit(state.copyWith(timeRemaining: _start, timerFinished: false));
      } else {
        _timer?.cancel();
        emit(state.copyWith(timerFinished: true)); // Timer selesai
      }
    });
  }

  void init(String email) {
    emit(state.copyWith(email: email));
  }

  Future<void> submit(BuildContext context, String verificationCode) async {
    try {
      emit(state.copyWith(loading: true));
      await repo.forgotPasswordVerifyOTP(state.email, verificationCode);
      if (context.mounted) {
        ShowSnackbar.snackbar(
          context,
          "Berhasil Verifikasi OTP",
          isSuccess: true,
        );
        LupaPasswordChangeRoute(email: state.email, otp: verificationCode)
            .push(context);
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

  Future<void> forgotPasswordSendOTP(BuildContext context) async {
    _start = 180;
    _startTimer();
    emit(state.copyWith(timeRemaining: _start, timerFinished: false));
    try {
      emit(state.copyWith(loading: true));
      await repo.forgotPasswordSendOTP(state.email);
      if (context.mounted) {
        ShowSnackbar.snackbar(
          context,
          "Kode OTP sudah dikirim ulang, Silahkan cek kembali email Anda.",
          isSuccess: true,
        );
      }
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(
        context,
        "$e",
        isSuccess: false,
      );
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  void copyState({required LupaPasswordOtpState newState}) {
    emit(newState);
  }
}
