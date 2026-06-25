import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../misc/colors.dart';
import '../../../misc/injections.dart';
import '../../../misc/register_akun_extra.dart';
import '../../../misc/snackbar.dart';
import '../../../misc/text_style.dart';
import '../../../repositories/auth_repository/auth_repository.dart';
import '../../../router/builder.dart';
import '../../app/models/user_google_model.dart';
import '../../register_akun/model/extrack_ktp_model.dart';
import '../helper/ktp_capture_analyzer.dart';

part 'register_ktp_state.dart';

class RegisterKtpCubit extends Cubit<RegisterKtpState> {
  RegisterKtpCubit() : super(const RegisterKtpState());

  AuthRepository repo = getIt<AuthRepository>();

  void copyState({required RegisterKtpState newState}) {
    emit(newState);
  }

  void reset() {
    emit(const RegisterKtpState());
  }

  void init({UserGoogleModel? userGoogle}) {
    emit(state.copyWith(userGoogleModel: userGoogle));
  }

  Future<void> uploadKtpImage(String imagePath) async {
    emit(state.copyWith(
      loading: true,
      error: null,
      validationMessage: null,
    ));

    try {
      final uploadPath = await KtpCaptureAnalyzer.rotateForUpload(
        imagePath,
      );

      debugPrint('ORIGINAL PATH: $imagePath');
      debugPrint('UPLOAD PATH  : $uploadPath');

      debugPrint('======================');
      debugPrint('UPLOADING TO OCR');
      debugPrint('FILE: $uploadPath');
      debugPrint('======================');
      final result = await repo.uploadKtpForOcr(File(uploadPath));
      debugPrint('OCR RESPONSE: $result');
      debugPrint('======================');
      debugPrint('OCR RESPONSE RAW');
      debugPrint(result.toString());
      debugPrint('======================');

      final response = result['data']['response'];
      debugPrint('Path Gambar KTP: $uploadPath');

      emit(state.copyWith(
        loading: false,
        ktpImagePath: uploadPath,
        imagePaths: [uploadPath],
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
      debugPrint('OCR ERROR: $e');

      String errorMessage = e.toString();

      if (errorMessage.contains('Gambar bukan halaman identitas KTP')) {
        errorMessage =
            'Foto KTP belum dapat diproses. Mohon ambil ulang foto dengan posisi yang lebih jelas.';
      }

      emit(state.copyWith(
        loading: false,
        error: errorMessage,
      ));
    }
  }

  Future<void> processCapturedKtp(String imagePath) async {
    // Foto mentah dari kamera tetap dikirim ke backend.
    // Backend yang melakukan OCR dan mengembalikan hasil ekstraksinya.
    await uploadKtpImage(imagePath);
  }

  void setValidationFailure(String message) {
    emit(state.copyWith(
      loading: false,
      validationMessage: message,
    ));
  }

  void clearValidationMessage() {
    emit(state.copyWith(validationMessage: null, error: null));
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

        debugPrint('''
===== Extract KTP =====
avatarLink : ${extractKtp.avatarLink}
ktp        : ${extractKtp.indentityCardUrl}
fullname   : ${extractKtp.fullname}
nik        : ${extractKtp.nik}
address    : ${extractKtp.address}
ttl        : ${extractKtp.birthPlaceAndDate}
gender     : ${extractKtp.gender}
bloodType  : ${extractKtp.bloodType}
village    : ${extractKtp.administrativeVillage}
rtRw       : ${extractKtp.villageUnit}
district   : ${extractKtp.subDistrict}
religion   : ${extractKtp.religion}
marital    : ${extractKtp.maritalStatus}
job        : ${extractKtp.occupation}
country    : ${extractKtp.citizenship}
expired    : ${extractKtp.validUntil}
city       : ${extractKtp.regencyCity}
province   : ${extractKtp.province}
=======================
''');

        debugPrint('''
===== User Google =====
action  : ${userGoogle.action}
avatar  : ${userGoogle.avatar}
email   : ${userGoogle.email}
name    : ${userGoogle.name}
oauthId : ${userGoogle.oauthId}
=======================
''');
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
