import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_pgb/misc/api_url.dart';

import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import 'models/user_model.dart';

class LoggedIn {
  final User user;
  final String token;

  LoggedIn({
    required this.user,
    required this.token,
  });
}

class EmailNotActivatedFailure implements Exception {
  final String message;
  EmailNotActivatedFailure({this.message = 'Akun belum diverifikasi.'});
}

class EmailNotFoundFailure implements Exception {
  final String message;
  EmailNotFoundFailure({this.message = 'Email tidak ditemukan.'});
}

enum VerifyEmailType { sendingOtp, verified }

class AuthRepository {
  String get auth => '${MyApi.baseUrl}/api/v1/auth';

  final http = getIt<BaseNetworkClient>();

  Future<LoggedIn> login(
      {required String email, required String password}) async {
    try {
      final res = await http.post(Uri.parse(auth), body: {
        'email': email,
        'password': password,
      });

      debugPrint(res.body);
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        if (json['data']['deleted_at'] != null) {
          throw "Akun telah dihapus";
        }

        if (json["data"] != null && json["data"]['email_verified'] == null) {
          throw EmailNotActivatedFailure(
              message: json['message'] ?? "Terjadi kesalahan");
        }
        return LoggedIn(
          user: User.fromJson(
            json['data'],
          ),
          token: json['data']['token'],
        );
      }
      if (res.statusCode == 400) {
        if (json['error'] != null &&
            json['error']['message'] == "Email tidak ditemukan") {
          throw EmailNotFoundFailure();
        }
        throw json['message'] ?? "Terjadi Kesalahan";
      }
      throw json['message'] ?? "Terjadi Kesalahan";
    } on SocketException {
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      rethrow;
    }
  }
}
