import 'dart:convert';

import 'package:flutter/material.dart';

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import 'models/profile_model.dart';

class ProfileRepository {
  String get profile => '${MyApi.baseUrl}/api/v1/profile';

  final http = getIt<BaseNetworkClient>();

  Future<ProfileModel> getProfile() async {
    try {
      final res = await http.get(Uri.parse(profile));

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return ProfileModel.fromJson(json['data']);
      } else {
        throw "error api";
      }
    } catch (e) {
      rethrow;
    }
  }
}
