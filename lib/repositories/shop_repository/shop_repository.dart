import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';

import '../../misc/api_url.dart';
import '../../misc/http_client.dart';
import '../../misc/injections.dart';
import '../../misc/pagination.dart';
import 'models/category_model.dart';
import 'models/detail_product_model.dart';
import 'models/product_model.dart';

class ShopRepository {
  String get shop => '${MyApi.baseUrl}/api/v1/product';
  String get detail => '${MyApi.baseUrl}/api/v1/product';
  String get cart => '${MyApi.baseUrl}/api/v1/cart';

  final http = getIt<BaseNetworkClient>();

  Future<List<CategoryModel>> getCategory() async {
    try {
      final res = await http.get(Uri.parse('$shop/getCategory'));

      print(res.body);
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = json['data'] as List;
        return list.map((e) => CategoryModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoryModel>> getCategoryPin() async {
    try {
      final res = await http.get(Uri.parse('$shop/getCategory/pinToHomepage'));

      print(res.body);
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final list = json['data'] as List;
        return list.map((e) => CategoryModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginationModel<ProductModel>> getProductRecomendation(
      {int? idCategory, int page = 1}) async {
    try {
      final res = await http.get(Uri.parse(
          '$shop/byCategory/fanbaseRecomendation?${idCategory == null ? "" : "category_id=$idCategory"}&page=$page&limit=20'));

      print(res.body);
      print(
          'Link : $shop/byCategory/fanbaseRecomendation?${idCategory == null ? "" : "category_id=$idCategory"}&page=$page');
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        var pagination = Pagination.fromJson(json['data']['pagination']);
        var list = (json['data']['data'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        print("Pagination : ${jsonEncode(pagination)}");
        return PaginationModel<ProductModel>(
            pagination: pagination, list: list);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } catch (e) {
      rethrow;
    }
  }

  // Future<PaginationModel<ProductModel>> getProductOfficial(
  //     {int? idCategory, int page = 0}) async {
  //   try {
  //     final res = await http.get(Uri.parse(
  //         '$shop/getProducts?${idCategory == null || idCategory == 0 ? "" : "category_id=$idCategory"}&page=$page'));

  //     print(
  //         'Url : $shop/getProducts?${idCategory == null ? "" : "category_id=$idCategory"}&page=$page');
  //     print(res.body);
  //     print("Status : ${res.statusCode}");

  //     final json = jsonDecode(res.body);
  //     if (res.statusCode == 200) {
  //       var pagination = Pagination.fromJson(json['data']);
  //       var list = (json['data']['data'] as List)
  //           .map((e) => ProductModel.fromJson(e))
  //           .toList();
  //       print("Pagination : ${jsonEncode(pagination)}");
  //       return PaginationModel<ProductModel>(
  //           pagination: pagination, list: list);
  //     } else {
  //       throw json['message'] ?? "Terjadi kesalahan";
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  Future<PaginationModel<ProductModel>> getProductOfficial({
    int? idCategory,
    int page = 1,
    String? searchQuery,
  }) async {
    try {
      // Buat list query param
      final queryParameters = <String, String>{};

      if (idCategory != null && idCategory != 0) {
        queryParameters['category_id'] = idCategory.toString();
      }

      queryParameters['page'] = page.toString();

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParameters['search'] = searchQuery;
      }

      // Buat Uri dengan query parameter yang benar
      final uri = Uri.parse(shop + '/getProducts')
          .replace(queryParameters: queryParameters);

      final res = await http.get(uri);

      print('Url : $uri');
      print(res.body);
      print("Status : ${res.statusCode}");

      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        var pagination = Pagination.fromJson(json['data']);
        var list = (json['data']['data'] as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
        print("Pagination : ${jsonEncode(pagination)}");
        return PaginationModel<ProductModel>(
            pagination: pagination, list: list);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DetailProductModel> getDetailProduct(String idProduct) async {
    try {
      final res = await http.get(Uri.parse('$detail/$idProduct'));

      debugPrint(res.body);
      print("ID Product : $idProduct");
      final json = jsonDecode(res.body);
      if (res.statusCode == 200) {
        return DetailProductModel.fromJson(json);
      } else {
        throw json['message'] ?? "Terjadi kesalahan";
      }
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch (e) {
      print('Error $e');
      rethrow;
    }
  }

  Future<void> assignQty(String productId, String qty) async {
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
