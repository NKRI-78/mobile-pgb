import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/auth_repository/auth_repository.dart';
import '../../../router/builder.dart';
import '../../app/bloc/app_bloc.dart';

part 'register_otp_state.dart';

class RegisterOtpCubit extends Cubit<RegisterOtpState> {
  RegisterOtpCubit(this.isLogin) : super(RegisterOtpState()) {
    _startTimer();
  }

  AuthRepository repo = getIt<AuthRepository>();

  final bool isLogin;
  Timer? _timer;
  int _start = 120;

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

  void init(String email) async {
    emit(state.copyWith(email: email));
    repo.verifyOtp(email, '', VerifyEmailType.sendingOtp);
  }

  Future<void> submit(String verificationCode, BuildContext context) async {
    try {
      emit(state.copyWith(loading: true));
      final loggedIn = await repo.verifyOtp(
          state.email, verificationCode, VerifyEmailType.verified);

      if (context.mounted) {
        getIt<AppBloc>()
            .add(SetUserData(user: loggedIn!.user, token: loggedIn.token));

        ShowSnackbar.snackbar(
          context,
          'Verify berhasil, selamat datang di Partai Gema Bangsa.',
          isSuccess: true,
        );

        HomeRoute().go(context);
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

  Future<void> resendOtp(BuildContext context) async {
    _start = 120;
    _startTimer();
    emit(state.copyWith(timeRemaining: _start, timerFinished: false));
    try {
      emit(state.copyWith(loading: true));
      await repo.resendOtp(state.email);

      if (context.mounted) {
        ShowSnackbar.snackbar(context,
            'Kode OTP sudah dikirim ulang, Silahkan cek kembali email Anda.',
            isSuccess: true);
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

  void copyState({required RegisterOtpState newState}) {
    emit(newState);
  }
}
