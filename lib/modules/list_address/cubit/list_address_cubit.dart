import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_pgb/misc/injections.dart';
import 'package:mobile_pgb/modules/checkout/cubit/checkout_cubit.dart';
import 'package:mobile_pgb/repositories/list_address_repository/list_address_repository.dart';
import 'package:mobile_pgb/repositories/list_address_repository/models/address_list_model.dart';

part 'list_address_state.dart';

class ListAddressCubit extends Cubit<ListAddressState> {
  ListAddressCubit() : super(const ListAddressState());

  ListAddressRepository repo = ListAddressRepository();

  Future<void> getListAddress() async {
    try {
      print("Hit");
      emit(state.copyWith(loading: true));
      var address = await repo.getAddressList();
      emit(state.copyWith(address: address, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false));
      print(e);
    }
  }

  Future<void> refreshAddress() async {
    print("Hit");
    var address = await repo.getAddressList();
    emit(state.copyWith(address: address,));
  }

  Future<void> deleteAddress(String idAddress) async {
    try {
      emit(state.copyWith(loading: true));
      await repo.deleteAddress(idAddress);
      var address = await repo.getAddressList();
      emit(state.copyWith(loading: false, address: address));
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } finally {
      emit(state.copyWith(loading: false));
    }
  }
  Future<void> selectMainAddress(String idAddress) async {
    try {
      emit(state.copyWith(loading: true));
      await repo.selectMainAddress(idAddress);
      var address = await repo.getAddressList();
      emit(state.copyWith(loading: false, address: address));
    } on SocketException {
      throw "Terjadi kesalahan jaringan";
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  @override
  Future<void> close() {
    getIt<CheckoutCubit>().getShippingMain();
    return super.close();
  }
}
