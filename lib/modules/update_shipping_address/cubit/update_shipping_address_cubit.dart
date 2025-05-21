import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_pgb/misc/injections.dart';
import 'package:mobile_pgb/misc/snackbar.dart';
import 'package:mobile_pgb/modules/list_address/cubit/list_address_cubit.dart';
import 'package:mobile_pgb/repositories/checkout_repository/checkout_repository.dart';
import 'package:mobile_pgb/repositories/checkout_repository/models/detail_address_model.dart';
import 'package:mobile_pgb/widgets/map/custom_select_location.dart';

part 'update_shipping_address_state.dart';

class UpdateShippingAddressCubit extends Cubit<UpdateShippingAddressState> {
  UpdateShippingAddressCubit() : super(const UpdateShippingAddressState());

  static GoogleMapController? googleMapCheckIn;

  CheckoutRepository repo = CheckoutRepository();

   bool submissionValidation({
    required String name,
    required String phone,
    required String label,
    required String city,
    required String postalCode,
    required String district,
    required String province,
    required String currentAddress
  }) {
    if (name == "") {
      throw 'Harap Masukkan Nama Penerima';
    } else if (phone.length < 10) {
      throw 'No Hp Minimal 10 Angka';
    } else if (label == "") {
      throw 'Harap Masukkan Label';
    } else if (city == "") {
      throw 'Harap Masukkan Kota';
    } else if (postalCode == "") {
      throw 'Harap Masukkan Kode Pos';
    } else if (district == "") {
      throw 'Harap Masukkan Daerah';
    } else if (province == "") {
      throw 'Harap Masukkan Provinsi';
    } else if (province == "") {
      throw 'Harap Masukkan Alamat Sekarang';
    }

    return true;
  }

  Future<void> fetchDetailAddress(String idAddress) async {
    try {
      emit(state.copyWith(loading: true));
      final detailAddress = await repo.getDetailAddress(idAddress);
      emit(state.copyWith(
        detailAddress: detailAddress,
        idAddress: idAddress,
        label: detailAddress.label,
        nameAddress: detailAddress.name ?? "",
        phoneNumber: detailAddress.phoneNumber ?? "",
        city: detailAddress.address?.city,
        province: detailAddress.address?.province,
        district: detailAddress.address?.district,
        postalCode: detailAddress.address?.postalCode.toString(),
        latitude: detailAddress.address?.latitude ?? 0.0,
        longitude: detailAddress.address?.longitude ?? 0.0,
        currentAddress: detailAddress.address?.detailAddress ?? "",
        loading: false,
      ));
    }on SocketException {
      throw "Terjadi kesalahan jaringan";
    } catch(e) {
      rethrow;
    }  finally {
      emit(state.copyWith(loading: false));
    }
  }

  void copyState({required UpdateShippingAddressState newState}) {
    emit(newState);
  }

  Future<void> updateCurrentPositionCheckIn(BuildContext context, double lat, double lng) async {
    try {
      googleMapCheckIn?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 15.0
          )
        )
      );
    } catch(e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  void setAreaCurrent(GoogleMapController mapController) async {
    Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    

    emit(state.copyWith(
      latitude: position.latitude, 
      longitude: position.longitude,
      // currentAddress: "${place.thoroughfare} ${place.subThoroughfare} ${place.locality}, ${place.postalCode}"
    ));
    print("Lat cubit ${state.latitude}");
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(state.latitude, state.longitude),
          zoom: 15.0
        )
      )
    );

    // mapController.moveCamera(CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)));
    // mapController.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(state.latitude, state.longitude), zoom: 15.0,)));
  }

  /// Memperbarui data alamat toko dan lokasi
  void updateShopAddress({
    String? address,
    String? province,
    String? city,
    String? subDistrict,
    String? postalCode,
    String? district,
    LatLng? location, // Add location parameter
  }) {
    emit(state.copyWith(
      shopAddress: address,
      province: province,
      city: city,
      subDistrict: subDistrict,
      postalCode: postalCode,
      district: district,
      shopLocation: location, // Update shop location
    ));
  }

  Future<void> submit({
    required BuildContext context,
    required String name,
    required String phoneNumber,
    required String label,
    required String currentAddress
  }) async {
    try {
      emit(state.copyWith(loading: true));
      final bool isClear = submissionValidation(
        name: state.nameAddress,
        city: state.city,
        currentAddress: state.currentAddress,
        district: state.district,
        label: state.label,
        phone: state.phoneNumber,
        postalCode: state.postalCode,
        province: state.province,
      );
      if(isClear){
        await repo.updateAddress(
          id: state.idAddress,
          name: name,
          phoneNumber: phoneNumber,
          label: label,
          isSelected: "true",
          detailAddress: currentAddress,
          city: state.city,
          district: state.district,
          province: state.province,
          latitude: state.latitude.toString(),
          longitude: state.longitude.toString(),
          postalCode: state.postalCode,
          subDistrict: state.subDistrict,
        );
      }
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
        ShowSnackbar.snackbar(context, "Berhasil ${state.idAddress == null ? "Tambah" : "Ubah"} alamat", isSuccess: true);
        getIt<ListAddressCubit>().refreshAddress();
      });
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(context, e.toString(), isSuccess: true);
    } finally {
      emit(state.copyWith(loading: false));
    }
  }
}
