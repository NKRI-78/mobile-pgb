import 'dart:convert';

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import 'models/cart_count_model.dart';
import 'models/cart_model.dart';

class CartRepository {
  String get cart => '${MyApi.baseUrl}/api/v1/cart';

  final http = getIt<BaseNetworkClient>();

  Future<List<CartModel>> getCart() async {
    try {
      final res = await http.get(Uri.parse(cart));

      print(res.body);
      print("Status : ${res.body}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = json['data'] as List;
        return list.map((e) => CartModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<CartCountModel> getCartCount() async {
    try {
      final res = await http.get(Uri.parse('$cart/quantity/count'));

      print(res.body);
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return CartCountModel.fromJson(json['data']);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCart({
    String productId = "",
  }) async {
    try {
      print("productId : $productId");
      final res = await http.delete(Uri.parse('$cart/$productId'));

      print(res.body);

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

  Future<void> addQty(String productId, String qty) async {
    try {
      print("Product id : $productId, qty : $qty");
      final res = await http.post(Uri.parse('$cart/add-quantity'), body: {
        'product_id': productId,
        'qty': qty,
      });

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

  Future<void> assignQty(
      {required String productId,
      required String qty,
      bool? isSelected}) async {
    try {
      print("Product id : $productId, qty : $qty, isSelected $isSelected ");

      Map<String, String?> body;
      if (isSelected == null) {
        body = {
          'product_id': productId,
          'quantity': qty,
        };
      } else {
        body = {
          'product_id': productId,
          'quantity': qty,
          'is_selected': isSelected.toString(),
        };
      }

      final res = await http.post(Uri.parse(cart), body: body);

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

  Future<void> removeQty(String productId) async {
    try {
      print("Product id : $productId");
      final res = await http.post(Uri.parse('$cart/remove-quantity'), body: {
        'product_id': productId,
      });

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

  Future<void> assignCart(
      String productId, String qty, String? price, bool isSelected) async {
    try {
      print("Product id : $productId, qty : $qty");
      final res = await http.post(Uri.parse(cart), body: {
        'product_id': productId,
        'quantity': qty,
        'price': price,
        'is_selected': isSelected,
      });

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
