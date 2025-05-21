import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:mobile_pgb/misc/injections.dart';
import 'package:mobile_pgb/misc/modal.dart';
import 'package:mobile_pgb/misc/snackbar.dart';
import 'package:mobile_pgb/modules/app/bloc/app_bloc.dart';
import 'package:mobile_pgb/repositories/shop_repository/models/detail_product_model.dart';
import 'package:mobile_pgb/repositories/shop_repository/shop_repository.dart';

part 'detail_product_state.dart';

class DetailProductCubit extends Cubit<DetailProductState> {
  DetailProductCubit() : super(const DetailProductState());

  ShopRepository repo = getIt<ShopRepository>();

   void copyState({required DetailProductState newState}) {
    emit(newState);
  }

  Future<void> fetchDetailProduct(String productId) async {
    try {
      emit(state.copyWith(loading: true));
      final news = await repo.getDetailProduct(productId);
      emit(state.copyWith(detail: news, idProduct: productId));
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> assignQty(String productId, String qty, BuildContext context) async {
    try {
      await repo.assignQty(productId, qty);
      if(context.mounted){
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
        getIt<AppBloc>().add(InitialAppData());
        // ShowSnackbar.snackbar(context, "Dimasukkan ke keranjang", '', success);
      }
    } on SocketException catch (e) {
      Navigator.pop(context);
      if (!context.mounted) {
          return;
        }
      ShowSnackbar.snackbar(context, "Network Error: ${e.message}", isSuccess: false);
    } on ClientException catch (e) {
      Navigator.pop(context);
      if (!context.mounted) {
          return;
        }
      ShowSnackbar.snackbar(context, "Client Error: ${e.message}", isSuccess: false);
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      GeneralModal.showConfirmModal(
        msg: "$e", 
        showCancelButton: false,
        textConfirm: "Konfirmasi",
        context: context,
        onPressed: () async {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        locationImage: "assets/icons/dialog.png",
      );
    }
  }
}
