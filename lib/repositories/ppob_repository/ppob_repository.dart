import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as httpBase;

import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import 'models/listrik_data_model.dart';
import 'models/payment_channel_modelv2.dart';
import 'models/pulsa_data_model.dart';

class PpobRepository {
  String get ppob => 'https://api-ppob.langitdigital78.com/api/v1/ppob/info';
  String get payment => 'http://157.245.193.49:3098/api/v1/channel';

  final http = getIt<BaseNetworkClient>();

  Future<List<ListrikDataModel>> fetchListrikData() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      final uri = Uri.parse("$ppob/price-list-pln-prabayar");

      final response = await httpBase
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      debugPrint("Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(
            "Failed to fetch data. Status code: ${response.statusCode}");
      }

      final Map<String, dynamic> decodedMap = json.decode(response.body);
      if (decodedMap['error'] == true) {
        throw Exception(decodedMap['message'] ?? "Error fetching data");
      }

      if (decodedMap.containsKey('data') && decodedMap['data'] is List) {
        final List<dynamic> dataList = decodedMap['data'];
        debugPrint(dataList.isEmpty
            ? "Data PLN kosong dari API."
            : "Data PLN ditemukan: ${dataList.length} items");

        return dataList.map((json) => ListrikDataModel.fromJson(json)).toList();
      } else {
        throw Exception("Invalid response format");
      }
    } on TimeoutException {
      throw Exception("Request timeout, server not responding");
    } catch (e) {
      debugPrint("Unexpected Error PLN: $e");
      throw Exception("Failed to fetch listrik data: $e");
    }
  }

  Future<List<PulsaDataModel>> fetchPulsaData({
    required String prefix,
    required String type,
  }) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      final uri = Uri.parse(
          "$ppob/price-list-pulsa-data-general?prefix=$prefix&type=$type");

      debugPrint("Fetching pulsa data...");
      debugPrint("API Request: $uri");
      debugPrint("Headers: $headers");

      final response = await httpBase
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));

      debugPrint("Response Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(
            "Failed to fetch data. Status code: ${response.statusCode}");
      }

      final Map<String, dynamic> decodedMap = json.decode(response.body);
      debugPrint("Decoded Response: $decodedMap");

      if (decodedMap['error'] == true) {
        throw Exception(decodedMap['message'] ?? "Error fetching data");
      }

      if (decodedMap.containsKey('data') && decodedMap['data'] is List) {
        final List<dynamic> dataList = decodedMap['data'];
        debugPrint(dataList.isEmpty
            ? "Data kosong dari API."
            : " Data ditemukan: ${dataList.length} items");

        return dataList.map((json) => PulsaDataModel.fromJson(json)).toList();
      } else {
        throw Exception("Invalid response format");
      }
    } on FormatException catch (e) {
      debugPrint("JSON Format Error: $e");
      throw Exception("Invalid response format");
    } on httpBase.ClientException catch (e) {
      debugPrint("HTTP Client Error: $e");
      throw Exception("Network error, please check your connection");
    } on TimeoutException {
      debugPrint("Request timeout!");
      throw Exception("Request timeout, server not responding");
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      throw Exception("Failed to fetch pulsa & data: $e");
    }
  }

  Future<List<PaymentChannelModelV2>> getChannels() async {
    try {
      var res = await http.get(Uri.parse(payment));

      debugPrint(res.body);

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        var list = (json['data'] as List)
            .map((e) => PaymentChannelModelV2.fromJson(e))
            .toList();
        return list;
      }
      if (res.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      } else {
        throw "Error";
      }
    } on SocketException {
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkoutItem({
    required String idPel,
    required String userId,
    required String productId,
    required int paymentChannel,
    required String paymentCode,
    required String type,
  }) async {
    try {
      final uri = Uri.parse(
          "https://api-ppob.langitdigital78.com/api/v1/payment/inquiry");
      var headers = {'Content-Type': 'application/json'};

      final body = jsonEncode({
        "app": "pgb",
        "idpel": idPel,
        "user_id": userId,
        "product_id": productId,
        "payment_channel": paymentChannel,
        "payment_code": paymentCode,
        "type": type,
      });

      debugPrint("Checkout Request: $body");

      final response = await httpBase
          .post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 10));

      debugPrint("Response Status: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);

        if (decoded['error'] == false && decoded.containsKey("data")) {
          return decoded["data"];
        } else {
          throw Exception(decoded['message'] ?? "Checkout gagal");
        }
      } else {
        throw Exception("Gagal checkout. Status code: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
