import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../../../misc/colors.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/checkout_repository/checkout_repository.dart';
import '../../../repositories/checkout_repository/models/checkout_detail_model.dart';
import '../../../repositories/checkout_repository/models/checkout_detail_new_model.dart';
import '../../../repositories/checkout_repository/models/cost_item_model_v2.dart';
import '../../../repositories/checkout_repository/models/main_shipping_model.dart';
import '../../../repositories/checkout_repository/models/payment_channel_model.dart';
import '../../../widgets/map/custom_select_location.dart';
import '../widget/cost_shipping.dart';
import '../widget/select_payment_channel.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutState());

  CheckoutRepository repo = CheckoutRepository();

  Future<void> init(
      {String from = "",
      String? qty,
      String? productId,
      required BuildContext context}) async {
    emit(const CheckoutState());
    getShippingMain();
    if (from == "NOW") {
      getCheckoutNow(
          from: from, qty: qty, productId: productId, context: context);
    } else {
      fetchCheckout(
          from: from, qty: qty, productId: productId, context: context);
    }
    emit(state.copyWith(
      from: from,
      qty: qty,
      productId: productId,
      channels: [],
      channel: null,
    ));
  }

  double _calculateTotal({
    required double productPrice,
    required double shippingCost,
    required double adminFee,
  }) {
    return productPrice + shippingCost + adminFee;
  }

  void updateCheckout({
    required List<CheckoutDetailModel> checkout,
    Map<String, dynamic>? shippings,
    PaymentChannelModel? e,
  }) async {
    double productPrice = state.totalPriceProduct ?? 0.0;

    if (state.from == "NOW") {
      final checkoutNow = await repo.checkoutNow(
        from: state.from,
        qty: state.qty,
        productId: state.productId,
      );

      productPrice = checkoutNow.totalPrice?.toDouble() ?? 0.0;
    }

    // ✅ Gunakan shipping yang terbaru kalau ada, kalau tidak pakai state sebelumnya
    final effectiveShippings = shippings ?? state.shippings;

    // ✅ Hitung shipping cost dari data yang efektif
    double shippingCost = effectiveShippings?.values.fold(
          0.0,
          (sum, item) => sum! + int.parse(item["cost"]).toDouble(),
        ) ??
        0.0;

    // ✅ Gunakan admin fee baru kalau ada, kalau tidak pakai yang lama
    double adminFee = e?.fee?.toDouble() ?? state.adminFee ?? 0.0;

    double totalPrice = _calculateTotal(
      productPrice: productPrice,
      shippingCost: shippingCost,
      adminFee: adminFee,
    );

    emit(state.copyWith(
      checkout: checkout,
      shippings: effectiveShippings,
      totalPriceProduct: productPrice,
      totalCost: shippingCost,
      adminFee: adminFee,
      totalPrice: totalPrice,
    ));
  }

  void calculateTotal() {
    double totalPriceProduct = state.checkout.fold(0.0, (sum, checkout) {
          return sum! +
              ((checkout.carts?.fold(0.0, (sum, cart) {
                        return sum + (cart.price ?? 0);
                      }) ??
                      0) *
                  (checkout.carts?.fold(0.0, (sum, cart) {
                        return (cart.quantity ?? 0);
                      }) ??
                      0));
        }) ??
        0;
    double totalCost = state.shippings?.values.fold(
            0.0, (sum, item) => sum! + (int.parse(item["cost"]).toDouble())) ??
        0.0;

    double admin = state.channel?.fee?.toDouble() ?? 0.0;
    double totalPrice = totalPriceProduct + totalCost + admin;

    emit(state.copyWith(
        totalPrice: totalPrice,
        totalCost: totalCost,
        adminFee: admin,
        totalPriceProduct: totalPriceProduct));
  }

  Future<void> fetchCheckout(
      {String from = "",
      String? qty,
      String? productId,
      required BuildContext context}) async {
    try {
      emit(state.copyWith(loading: true));
      var cart =
          await repo.getCheckout(from: from, qty: qty, productId: productId);

      double totalPriceProduct = cart.fold(0.0, (sum, checkout) {
        return sum +
            (checkout.carts?.fold(0.0, (cartSum, cart) {
                  return cartSum! +
                      ((cart.price ?? 0.0) * (cart.quantity ?? 0));
                }) ??
                0.0);
      });
      double totalCost = state.shippings?.values.fold(
            0.0,
            (sum, item) =>
                sum! + (double.tryParse(item["cost"].toString()) ?? 0.0),
          ) ??
          0.0;

      double admin = state.channel?.fee?.toDouble() ?? 0.0;

      double totalPrice = totalPriceProduct + totalCost + admin;

      emit(state.copyWith(
        checkout: cart,
        loading: false,
        totalPrice: totalPrice,
        adminFee: admin,
        totalCost: totalCost,
        totalPriceProduct: totalPriceProduct,
      ));
    } on SocketException catch (e) {
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(context, "Network Error: ${e.message}",
          isSuccess: false);
    } on ClientException catch (e) {
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(context, "Client Error: ${e.message}",
          isSuccess: false);
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(context, "Unexpected Error: $e", isSuccess: false);
    }
  }

  Future<void> getCheckoutNow(
      {String from = "",
      String? qty,
      String? productId,
      required BuildContext context}) async {
    try {
      print("Hit Now");
      emit(state.copyWith(loading: true));
      var checkoutNow =
          await repo.checkoutNow(from: from, qty: qty, productId: productId);

      double totalCost = state.shippings?.values.fold(0.0,
              (sum, item) => sum! + (int.parse(item["cost"]).toDouble())) ??
          0.0;

      double admin = state.channel?.fee?.toDouble() ?? 0.0;
      double totalPrice =
          checkoutNow.totalPrice?.toDouble() ?? 0.0 + totalCost + admin;

      print("Checkoutnow : ${jsonEncode(checkoutNow)}");
      emit(state.copyWith(
          checkoutNow: checkoutNow,
          loading: false,
          totalPrice: totalPrice,
          adminFee: admin,
          totalCost: totalCost,
          totalPriceProduct: checkoutNow.totalPrice?.toDouble() ?? 0.0));
    } on SocketException catch (e) {
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(context, "Network Error: ${e.message}",
          isSuccess: false);
    } on ClientException catch (e) {
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(context, "Client Error: ${e.message}",
          isSuccess: false);
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(context, "Unexpected Error: $e", isSuccess: false);
    }
  }

  Future<void> getShippingMain() async {
    try {
      emit(state.copyWith(loading: true));
      var shipping = await repo.getShippingMain();
      emit(state.copyWith(shipping: shipping, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false));
      print(e);
    }
  }

  Future<void> getCostItemV2(
      {required BuildContext context,
      required String storeId,
      required String weight}) async {
    try {
      emit(state.copyWith(loadingCost: true));
      var cost = await repo.getCostItemV2(storeId: storeId, weight: weight);
      if (cost.isNotEmpty && context.mounted) {
        showModalBottomSheet(
          isDismissible: true,
          enableDrag: true,
          barrierColor: AppColors.blackColor.withOpacity(0.5),
          context: context,
          builder: (_) => BlocProvider.value(
            value: context.read<CheckoutCubit>(),
            child: CostShipping(
              idStore: storeId,
              weight: weight,
            ),
          ),
        );
      } else {
        if (context.mounted) {
          ShowSnackbar.snackbar(
              context, "Anda belum menambahkan alamat pengiriman",
              isSuccess: false);
        }
      }
      emit(state.copyWith(cost: cost, loadingCost: false));
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.redColor,
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      emit(state.copyWith(loadingCost: false));
    }
  }

  Future<void> getPaymentChannel(BuildContext context) async {
    try {
      emit(state.copyWith(loadingChannel: true));
      var channels = await repo.getChannels();

      if (context.mounted) {
        showModalBottomSheet(
          context: context,
          builder: (_) => BlocProvider<CheckoutCubit>.value(
            value: context.read<CheckoutCubit>(),
            child: const SelectPaymentChannel(),
          ),
        );
      }

      emit(state.copyWith(channels: channels, loadingChannel: false));
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.redColor,
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      emit(state.copyWith(loadingChannel: false));
    }
  }

  void setPaymentChannel(PaymentChannelModel e) {
    emit(state.copyWith(channel: e));
  }

  Future<String> checkoutItem() async {
    try {
      emit(state.copyWith(loading: true));
      var paymentNumber = await repo.checkoutItem(
          from: state.from,
          payment: state.channel!,
          shippings: state.shippings,
          productId: state.productId,
          qty: state.qty);
      emit(state.copyWith(loading: false, shippings: null));
      return paymentNumber;
    } catch (e) {
      emit(state.copyWith(loading: false));
      rethrow;
    }
  }

  setCourier(
    String service,
    String cost,
    String etd,
    String storeId,
    String name,
    String note,
  ) async {
    try {
      emit(state.copyWith(loadingCurir: true));
      if (state.shippings == null) {
        var entry = {
          storeId: {
            'code': name,
            'service': service,
            'cost': cost,
            "etd": etd,
            "note": note,
          }
        };
        emit(state.copyWith(shippings: entry, loadingCurir: false));
      } else {
        state.shippings?[storeId] = {
          'code': name,
          'service': service,
          'cost': cost,
          "etd": etd,
          "note": note,
        };
        emit(state.copyWith(shippings: state.shippings, loadingCurir: false));
      }
      print("Shipping : ${state.shippings}");
    } catch (e) {
      print(e);

      ///
    }
  }

  @override
  Future<void> close() {
    print('fani');
    emit(state.copyWith(shippings: null));
    return super.close();
  }
}
