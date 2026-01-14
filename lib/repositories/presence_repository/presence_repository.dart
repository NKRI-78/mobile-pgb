import 'dart:convert';

import 'package:flutter/material.dart';

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';

class PresenceRepository {
  final BaseNetworkClient http = getIt<BaseNetworkClient>();

  String get _presenceUrl => '${MyApi.baseUrl}/api/v1/attendance/create';

  Future<Map<String, dynamic>> createPresence({
    required String tokenAttend,
    required double latitude,
    required double longitude,
    required bool isFakeGps,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_presenceUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "tokenAttend": tokenAttend,
          "latitude": latitude,
          "longitude": longitude,
          "is_fake_gps": isFakeGps,
        }),
      );

      debugPrint('Presence status: ${response.statusCode}');
      debugPrint('Presence body  : ${response.body}');

      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json;
      } else {
        throw Exception(json['message'] ?? 'Gagal melakukan absensi');
      }
    } catch (e) {
      debugPrint('CreatePresence error: $e');
      rethrow;
    }
  }
}
