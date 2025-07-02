import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../checkout/cubit/checkout_cubit.dart';
import '../../list_address/cubit/list_address_cubit.dart';
import '../../../repositories/checkout_repository/checkout_repository.dart';
import '../../../repositories/checkout_repository/models/detail_address_model.dart';
import '../../../repositories/list_address_repository/list_address_repository.dart';
import '../../../widgets/map/custom_select_location.dart';

part 'create_shipping_address_state.dart';

class CreateShippingAddressCubit extends Cubit<CreateShippingAddressState> {
  CreateShippingAddressCubit() : super(const CreateShippingAddressState());

  static GoogleMapController? googleMapCheckIn;

  CheckoutRepository repo = CheckoutRepository();

  ListAddressRepository addressRepo = ListAddressRepository();

  void copyState({required CreateShippingAddressState newState}) {
    emit(newState);
  }

  bool submissionValidation({
    required BuildContext context,
    required String name,
    required String phone,
    required String label,
    required String city,
    required String postalCode,
    required String district,
    required String province,
    required String currentAddress
  }) {
    if (name.trim().isEmpty) {
      ShowSnackbar.snackbar(context, 'Harap Masukkan Nama Penerima', isSuccess: false);
      return false;
    } else if (phone.length < 10) {
      ShowSnackbar.snackbar(context, 'No Hp Minimal 10 Angka', isSuccess: false);
      return false;
    } else if (label.trim().isEmpty) {
      ShowSnackbar.snackbar(context, 'Harap Masukkan Label', isSuccess: false);
      return false;
    } else if (city.trim().isEmpty) {
      ShowSnackbar.snackbar(context, 'Harap Masukkan Kode Pos', isSuccess: false);
      return false;
    } else if (postalCode.trim().isEmpty) {
      ShowSnackbar.snackbar(context, 'Harap Masukkan Kode Pos', isSuccess: false);
      return false;
    } else if (district.trim().isEmpty) {
      ShowSnackbar.snackbar(context, 'Harap Masukkan Daerah', isSuccess: false);
      return false;
    } else if (province.trim().isEmpty) {
      ShowSnackbar.snackbar(context, 'Harap Masukkan Provinsi', isSuccess: false);
      return false;
    } else if (currentAddress.trim().isEmpty) {
      ShowSnackbar.snackbar(context, "Harap Masukkan Alamat", isSuccess: false);
      return false;
    }

    return true;
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
  }) async {
    try {
      emit(state.copyWith(loading: true));
      int? idNewAddress;
      final bool isClear = submissionValidation(
        context: context,
        name: state.nameAddress,
        city: state.city,
        currentAddress: state.currentAddress,
        district: state.district,
        label: state.label,
        phone: state.phoneNumber,
        postalCode: state.postalCode,
        province: state.province,
      );
      print("Is Clear : $isClear");
      print("Is Clear : ${state.currentAddress}");
      if(isClear){
        idNewAddress = await repo.createAddress(
          name: state.nameAddress,
          phoneNumber: state.phoneNumber,
          label: state.label,
          isSelected: "true",
          detailAddress: state.currentAddress,
          city: state.city,
          district: state.district,
          province: state.province,
          latitude: state.latitude.toString(),
          longitude: state.longitude.toString(),
          postalCode: state.postalCode,
          subDistrict: state.subDistrict,
        );

        await addressRepo.selectMainAddress(idNewAddress.toString());

        Future.delayed(Duration.zero, () {
          Navigator.pop(context);
          ShowSnackbar.snackbar(context, "Berhasil Tambah alamat", isSuccess: true);
          getIt<ListAddressCubit>().refreshAddress();
          getIt<CheckoutCubit>().getShippingMain();
        });
      } 

    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ShowSnackbar.snackbar(context, e.toString(), isSuccess: false);
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
