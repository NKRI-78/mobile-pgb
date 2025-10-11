import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import '../../misc/pagination.dart';
import 'models/notification_countv2_model.dart';
import 'models/notification_detail_model.dart';
import 'models/notification_detailv2_model.dart';
import 'models/notification_model.dart';
import 'models/notificationv2_model.dart';

class NotificationV2Repository {
  final http = getIt<BaseNetworkClient>();
  String get notif => '${MyApi.baseUrl}/api/v1/notification';
  String get notifV2 => '${MyApi.baseUrlPpob}/api/v1/inbox';

  Future<PaginationModel<NotificationModel>> getNotification(
      {int page = 1, String type = ""}) async {
    try {
      final res = await http
          .get(Uri.parse('$notif?page=$page&type=${type.replaceAll(" ", "")}'));

      print("Url : '$notif?page=$page&limit=10&type=$type'");

      final json = jsonDecode(res.body);
      print(json);

      if (res.statusCode == 200) {
        var pagination = Pagination.fromJson(json['data']);
        var list = (json['data']['data'] as List)
            .map((e) => NotificationModel.fromJson(e))
            .toList();
        return PaginationModel<NotificationModel>(
            pagination: pagination, list: list);
      }

      throw json['message'] ?? "Terjadi kesalahan";
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch (e) {
      rethrow;
    }
  }

  Future<NotificationDetail> getDetailNotif(int idNotif) async {
    try {
      final res = await http.get(Uri.parse("$notif/detail/$idNotif"));

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return NotificationDetail.fromJson(json);
      } else {
        throw "error api";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<NotificationCountV2Model> getBadgesNotif({String type = ""}) async {
    try {
      final res = await http.get(Uri.parse('$notif/getUnreadCount?type=$type'));

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return NotificationCountV2Model.fromJson(json['data']);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    }
  }

  Future<void> readNotif(String idNotif) async {
    try {
      final res = await http.post(Uri.parse('$notif/$idNotif/read'));

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return;
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    }
  }

  Future<void> readAllNotif() async {
    try {
      final res = await http.post(Uri.parse('$notif/readAllNotif'));

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return;
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    }
  }

  Future<void> readAllNotifPpob(String userId) async {
    try {
      final res = await http.put(
        Uri.parse('$notifV2/update/allread'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      debugPrint(res.body);

      final json = jsonDecode(res.body);
      if (res.statusCode == 200 && json['error'] == false) {
        return;
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch (e) {
      throw "Gagal menandai notifikasi PPOB sebagai dibaca: $e";
    }
  }

  Future<List<NotificationV2Model>> getInboxNotifications(String userId) async {
    try {
      final res = await http.post(
        Uri.parse(notifV2),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"user_id": userId}),
      );

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return (json['data'] as List)
            .map((e) => NotificationV2Model.fromJson(e))
            .toList();
      }

      throw json['message'] ?? "Terjadi kesalahan";
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch (e) {
      rethrow;
    }
  }

  Future<NotificationDetailV2> getDetailNotifV2(int idNotif) async {
    try {
      final res = await http.post(
        Uri.parse("$notifV2/detail"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"id": idNotif}),
      );

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return NotificationDetailV2.fromJson(json['data']);
      } else {
        throw "error api";
      }
    } catch (e) {
      rethrow;
    }
  }
}
