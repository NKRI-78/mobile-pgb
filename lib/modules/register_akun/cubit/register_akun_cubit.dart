import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/auth_repository/auth_repository.dart';
import '../../../repositories/event_repository/models/event_model.dart';
import '../../../router/builder.dart';
import '../model/extrack_ktp_model.dart';

part 'register_akun_state.dart';

class RegisterAkunCubit extends Cubit<RegisterAkunState> {
  RegisterAkunCubit() : super(RegisterAkunState());

  AuthRepository repo = getIt<AuthRepository>();

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(
        isConfirmPasswordObscured: !state.isConfirmPasswordObscured));
  }

  void copyState({required RegisterAkunState newState}) {
    emit(newState);
  }

  void init(ExtrackKtpModel extrackKtp) {
    emit(state.copyWith(ktpModel: extrackKtp));
  }

  bool submissionValidation(
    BuildContext context, {
    required String email,
    required String phone,
    required String password,
    required String passwordConfirm,
  }) {
    if (!email
        .contains(RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)?$'))) {
      ShowSnackbar.snackbar(
        context,
        "Harap masukkan email yang tepat",
        isSuccess: false,
      );
      return false;
    } else if (phone.length < 10 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      ShowSnackbar.snackbar(
        context,
        "Nomor telepon harus minimal 10 digit dan hanya mengandung angka",
        isSuccess: false,
      );
      return false;
    } else if (password.length < 8) {
      ShowSnackbar.snackbar(
        context,
        "Kata Sandi minimal 8 karakter",
        isSuccess: false,
      );
      return false;
    } else if (passwordConfirm.length < 8) {
      ShowSnackbar.snackbar(
        context,
        "Konfirmasi Kata Sandi minimal 8 karakter",
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
      emit(state.copyWith(isLoading: true));

      if (state.fileImage == null) {
        ShowSnackbar.snackbar(
          context,
          "Harap masukan foto",
          isSuccess: false,
        );
        emit(state.copyWith(isLoading: false));
        return;
      }
      final bool isClear = submissionValidation(
        context,
        email: state.email,
        phone: state.phone,
        password: state.password,
        passwordConfirm: state.passwordConfirm,
      );

      if (!isClear) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final linkImage =
          await repo.postMedia(folder: "images", media: state.fileImage!);
      final remaplink =
          linkImage.map((e) => {'url': e, 'type': "image"}).toList();

      await repo.registerAkun(
        email: state.email,
        phone: state.phone,
        password: state.password,
        ktpModel: ExtrackKtpModel(
          avatarLink: remaplink[0]['url']['url'],
          nik: state.ktpModel?.nik,
          fullname: state.ktpModel?.fullname,
          address: state.ktpModel?.address,
          birthPlaceAndDate: state.ktpModel?.birthPlaceAndDate,
          administrativeVillage: state.ktpModel?.administrativeVillage,
          bloodType: state.ktpModel?.bloodType,
          citizenship: state.ktpModel?.citizenship,
          gender: state.ktpModel?.gender,
          maritalStatus: state.ktpModel?.maritalStatus,
          occupation: state.ktpModel?.occupation,
          religion: state.ktpModel?.religion,
          subDistrict: state.ktpModel?.subDistrict,
          validUntil: state.ktpModel?.validUntil,
          villageUnit: state.ktpModel?.villageUnit,
        ),
      );
      // emit(state.copyWith(user: user, token: token));

      if (context.mounted) {
        RegisterOtpRoute(
          $extra: ExtrackKtpModel(),
          email: state.email,
          isLogin: true,
        ).push(context);

        ShowSnackbar.snackbar(
          context,
          'Kode OTP telah dikirim, silahkan cek email Anda.',
          isSuccess: true,
        );
      }
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
