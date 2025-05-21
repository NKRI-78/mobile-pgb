import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_pgb/misc/api_url.dart';
import 'package:mobile_pgb/misc/http_client.dart';
import 'package:mobile_pgb/misc/injections.dart';
import 'package:mobile_pgb/modules/app/models/badges_order_model.dart';
import 'package:mobile_pgb/repositories/app_repository/model/setting_model.dart';

class AppRepository {
  String get settings => '${MyApi.baseUrl}/api/v1/settings';
  String get profile => '${MyApi.baseUrl}/api/v1/profile';
  String get order => '${MyApi.baseUrl}/api/v1/order';

  final http = getIt<BaseNetworkClient>();

  Future<SettingModel> isRealese() async {
    try {
      final res = await http.get(Uri.parse(settings));

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return SettingModel.fromJson(json);
      } else {
        throw "error api";
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future<ProfileModelV2> getProfile() async {
  //   try {
  //     final res = await http.get(Uri.parse(profile));

  //     final json = jsonDecode(res.body);
  //     debugPrint('RESULT PROFILE : $json');
  //     if (res.statusCode == 200) {
  //       return  ProfileModelV2.fromJson(json);
  //     } else {
  //       throw json['message'] ?? "Terjadi kesalahan";
  //     }
  //   } on SocketException {
  //     throw "Terjadi kesalahan jaringan";
  //   }
  // }

  Future<BadgesOrderModel> getBadgesOrder() async {
    try {
      final res = await http.get(Uri.parse('$order/allBadgeUser'));

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        
        return  BadgesOrderModel.fromJson(json['data']);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    }
  }
}