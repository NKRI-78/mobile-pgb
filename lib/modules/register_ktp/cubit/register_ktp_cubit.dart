import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../misc/register_akun_extra.dart';
import '../../app/models/user_google_model.dart';

import '../../../misc/injections.dart';
import '../../../misc/snackbar.dart';
import '../../../repositories/auth_repository/auth_repository.dart';
import '../../../router/builder.dart';
import '../../register_akun/model/extrack_ktp_model.dart';

part 'register_ktp_state.dart';

class RegisterKtpCubit extends Cubit<RegisterKtpState> {
  RegisterKtpCubit() : super(const RegisterKtpState());

  AuthRepository repo = getIt<AuthRepository>();

  void copyState({required RegisterKtpState newState}) {
    emit(newState);
  }

  void reset() {
    emit(RegisterKtpState());
  }

  Future<void> uploadKtpImage(String imagePath) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final result = await repo.uploadKtpForOcr(File(imagePath));

      final response = result['data']['response'];

      emit(state.copyWith(
        loading: false,
        ktpImagePath: imagePath,
        nik: response['nik'] ?? '',
        nama: response['name'] ?? '',
        ttl: response['place_date_birth'] ?? '',
        jenisKelamin: response['gender'] ?? '',
        golDarah: response['blood_type'] ?? '',
        alamat: response['address'] ?? '',
        rtRw: response['rt/rw'] ?? '',
        kelDesa: response['village'] ?? '',
        kecamatan: response['district'] ?? '',
        agama: response['religion'] ?? '',
        statusPerkawinan: response['status'] ?? '',
        pekerjaan: response['job'] ?? '',
        kewarganegaraan: response['country'] ?? '',
        berlakuHingga: response['expired'] ?? '',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> scanKtp({UserGoogleModel? userGoogle}) async {
    emit(state.copyWith(loading: true, userGoogleModel: userGoogle));

    try {
      final images = await CunningDocumentScanner.getPictures(
        isGalleryImportAllowed: true,
        noOfPages: 1,
      );

      if (images != null && images.isNotEmpty) {
        final imagePath = images.first;

        // Panggil API upload KTP dan ekstraksi teks OCR
        await uploadKtpImage(imagePath);

        emit(state.copyWith(
          loading: false,
          imagePaths: images,
        ));
      } else {
        emit(state.copyWith(loading: false));
      }
    } catch (e) {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> checkNikExistence(BuildContext context) async {
    final nik = state.nik.trim();

    // Cek NIK kosong
    if (nik.isEmpty) {
      ShowSnackbar.snackbar(
        isSuccess: false,
        context,
        "NIK tidak boleh kosong",
      );
      return;
    }

    emit(state.copyWith(loading: true, error: null));
    try {
      final isRegistered = await repo.checkNik(nik);
      emit(state.copyWith(loading: false));

      if (isRegistered) {
        ShowSnackbar.snackbar(
          isSuccess: false,
          context,
          "Saat ini KTP Anda sudah terdaftar, silakan login",
        );
      } else {
        ShowSnackbar.snackbar(
          isSuccess: true,
          context,
          "KTP Anda telah terverifikasi, silakan lanjutkan pendaftaran akun.",
        );
        final extractKtp = ExtrackKtpModel(
          fullname: state.nama,
          nik: nik,
          address: state.alamat,
          birthPlaceAndDate: state.ttl,
          gender: state.jenisKelamin,
          bloodType: state.golDarah,
          administrativeVillage: state.kelDesa,
          villageUnit: state.rtRw,
          subDistrict: state.kecamatan,
          religion: state.agama,
          maritalStatus: state.statusPerkawinan,
          occupation: state.pekerjaan,
          citizenship: state.kewarganegaraan,
          validUntil: state.berlakuHingga,
        );
        final userGoogle = UserGoogleModel(
          action: state.userGoogleModel?.action,
          avatar: state.userGoogleModel?.avatar,
          email: state.userGoogleModel?.email,
          name: state.userGoogleModel?.name,
          oauthId: state.userGoogleModel?.oauthId,
        );

        final extra = RegisterAkunExtra(
          extrackKtp: extractKtp,
          userGoogle: userGoogle,
        );
        RegisterAkunRoute($extra: extra).push(context);

        print("CEK${extra.extrackKtp}");
        print("CEK${extra.userGoogle}");
      }
    } catch (e, stack) {
      debugPrint('Gagal check NIK: $e');
      debugPrint('Stack trace: $stack');

      emit(state.copyWith(loading: false, error: e.toString()));

      ShowSnackbar.snackbar(
        isSuccess: false,
        context,
        "Gagal: $e",
      );
    }
  }
}
