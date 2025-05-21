import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpBase;
import 'package:mobile_pgb/misc/api_url.dart';
import 'package:mobile_pgb/misc/http_client.dart';
import 'package:mobile_pgb/misc/injections.dart';
import 'package:mobile_pgb/repositories/payment_repository/models/payment_channel_model.dart';
import 'package:mobile_pgb/repositories/payment_repository/models/payment_model.dart';

class PaymentRepository {
  Uri get paymentChannel =>
      Uri.parse('http://157.245.193.49:9985/api/v1/channel');

  Uri findPaymentUri(String id) =>
      Uri.parse('${MyApi.baseUrl}/api/v1/payment/detail/$id');

  final http = getIt<BaseNetworkClient>();

  Future<PaymentModel> findPayment(String paymentNumber) async {
    try {
      var res = await http.get(findPaymentUri((paymentNumber)));

      debugPrint(res.body);

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return PaymentModel.fromJson(json['data']);
      }
      if (res.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      } else {
        throw "Error";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    }
  }

  Future<List<PaymentChannelModel>> getChannels() async {
    try {
      var res = await http.get(paymentChannel);

      debugPrint(res.body);

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        var list = (json['data'] as List)
            .map((e) => PaymentChannelModel.fromJson(e))
            .toList();
        return list;
      }
      if (res.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      } else {
        throw "Error";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    }
  }

  Future<String> topUpMe(PaymentChannelModel payment, String amount) async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${http.token}'
      };
      var res = httpBase.Request('POST', Uri.parse('${MyApi.baseUrl}/api/v1/topup'),);
      res.body = json.encode({
        "payment_method":  {
            "id": payment.id,
            "paymentType": payment.paymentType,
            "name": payment.name,
            "nameCode": payment.nameCode,
            "logo": payment.logo,
            "fee": payment.paymentType == "VIRTUAL_ACCOUNT" ? "6500" : "1500",
            "service_fee": "",
            "platform": payment.platform,
            "howToUseUrl": payment.howToUseUrl,
            "createdAt": payment.createdAt,
            "updatedAt": payment.updatedAt,
            "deletedAt": payment.deletedAt
        },
        "amountTopup": amount
      });
      res.headers.addAll(headers);
      debugPrint(res.body);

      httpBase.StreamedResponse response = await res.send();

      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        return jsonDecode(data)['data']['paymentId'].toString();
      }
      if (response.statusCode == 400) {
        debugPrint(response.reasonPhrase);
      }
    return "";
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    }
  }
}
