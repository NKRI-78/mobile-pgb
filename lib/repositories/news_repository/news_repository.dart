import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import 'models/news_detail_model.dart';

class NewsRepository {
  String get news => '${MyApi.baseUrl}/api/v1/news';

  final http = getIt<BaseNetworkClient>();

  Future<DetailNewsModel> getDetailNews(int idNews) async {
    try {
      final res = await http.get(Uri.parse('$news/$idNews'));

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DetailNewsModel.fromJson(json);
      } else {
        throw "error api";
      }
    } on SocketException {
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      rethrow;
    }
  }
}
