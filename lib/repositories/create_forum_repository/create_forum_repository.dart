import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:http/http.dart' as http;
import 'package:mobile_pgb/misc/api_url.dart';
import 'package:mobile_pgb/misc/http_client.dart';
import 'package:mobile_pgb/misc/injections.dart';

class CreateForumRepository {
  String get forum => '${MyApi.baseUrl}/forums';
  String get mediaUpload => '${MyApi.baseUrlUpload}/media';
  final httpBase = getIt<BaseNetworkClient>();

  Future<void> createForum({
    String description = '',
    List<dynamic> medias = const [],
  }) async {
    try {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${httpBase.token}'
    };
    var request = http.Request('POST', Uri.parse(forum));
    request.body = json.encode({
      "description": description,
      "medias": medias
    });
    debugPrint('Data Upload : ${request.body}');
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      debugPrint(await response.stream.bytesToString());
    }
    else {
      debugPrint(response.reasonPhrase);
    }
    } catch (e) {
      rethrow;
    }
  }
  Future<List<dynamic>> postMedia({
    required String folder,
    required List<File> media
  }) async {
    try {

      var request = http.MultipartRequest('POST', Uri.parse(mediaUpload));
      request.fields.addAll({
        'folder': 'forum'
      });
      var headers = {
        'Authorization': 'Bearer ${httpBase.token}'
      };
      request.headers.addAll(headers);

      for (File d in media){
        request.files.add(await http.MultipartFile.fromPath('images', d.path));
      }

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final data = await response.stream.bytesToString();
        return jsonDecode(data)['data'];
      }
      else {
        debugPrint(response.reasonPhrase);
      }
    return [];
    } catch (e) {
      rethrow;
    }
  }
}