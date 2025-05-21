import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as httpBase;

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import '../../modules/app/bloc/app_bloc.dart';
import 'model/payment_channel_model.dart';

class WalletRepository {
  String get topUp => '${MyApi.baseUrl}/api/v1/topup';
  String get paymentChannel => '${MyApi.baseUrl}/api/v1/payment/channel';
  final http = getIt<BaseNetworkClient>();

  Future<int> topUpWallet({
    required PaymentChannelModel payment,
    required int amountTopup,
  }) async {
    try {
      final token = getIt<AppBloc>().state.token;
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      var request = httpBase.Request('POST', Uri.parse(topUp));
      request.body = json.encode({
        "payment_method": {
          "id": payment.id,
          "paymentType": payment.paymentType,
          "name": payment.name,
          "nameCode": payment.nameCode,
          "logo": payment.logo,
          "fee": payment.fee,
          "service_fee": payment.serviceFee,
          "platform": payment.platform,
          "howToUseUrl": payment.howToUseUrl,
          "createdAt": payment.createdAt,
          "updatedAt": payment.updatedAt,
          "deletedAt": payment.deletedAt
        },
        'amountTopup': amountTopup,
      });

      request.headers.addAll(headers);

      httpBase.StreamedResponse response = await request.send();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);

      if (response.statusCode == 200) {
        final paymentId = decodedMap['data']?['paymentModel']?['id'];

        if (paymentId is int) {
          return paymentId;
        } else {
          throw "ID transaksi tidak ditemukan";
        }
      } else {
        throw decodedMap['message'] ?? "Terjadi kesalahan";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PaymentChannelModel>> getChannels() async {
    try {
      var res = await http.get(Uri.parse(paymentChannel));

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
      throw "Terjadi Kesalahan Jaringan";
    } on TimeoutException {
      throw "Koneksi internet lambat, periksa jaringan Anda";
    } catch (e) {
      rethrow;
    }
  }
}
