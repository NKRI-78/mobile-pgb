import 'dart:convert';
import 'dart:io';

import 'package:mobile_pgb/misc/api_url.dart';
import 'package:mobile_pgb/misc/http_client.dart';
import 'package:mobile_pgb/misc/injections.dart';
import 'package:mobile_pgb/repositories/list_address_repository/models/address_list_model.dart';

class ListAddressRepository {
  String get shipping => '${MyApi.baseUrl}/api/v1/shipping-address';
  final http = getIt<BaseNetworkClient>();

  Future<List<AddressListModel>> getAddressList() async {
    try {
      final res = await http.get(Uri.parse('$shipping/my'));

      print(res.body);
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        var list = (json['data'] as List).map((e) => AddressListModel.fromJson(e)).toList();
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

  Future<void> deleteAddress(String idAddress) async {
    try {
      final res = await http.delete(Uri.parse('$shipping/$idAddress'));

      print(res.body);
      print("Status : ${res.statusCode}");

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
  Future<void> selectMainAddress(String idAddress) async {
    try {
      final res = await http.post(Uri.parse('$shipping/select-address/$idAddress'));

      print(res.body);
      print("Status : ${res.statusCode}");

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