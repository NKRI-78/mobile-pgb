import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as ht;

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import '../../modules/register_akun/model/extrack_ktp_model.dart';
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
  String get mediaUpload => '${MyApi.baseUrlUpload}/api/v1/media';

  final http = getIt<BaseNetworkClient>();

  Future<List<dynamic>> postMedia(
      {required String folder, required File media}) async {
    try {
      var request = ht.MultipartRequest('PUT', Uri.parse(mediaUpload));
      request.fields.addAll({'folder': 'profile', 'app': 'GEMA'});
      var headers = {'Authorization': 'Bearer ${http.token}'};
      request.headers.addAll(headers);
      debugPrint("Image : $media");
      request.files.add(await ht.MultipartFile.fromPath('images', media.path));

      ht.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        return jsonDecode(data)['data'];
      } else {
        debugPrint(response.reasonPhrase);
      }
      return [];
    } catch (e) {
      debugPrint('error profile $e');
      rethrow;
    }
  }

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

  Future<void> registerAkun({
    String email = '',
    String phone = '',
    String password = '',
    String oAuth = "",
    ExtrackKtpModel? ktpModel,
  }) async {
    try {
      print("Oauth : $oAuth");
      final response = await http.post(Uri.parse('$auth/register'), body: {
        'email': email,
        'password': password,
        'phone': phone,
        'address': ktpModel?.address ?? '',
        'name': ktpModel?.fullname ?? '',
        'gender': ktpModel?.translateGender,
        'nik': ktpModel?.nik ?? '',
        'avatar_link': ktpModel?.avatarLink ?? '',
        'birth_place_and_date': ktpModel?.birthPlaceAndDate ?? '',
        'village_unit': ktpModel?.villageUnit ?? '',
        'administrative_village': ktpModel?.administrativeVillage ?? '',
        'sub_district': ktpModel?.subDistrict ?? '',
        'religion': ktpModel?.religion ?? '',
        'marital_status': ktpModel?.maritalStatus ?? '',
        'occupation': ktpModel?.occupation ?? '',
        'citizenship': ktpModel?.citizenship ?? '',
        'blood_type': ktpModel?.bloodType ?? '',
        'valid_until': ktpModel?.validUntil ?? '',
        'oauth_id': oAuth,
      });

      final json = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return;
      }
      if (response.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      rethrow;
    }
  }

  Future<LoggedIn?> verifyOtp(
      String email, String verificationCode, VerifyEmailType type) async {
    try {
      final res = await http.post(Uri.parse('$auth/verify-email'), body: {
        'email': email,
        'otp': verificationCode,
        'type': type == VerifyEmailType.sendingOtp ? 'SENDING_OTP' : 'VERIFIED'
      });

      debugPrint('status : ${res.body}');

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (type == VerifyEmailType.sendingOtp) {
          return null;
        }
        return LoggedIn(
          token: json['data']['token'],
          user: User.fromJson(
            json['data'],
          ),
        );
      }
      if (res.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    }
    return null;
  }

  Future<void> resendOtp(String email) async {
    try {
      final res = await http.post(Uri.parse('$auth/verify-email'),
          body: {'email': email, 'type': 'SENDING_OTP'});

      debugPrint("Email $email");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return;
      }
      if (res.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgotPasswordSendOTP(String email) async {
    try {
      final res = await http.post(Uri.parse('$auth/forgot-password'), body: {
        'email': email,
        'step': "SENDING_OTP",
      });
      debugPrint("email : $email");
      debugPrint(res.body);

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return;
      }
      if (res.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    }
  }

  Future<void> forgotPasswordVerifyOTP(String email, String otp) async {
    try {
      final res = await http.post(Uri.parse('$auth/forgot-password'), body: {
        'email': email,
        'step': "VERIFICATION_OTP",
        'otp': otp,
      });
      debugPrint("email : $email");
      debugPrint(res.body);

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return;
      }
      if (res.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      rethrow;
    }
  }

  Future<void> forgotPasswordChangePass(
      String email, String otp, String password) async {
    try {
      final res = await http.post(Uri.parse('$auth/forgot-password'), body: {
        'email': email,
        'step': "CHANGE_PASSWORD",
        'otp': otp,
        'password': password,
      });
      debugPrint("email : $email");
      debugPrint(res.body);

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return;
      }
      if (res.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    }
  }

  Future<void> resendEmail(String emailOld, String emailNew) async {
    try {
      final res = await http.post(Uri.parse('$auth/resendEmail'), body: {
        'emailOld': emailOld,
        'emailNew': emailNew,
      });
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) return;
      if (res.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } catch (e) {
      rethrow;
    }
  }
}
