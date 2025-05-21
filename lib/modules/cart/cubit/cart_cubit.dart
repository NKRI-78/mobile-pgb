import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile_pgb/misc/injections.dart';
import 'package:mobile_pgb/misc/snackbar.dart';
import 'package:mobile_pgb/modules/app/bloc/app_bloc.dart';
import 'package:mobile_pgb/repositories/cart_repository/cart_repository.dart';
import 'package:mobile_pgb/repositories/cart_repository/models/cart_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  CartRepository repo = CartRepository();

  Future<void> fetchCart(BuildContext context) async {
    try {
      emit(state.copyWith(loading: true));
      var cart = await repo.getCart();
      emit(state.copyWith(cart: cart, loading: false));
    } on SocketException catch (e) {
      if (!context.mounted) {
          return;
        }
      ShowSnackbar.snackbar(context, "Network Error: ${e.message}", isSuccess: false);
    } on ClientException catch (e) {
      if (!context.mounted) {
          return;
        }
      ShowSnackbar.snackbar(context, "Client Error: ${e.message}", isSuccess: false);
    } catch (e) {
      if (!context.mounted) {
          return;
        }
      ShowSnackbar.snackbar(context, "Unexpected Error: $e", isSuccess: false);
    }
  }

  Future<void> deleteCart(String productId) async {
    try {
      emit(state.copyWith(loading: true));
      await repo.deleteCart(productId: productId);
      var cart = await repo.getCart();
      emit(state.copyWith(cart: cart, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false));
      print(e);
    }
  }

  Future<void> addQty(String productId, String qty) async {
    try {
      print("Product id add : $productId");
      await repo.addQty(productId, qty);
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> assignQty({String? productId, String? qty, bool? isSelected}) async {
    try {
      print("Product id add : $productId");
      await repo.assignQty(productId: productId ?? "0", qty: qty ?? "0", isSelected: isSelected);
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> removeQty(String productId) async {
    try {
      await repo.removeQty(productId);
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  bool get hasSelectedItems {
    return state.cart.any((cartModel) =>
      cartModel.carts?.any((e) => e.isSelected == true) ?? false);
  }

  void toggleSelection({
  required String productId,
  required bool isSelected,
  }) {
    final updatedCart = state.cart.map((cart) {
      return cart.copyWith(
        carts: cart.carts?.map((item) {
          if (item.product?.id.toString() == productId) {
            final stock = item.product?.stock ?? 0;
            final qty = item.quantity ?? 0;

            // Jika ingin memilih dan qty melebihi stock, sesuaikan
            final adjustedQty = isSelected
                ? (qty > stock ? stock : qty)
                : qty;

            return item.copyWith(
              isSelected: isSelected,
              quantity: adjustedQty,
            );
          }
          return item;
        }).toList(),
      );
    }).toList();

    emit(state.copyWith(cart: updatedCart));
  }

  void toggleSeller(int sellerIndex, bool? value) {
    final isChecked = value ?? false;

    final updatedCart = state.cart.asMap().entries.map((entry) {
      final index = entry.key;
      final seller = entry.value;

      if (index == sellerIndex) {
        final updatedCarts = seller.carts?.map((item) {
          return item.copyWith(isSelected: isChecked);
        }).toList();

        return seller.copyWith(carts: updatedCarts);
      }

      return seller;
    }).toList();

    emit(state.copyWith(cart: updatedCart));
  }



  num get totalSelectedPrice { // Ubah tipe total jadi num
    num total = 0; // Ganti ke num

    for (final cart in state.cart) {
      for (final item in cart.carts ?? []) {
        if (item.isSelected == true && (item.product?.stock ?? 0) > 0) {
          final stock = item.product!.stock;
          if ((item.quantity ?? 0) > stock) {
            item.quantity = stock; // ← Mutasi langsung di getter
          }
          final qty = item.quantity ?? 0;
          total += ((item.price ?? 0) * qty).toInt();
        }
      }
    }

    return total;
  }


  // 🔹 Update jumlah barang ke API
  // Future<void> _updateQuantityInApi(Product product) async {
  //   try {
  //     await _dio.put("https://api.example.com/products/${product.id}",
  //         data: product.toJson());
  //   } catch (e) {
  //     print("Error updating product quantity: $e");
  //   }
  // }

  @override
  Future<void> close() {
    getIt<AppBloc>().add(InitialAppData());
    return super.close();
  }
}
