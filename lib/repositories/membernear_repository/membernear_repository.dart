import 'dart:convert';

import 'package:flutter/material.dart';

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import 'models/membernear_model.dart';

class MemberNearRepository {
  String get membernear => '${MyApi.baseUrl}/api/v1/member-near';

  final http = getIt<BaseNetworkClient>();

  Future<MemberNearModel?> getMemberNear(
      {String latitude = "", String longitude = ""}) async {
    try {
      Map<String, String?> body;
      body = {
        'latitude': latitude,
        'longitude': longitude,
      };
      print("Body : $body");
      final res = await http.post(Uri.parse(membernear), body: body);

      debugPrint("Member near data :  ${res.body}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return MemberNearModel.fromJson(json);
      }
      if (res.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
