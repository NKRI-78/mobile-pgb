import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import 'models/event_detail_model.dart';
import 'models/event_model.dart';

class EventRepository {
  String get event => '${MyApi.baseUrl}/api/v1/event';

  final http = getIt<BaseNetworkClient>();

  Future<List<EventModel>> getEvents() async {
    try {
      debugPrint("Fetching events...");

      final res =
          await http.get(Uri.parse(event)).timeout(Duration(seconds: 30));

      debugPrint("Response Status: ${res.statusCode}");
      debugPrint("Response Body: ${res.body}");

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (res.body.isNotEmpty) {
          final json = jsonDecode(res.body);
          final list = json['data']['data'] as List;
          return list.map((e) => EventModel.fromJson(e)).toList();
        } else {
          throw "Empty response body";
        }
      } else {
        throw "Error API: ${res.statusCode} - ${res.body}";
      }
    } on SocketException {
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      debugPrint("Error fetching events: $e");
      rethrow;
    }
  }

  Future<EventDetailModel> getEventDetail(int idEvent) async {
    try {
      final res = await http.get(Uri.parse('$event/$idEvent/detail'));

      debugPrint("API RESPONSE: ${res.body}");
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return EventDetailModel.fromJson(json);
      } else {
        throw "Error API: ${res.statusCode} - ${res.body}";
      }
    } on SocketException {
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      debugPrint("Error fetching event: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> jointEvent({String idEvent = ""}) async {
    try {
      final res = await http.post(
        Uri.parse('$event/joinAndUnjoin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'eventId': idEvent,
        }),
      );

      debugPrint("Join Event ID: $idEvent");
      debugPrint("Response body: ${res.body}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return json;
      }
      if (res.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      }

      throw "Terjadi kesalahan tak terduga";
    } catch (e) {
      rethrow;
    }
  }
}
