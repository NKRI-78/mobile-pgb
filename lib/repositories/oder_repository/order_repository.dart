import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import '../../misc/pagination.dart';
import 'models/need_riview_model.dart';
import 'models/order_model.dart';
import 'models/tracking_biteship_model.dart';
import 'models/tracking_model.dart';
import 'models/waiting_payment_model.dart';

class OrderRepository {
  String get order => '${MyApi.baseUrl}/api/v1/order';
  String get tracking => '${MyApi.baseUrlBiteship}/v1';
  String get payment => '${MyApi.baseUrl}/api/v1/payment/me/waiting-payment';

  final http = getIt<BaseNetworkClient>();

  Future<PaginationModel<OrderModel>> getOrderStatus(
      {String status = "", int page = 0}) async {
    try {
      final res = await http
          .get(Uri.parse('$order/user/my-order?page=$page&status=$status'));
      print('$order/user/my-order?page=$page&status=$status');
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        var pagination = Pagination.fromJson(json['data']);
        var list = (json['data']['data'] as List)
            .map((e) => OrderModel.fromJson(e))
            .toList();
        return PaginationModel<OrderModel>(pagination: pagination, list: list);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<WaitingPaymentModel>> getPayment() async {
    try {
      final res = await http.get(Uri.parse(payment));

      print(res.body);
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = json['data'] as List;
        return list.map((e) => WaitingPaymentModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<TrackingModel> getDetailTracking(String idOrder) async {
    try {
      final res = await http.get(Uri.parse('$order/tracking/$idOrder'));

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return TrackingModel.fromJson(json['data']);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch (e) {
      rethrow;
    }
  }

  Future<TrackingBitshipModel> getDetailTrackingBiteship(String noResi) async {
    try {
      final res = await http.get(Uri.parse('$tracking/trackings/$noResi'),
          headers: {'x-public-key': 'public-langitdigital-78'});

      print("URL : $tracking/tracking/$noResi");

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return TrackingBitshipModel.fromJson(json);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch (e) {
      rethrow;
    }
  }

  Future<List<NeedRiviewModel>> getNeedRiview() async {
    try {
      final res = await http.get(Uri.parse('$order/user/need-rating'));

      debugPrint('$order/user/need-rating');
      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = json['data'] as List;
        return list.map((e) => NeedRiviewModel.fromJson(e)).toList();
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch (e) {
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

      final res = await http
          .post(Uri.parse('$order/user/rating/$idOrder'), body: body, headers: {
        'Content-Type': 'application/json',
      });

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
