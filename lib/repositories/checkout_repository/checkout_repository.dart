import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as httpBase;

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import '../../modules/app/bloc/app_bloc.dart';
import 'models/checkout_detail_model.dart';
import 'models/checkout_detail_new_model.dart';
import 'models/cost_item_model.dart';
import 'models/cost_item_model_v2.dart';
import 'models/cost_item_model_v3.dart';
import 'models/detail_address_model.dart';
import 'models/main_shipping_model.dart';
import 'models/payment_channel_model.dart';

class CheckoutRepository {
  String get checkout => '${MyApi.baseUrl}/api/v1/order/checkout-detail';
  String get checkoutItems => '${MyApi.baseUrl}/api/v1/order/checkout';
  String get shipping => '${MyApi.baseUrl}/api/v1/shipping-address';
  String get cost => '${MyApi.baseUrl}/api/v1/order/cost-item';
  String get paymentChannel => '${MyApi.baseUrl}/api/v1/payment/channel';
  final http = getIt<BaseNetworkClient>();

  Future<List<CheckoutDetailModel>> getCheckout(
      {String from = "", String? qty, String? productId}) async {
    try {
      print("From $from, qty $qty, productid $productId");
      final res = await http.post(Uri.parse(checkout), body: {
        'from': from,
        'qty': qty ?? "",
        'product_id': productId ?? "",
      });

      print(res.body);
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = json['data']['data'] as List;
        return list.map((e) => CheckoutDetailModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CheckoutDetailModel>> getCheckoutDataCart(
      {String from = "", String? qty, String? productId}) async {
    try {
      print("From $from, qty $qty, productid $productId");
      final res = await http.post(Uri.parse(checkout), body: {
        'from': from,
        'qty': qty ?? "",
        'product_id': productId ?? "",
      });

      print(res.body);
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = json['data']['data']['data'] as List;
        return list.map((e) => CheckoutDetailModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<MainShippingModel> getShippingMain() async {
    try {
      final res = await http.get(Uri.parse('$shipping/my/main-address'));

      print(res.body);
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return MainShippingModel.fromJson(json);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CheckoutDetailNowModel> checkoutNow(
      {String from = "", String? qty, String? productId}) async {
    try {
      print("From $from, qty $qty, productid $productId");
      final res = await http.post(Uri.parse(checkout), body: {
        'from': from,
        'qty': qty ?? "",
        'product_id': productId ?? "",
      });

      print(res.body);
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return CheckoutDetailNowModel.fromJson(json['data']);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CostItemModel>> getCostItem(
      {String? weight, String? storeId}) async {
    try {
      final res = await http.post(Uri.parse(cost), body: {
        'weight': weight,
        'storeId': storeId,
      });

      print(res.body);
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = json['data']['rajaongkir']['results'] as List;
        return list.map((e) => CostItemModel.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CostItemModelV2>> getCostItemV2(
      {String? weight, String? storeId}) async {
    try {
      final res = await http.post(Uri.parse('$cost/v2'), body: {
        'weight': weight,
        'storeId': storeId,
      });

      print(res.body);
      print("Status : ${res.statusCode}");
      print("Status : ${{
        'weight': weight,
        'storeId': storeId,
      }}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = json['data'] as List;
        return list.map((e) => CostItemModelV2.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<CostListModelV3?> getCostItemV3({
    String? weight,
    String? storeId,
  }) async {
    try {
      final res = await http.post(Uri.parse('$cost/v3'), body: {
        'weight': weight,
        'storeId': storeId,
      });

      print(res.body);
      print("Status : ${res.statusCode}");
      print("Params : ${{
        'weight': weight,
        'storeId': storeId,
      }}");

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        return CostListModelV3.fromJson(json);
      } else {
        final body = jsonDecode(res.body);
        if (body['message'] == "Alamat pengguna tidak ditemukan") {
          return null; // 👈 khusus gagal karena alamat
        }
        return null; // fallback case
      }
    } catch (e) {
      return null; // tangkap semua error tanpa throw
    }
  }

  Future<List<PaymentChannelModel>> getChannels() async {
    try {
      var res = await http.get(Uri.parse(paymentChannel));

      print(res.body);

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
    } catch (e) {
      rethrow;
    }
  }

  Future<int?> createAddress({
    required String? name,
    required String? phoneNumber,
    required String? label,
    required String isSelected,
    required String detailAddress,
    required String province,
    required String city,
    required String district,
    required String subDistrict,
    required String postalCode,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final body = {
        'name': name,
        'phone_number': phoneNumber,
        'label': label,
        'is_selected': isSelected,
        'detail_address': detailAddress,
        'province': province,
        'city': city,
        'district': district,
        'sub_district': subDistrict,
        'postal_code': postalCode,
        'latitude': latitude,
        'longitude': longitude,
      }..removeWhere((key, value) => value == null || value == '');

      print("Data body $body");

      final res = await http.post(Uri.parse(shipping), body: {
        'name': name,
        'phone_number': phoneNumber,
        'label': label,
        'is_selected': isSelected,
        'detail_address': detailAddress,
        'province': province,
        'city': city,
        'district': district,
        'sub_district': subDistrict,
        'postal_code': postalCode,
        'latitude': latitude,
        'longitude': longitude,
      });

      print(res.body);
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        print("Fetch Id : ${json['data']['id']}");
        return json['data']['id'];
      }
      if (res.statusCode == 400) {
        throw json['message'] ?? "Terjadi kesalahan";
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAddress({
    required String id,
    required String name,
    required String phoneNumber,
    required String? label,
    required String isSelected,
    required String detailAddress,
    required String province,
    required String city,
    required String district,
    required String subDistrict,
    required String postalCode,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final body = {
        'id': id,
        'name': name,
        'phone_number': phoneNumber,
        'label': label,
        'is_selected': isSelected,
        'detail_address': detailAddress,
        'province': province,
        'city': city,
        'district': district,
        'sub_district': subDistrict,
        'postal_code': postalCode,
        'latitude': latitude,
        'longitude': longitude,
      };
      final res = await http.post(Uri.parse(shipping), body: body);

      print(body);
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

  Future<DetailAddressModel> getDetailAddress(String idOrder) async {
    try {
      final res = await http.get(Uri.parse('$shipping/my/$idOrder'));

      print(res.body);
      print('$shipping/my/$idOrder');
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DetailAddressModel.fromJson(json['data']);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch (e) {
      rethrow;
    }
  }

  Future<String> checkoutItem(
      {required PaymentChannelModel payment,
      required String from,
      required Map<String, dynamic>? shippings,
      String? qty,
      String? productId}) async {
    try {
      final token = getIt<AppBloc>().state.token;
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = httpBase.Request('POST', Uri.parse(checkoutItems));
      if (from == "CART") {
        request.body = json.encode({
          "from": from,
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
          "store_shippings": shippings,
        });
      } else {
        request.body = json.encode({
          "from": from,
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
          "store_shippings": shippings,
          "order": {"product_id": productId, "qty": qty, "note": ""}
        });
      }
      request.headers.addAll(headers);

      log("Request : ${request.body}");

      httpBase.StreamedResponse response = await request.send();
      var responseString = await response.stream.bytesToString();
      final decodedMap = json.decode(responseString);
      if (response.statusCode == 200) {
        print(decodedMap['data']['paymentId']);
        return decodedMap['data']['paymentId'].toString();
      } else {
        throw decodedMap['message'] ?? "Terjadi kesalahan";
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
