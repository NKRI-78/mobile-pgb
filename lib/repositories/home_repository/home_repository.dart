import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../../modules/app/bloc/app_bloc.dart';

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import 'models/about_model.dart';
import 'models/banner_model.dart';
import 'models/data_pagination.dart';
import 'models/news_model.dart';
import 'models/pagination_model.dart';

class HomeRepository {
  String get news => '${MyApi.baseUrl}/api/v1/news';

  String get banner => '${MyApi.baseUrl}/api/v1/banner';

  String get profile => '${MyApi.baseUrl}/api/v1/profile';

  String get about => '${MyApi.baseUrl}/api/v1/template';

  final http = getIt<BaseNetworkClient>();

  Future<DataPagination<NewsModel>> getNews({int page = 1}) async {
    try {
      final res = await http.get(Uri.parse('$news?page=$page'));
      final json = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final data = json['data'];
        final listNews = (data['data'] as List?) ?? [];

        return DataPagination<NewsModel>(
          list: listNews.map((e) => NewsModel.fromJson(e)).toList(),
          paginate: PaginationModel.fromJson({
            "currentPage": data['currentPage'],
            "pages": data['pages'],
          }),
        );
      } else {
        throw json['message'] ?? 'Terjadi kesalahan';
      }
    } catch (e) {
      debugPrint("Error fetching news: $e");
      rethrow;
    }
  }

  Future<BannerModel?> getBanner() async {
    try {
      final res = await http.get(Uri.parse(banner));

      debugPrint(res.body);
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return BannerModel.fromJson(json);
      } else {
        throw "error api";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setFcm(String token) async {
    try {
      debugPrint('FCM : $token');
      final res = await http.post(
        Uri.parse('$profile/fcm-update'),
        body: {'token': token},
      );
      debugPrint('Data FCM  : ${res.body}');

      if (res.statusCode == 200) {
        return;
      } else {
        throw "Ada masalah pada server";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    }
  }

  Future<AboutModel> getAboutUs() async {
    try {
      final res = await http.get(Uri.parse(about));
      debugPrint('Data About  : ${res.body}');

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        return AboutModel.fromJson(json['data']); // ✅ Kembalikan AboutModel
      } else {
        throw "Ada masalah pada server";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setLastLocatin(double longitude, double latitude) async {
    try {
      final res =
          await http.post(Uri.parse('$profile/set-last-location'), body: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      }, headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${getIt<AppBloc>().state.token}'
      });

      debugPrint('Data FCM  : ${res.body}');

      if (res.statusCode == 200) {
        return;
      } else {
        throw "error api";
      }
    } catch (e) {
      rethrow;
    }
  }
}
