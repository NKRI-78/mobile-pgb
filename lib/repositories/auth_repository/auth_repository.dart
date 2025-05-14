import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as ht;

import '../../misc/api_url.dart';
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
  String get registKtp => '${MyApi.baseUrl}/api/v1/ocr/ktp';

  final http = getIt<BaseNetworkClient>();

  Future<Map<String, dynamic>> uploadKtpForOcr(File ktpImage) async {
    try {
      final uri = Uri.parse(registKtp);
      final request = ht.MultipartRequest('POST', uri)
        ..files.add(await ht.MultipartFile.fromPath(
          'file',
          ktpImage.path,
        ));

      final response = await request.send();

      final responseBody = await response.stream.bytesToString();
      final json = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        return json;
      } else {
        throw json['message'] ?? "Gagal memproses KTP";
      }
    } on SocketException {
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkNik(String nik) async {
    try {
      final uri = Uri.parse('$auth/checkNik');
      final res = await ht.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nik': nik,
        }),
      );

      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return json['data']['isRegistered'] as bool;
      } else {
        throw json['message'] ?? "Gagal memeriksa NIK";
      }
    } on SocketException {
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      rethrow;
    }
  }

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
