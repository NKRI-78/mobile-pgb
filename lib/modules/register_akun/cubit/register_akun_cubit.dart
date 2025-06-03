import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_pgb/misc/register_akun_extra.dart';

import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/auth_repository/auth_repository.dart';
import '../../../repositories/event_repository/models/event_model.dart';
import '../../../router/builder.dart';
import '../../app/bloc/app_bloc.dart';
import '../../app/models/user_google_model.dart';
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

  void init({ExtrackKtpModel? extrackKtp, UserGoogleModel? userGoogle}) {
    emit(state.copyWith(ktpModel: extrackKtp, userGoogle: userGoogle));
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

      final isGoogleLogin = state.userGoogle?.oauthId != null;

      final email = isGoogleLogin ? state.userGoogle!.email : state.email;
      final avatar = isGoogleLogin ? state.userGoogle!.avatar : null;

      // Validasi Foto (jika bukan dari Google, harus upload manual)
      if (!isGoogleLogin && state.fileImage == null) {
        ShowSnackbar.snackbar(
          context,
          "Harap masukan foto",
          isSuccess: false,
        );
        emit(state.copyWith(isLoading: false));
        return;
      }

      // Validasi email, phone, password, dll
      final isClear = submissionValidation(
        context,
        email: email ?? '',
        phone: state.phone,
        password: state.password,
        passwordConfirm: state.passwordConfirm,
      );

      if (!isClear) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      // Upload foto jika bukan dari Google
      String imageUrl = avatar ?? "";
      if (avatar == null || avatar.isEmpty) {
        final linkImage =
            await repo.postMedia(folder: "images", media: state.fileImage!);
        print(linkImage);
        imageUrl = linkImage.first['url']; // gunakan hasil upload
      }

      await repo.registerAkun(
        email: email ?? '',
        phone: state.phone,
        password: state.password,
        oAuth: state.userGoogle?.oauthId ?? "",
        ktpModel: ExtrackKtpModel(
          avatarLink: imageUrl,
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

      if (isGoogleLogin) {
        final loggedIn = await repo.login(
            email: state.userGoogle?.email ?? '', password: state.password);

        if (context.mounted) {
          getIt<AppBloc>()
              .add(SetUserData(user: loggedIn.user, token: loggedIn.token));
          HomeRoute().go(context);
          ShowSnackbar.snackbar(
            isSuccess: true,
            context,
            "Login berhasil",
          );
        }
      } else {
        if (context.mounted) {
          RegisterOtpRoute(
            $extra: RegisterAkunExtra(),
            email: email ?? '',
            isLogin: true,
          ).push(context);

          ShowSnackbar.snackbar(
            context,
            'Kode OTP telah dikirim, silahkan cek email Anda.',
            isSuccess: true,
          );
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      ShowSnackbar.snackbar(
        context,
        e.toString(),
        isSuccess: false,
      );
      print("Error during registration: $e");
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
