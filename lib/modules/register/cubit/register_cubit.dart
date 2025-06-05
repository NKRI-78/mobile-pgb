import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as ht;
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../misc/injections.dart';
import '../../../misc/register_akun_extra.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/auth_repository/models/user_model.dart';
import '../../../router/builder.dart';
import '../../app/bloc/app_bloc.dart';
import '../../app/models/user_google_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      // Trigger login Google
      final googleUser = await GoogleSignIn().signIn();

      // Jika user batal login (tekan back), googleUser akan null
      if (googleUser == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }

      final googleAuth = await googleUser.authentication;

      if (googleAuth.accessToken == null) {
        ShowSnackbar.snackbar(
          isSuccess: false,
          context,
          "Gagal mendapatkan token akses Google",
        );
        emit(state.copyWith(isLoading: false));
        return;
      }

      final accessToken = googleAuth.accessToken;

      print("Access Token: $accessToken");

      final response = await ht.post(
        Uri.parse("http://157.245.193.49:9985/api/v1/auth/signinWithGoogle"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'token': accessToken}),
      );

      print("✅ API response: ${response.body}");

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = jsonData['data']['token'];
        final userMap = jsonData['data'];
        if (userMap == null) {
          throw Exception("User data is missing");
        }
        final user = UserModel.fromJson(userMap);

        // Simpan ke AppBloc (pastikan getIt sudah terdaftar AppBloc)
        getIt<AppBloc>().add(SetUserData(token: token, user: user));

        if (!context.mounted) return;

        HomeRoute().go(context);

        ShowSnackbar.snackbar(
          isSuccess: true,
          context,
          "Login berhasil dengan Google",
        );
      } else {
        final message = jsonData['message'] ?? '';
        final action = jsonData['data']?['action'] ?? '';

        if (message.toLowerCase().contains('user not found') &&
            action == 'REGISTER') {
          final UserGoogleModel dataGoogle =
              UserGoogleModel.fromJson(jsonData['data']);
          final RegisterAkunExtra akunExtra =
              RegisterAkunExtra(userGoogle: dataGoogle);
          emit(state.copyWith(oauthId: dataGoogle.oauthId));
          if (!context.mounted) return;
          RegisterKtpRoute($extra: akunExtra).push(context);
        } else {
          // Jika bukan kondisi REGISTER, bisa tampilkan pesan error umum
          ShowSnackbar.snackbar(
            isSuccess: false,
            context,
            message.isNotEmpty ? message : "Terjadi kesalahan saat login",
          );
        }
      }
    } catch (e) {
      if (!context.mounted) return;

      ShowSnackbar.snackbar(
        isSuccess: false,
        context,
        e.toString(),
      );
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
