import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:mobile_pgb/misc/api_url.dart';
import 'package:mobile_pgb/misc/http_client.dart';
import 'package:mobile_pgb/misc/injections.dart';
import 'package:mobile_pgb/repositories/detail_order_repository/models/detail_order_model.dart';

class DetailOrderRepository {
  String get order => '${MyApi.baseUrl}/api/v1/order';

  final http = getIt<BaseNetworkClient>();
  
  Future<DetailOrderModel> getDetailOrder(String idOrder) async {
    try {
      final res = await http.get(Uri.parse('$order/detail/$idOrder'));

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DetailOrderModel.fromJson(json['data']);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch(e) {
      rethrow;
    }
  }

  Future<void> getEndOrder(String idOrder) async {
    try {
      final res = await http.post(Uri.parse('$order/user/finish-order/$idOrder'));

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return;
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch(e) {
      rethrow;
    }
  }

  Future<void> userRating({
    String idOrder = "",
    String message = "",
    int rating = 0,
    List<String> images = const [],
  }) async {
    try {
      final body = jsonEncode({
        "message": message, 
        "rating": rating,
        "images": images,
      });
      debugPrint(body);
      debugPrint('$order/user/rating/$idOrder');

      final res = await http.post(Uri.parse('$order/user/rating/$idOrder'), body: body, headers: {'Content-Type': 'application/json',});
      
      debugPrint(res.body);

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
  
}