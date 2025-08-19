import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../misc/colors.dart';
import '../../../misc/register_akun_extra.dart';
import '../../../misc/text_style.dart';
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
      print('Path Gambar KTP: $imagePath');

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
        kabupaten: response['regency_city'] ?? '',
        provinsi: response['province'] ?? '',
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
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) {
            return Center(
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.secondaryColor,
                            Color(0xFF005FA3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 8,
                            offset: const Offset(3, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            "Konfirmasi Data",
                            style: AppTextStyles.textStyleNormal.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Apakah data yang Anda masukkan sudah benar?",
                            style: AppTextStyles.textStyleNormal.copyWith(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text(
                                    'Periksa Lagi',
                                    style:
                                        AppTextStyles.textStyleNormal.copyWith(
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.redColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text(
                                    "Ya, Benar",
                                    style:
                                        AppTextStyles.textStyleNormal.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: -50,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(2, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.redColor,
                          size: 60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        // Jika user batal → stop di sini
        if (confirm != true) return;
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
          regencyCity: state.kabupaten,
          province: state.provinsi,
          indentityCardUrl: state.ktpImagePath,
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

        print('===== Extract KTP =====');
        print('avatarLink: ${extractKtp.avatarLink}');
        print('KTP: ${extractKtp.indentityCardUrl}');
        print('fullname: ${extractKtp.fullname}');
        print('nik: ${extractKtp.nik}');
        print('address: ${extractKtp.address}');
        print('birthPlaceAndDate: ${extractKtp.birthPlaceAndDate}');
        print('gender: ${extractKtp.gender}');
        print('bloodType: ${extractKtp.bloodType}');
        print('administrativeVillage: ${extractKtp.administrativeVillage}');
        print('villageUnit: ${extractKtp.villageUnit}');
        print('subDistrict: ${extractKtp.subDistrict}');
        print('religion: ${extractKtp.religion}');
        print('maritalStatus: ${extractKtp.maritalStatus}');
        print('occupation: ${extractKtp.occupation}');
        print('citizenship: ${extractKtp.citizenship}');
        print('validUntil: ${extractKtp.validUntil}');
        print('regencyCity: ${extractKtp.regencyCity}');
        print('province: ${extractKtp.province}');

        print('===== User Google =====');
        print('action: ${userGoogle.action}');
        print('avatar: ${userGoogle.avatar}');
        print('email: ${userGoogle.email}');
        print('name: ${userGoogle.name}');
        print('oauthId: ${userGoogle.oauthId}');

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
