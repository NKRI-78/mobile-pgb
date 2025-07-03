import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:upgrader/upgrader.dart';
import 'snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../modules/checkout/cubit/checkout_cubit.dart';

class UpgraderMessagesIndonesian extends UpgraderMessages {
  UpgraderMessagesIndonesian() : super(code: 'id');

  @override
  String get title => 'Pembaruan Tersedia';

  @override
  String get body =>
      'Versi terbaru dari {{appName}} tersedia! Versi terbaru saat ini adalah {{currentAppStoreVersion}} - versi anda saat ini adalah {{currentInstalledVersion}}.';

  @override
  String get prompt => 'Mau perbarui sekarang?';

  @override
  String get releaseNotes => 'Catatan Rilis';

  @override
  String get buttonTitleUpdate => 'Perbarui Sekarang';

  @override
  String get buttonTitleIgnore => 'Abaikan';

  @override
  String get buttonTitleLater => 'Nanti Saja';
}

class Helper {
  static Future<void> openLink(
      {required String url, required BuildContext context}) async {
    final uri = Uri.parse(url);

    // if(!url.contains(RegExp(r'^(http|https)://'))){
    //   ShowSnackbar.snackbar(context, "Kata Sandi minimal 8 character", '',
    //       errorColor);
    // }

    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  static double convertGramsToKg(double grams) {
    return grams / 1000;
  }

  static Future<bool> requestStoragePermission() async {
    if (await Permission.storage.isGranted) return true;

    var status = await Permission.storage.request();
    return status.isGranted;
  }

  static String getEstimatedDateRange(String etdFrom, String etdThru) {
    final now = DateTime.now();

    // Deteksi jika isinya mengandung "hour" atau "jam"
    final isHours = etdFrom.toLowerCase().contains('jam') ||
        etdFrom.toLowerCase().contains('hour') ||
        etdThru.toLowerCase().contains('jam') ||
        etdThru.toLowerCase().contains('hour');

    // Kalau format jam
    if (isHours) {
      // Ambil angka dari etdFrom dan etdThru
      final fromMatch = RegExp(r'\d+').firstMatch(etdFrom);
      final thruMatch = RegExp(r'\d+').firstMatch(etdThru);

      final fromHours =
          fromMatch != null ? int.tryParse(fromMatch.group(0)!) ?? 0 : 0;
      final thruHours =
          thruMatch != null ? int.tryParse(thruMatch.group(0)!) ?? 0 : 0;

      if (fromHours == thruHours || thruHours == 0) {
        return "dalam $fromHours jam";
      } else {
        return "dalam $fromHours - $thruHours jam";
      }
    }

    // Format normal (hari)
    final fromDays = int.tryParse(etdFrom) ?? 0;
    final thruDays = int.tryParse(etdThru) ?? 0;

    final fromDate = now.add(Duration(days: fromDays));
    final thruDate = now.add(Duration(days: thruDays));

    final fromFormatted = DateFormat("d MMMM", "id_ID").format(fromDate);
    final thruFormatted = DateFormat("d MMMM", "id_ID").format(thruDate);

    final fromOnlyDay = int.tryParse(DateFormat("d", "id_ID").format(fromDate));
    final nowDate = int.tryParse(DateFormat("d", "id_ID").format(now));

    if ((fromOnlyDay ?? 0) - (nowDate ?? 0) == 0) {
      return "hari ini";
    }

    if ((fromOnlyDay ?? 0) - (nowDate ?? 0) == 1 && fromDays == thruDays) {
      return "besok";
    }

    if ((fromOnlyDay ?? 0) - (nowDate ?? 0) == 1) {
      return "besok - $thruFormatted";
    }

    return "$fromFormatted - $thruFormatted";
  }

  static String getCourierLogoUrl(
      Map<String, dynamic> selectedShipping, CheckoutState state) {
    final selectedCode = selectedShipping['code'] ?? '';
    final selectedService = selectedShipping['service'] ?? '';

    for (final item in state.cost) {
      if (item.code == selectedCode && item.service == selectedService) {
        return item.logoUrl ?? '';
      }
    }

    for (final item in state.costV3) {
      if (item.courierCode == selectedCode &&
          item.serviceType == selectedService) {
        return item.logoUrl ?? '';
      }
    }

    return '';
  }

  String getCourierServiceDisplay(Map<String, dynamic> shipping) {
    final courierCode =
        (shipping['courier_code'] ?? '').toString().toLowerCase();
    final type = (shipping['type'] ?? '').toString().toLowerCase();

    if (courierCode == 'gojek' ||
        courierCode == 'grab' ||
        type == 'instant' ||
        type == 'same_day') {
      return shipping['courier_service_name'] ?? '-';
    } else {
      return shipping['service_replaced'] ?? '-';
    }
  }

  static Future<void> sendEmail({
    required String toEmail,
    String? subject,
    String? body,
  }) async {
    final encodedSubject = Uri.encodeComponent(subject ?? '');
    final encodedBody = Uri.encodeComponent(body ?? '');

    final emailUri =
        Uri.parse("mailto:$toEmail?subject=$encodedSubject&body=$encodedBody");

    if (!await launchUrl(emailUri)) {
      throw Exception('Could not launch email client');
    }
  }

  static Future<void> openFixedWhatsApp(BuildContext context,
      {String? message}) async {
    const fixedPhone = '081228344065';
    final cleanedPhone = fixedPhone.startsWith('0')
        ? '62${fixedPhone.substring(1)}'
        : fixedPhone;

    final encodedMessage = Uri.encodeComponent(
      message ?? "Halo DPP Gema Bangsa, saya ingin bertanya...",
    );

    final url = Platform.isIOS
        ? "whatsapp://send?phone=$cleanedPhone&text=$encodedMessage"
        : "https://wa.me/$cleanedPhone?text=$encodedMessage";

    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ShowSnackbar.snackbar(
          context,
          'Nomor ini tidak bisa dihubungi',
          isSuccess: false,
        );
      }
    }
  }

  // Future<void> saveToGalleryWithAlbum() async {
  //   // 1. Minta izin
  //   final permission = await Permission.photos.request(); // iOS
  //   final storagePermission = await Permission.storage.request(); // Android

  //   if (!permission.isGranted && !storagePermission.isGranted) {
  //     print("Izin tidak diberikan");
  //     return;
  //   }

  //   // 2. Load gambar dari asset
  //   final byteData = await rootBundle.load('assets/sample.png');
  //   final bytes = byteData.buffer.asUint8List();

  //   // 3. Simpan ke galeri dengan nama album custom
  //   final result = await SaveGallery.saveImage(
  //     bytes,
  //     albumName: "MyAwesomeAlbum", // Folder/album yang kamu mau
  //   );

  //   print(result.success
  //       ? "Berhasil disimpan ke galeri!"
  //       : "Gagal menyimpan: ${result.errorMessage}");
  // }

  // static Future<void> update(BuildContext context) async {
  //   NewVersionPlus newVersion = NewVersionPlus(androidId: 'com.inovatif78.mhs_mobile', iOSId: 'com.inovatif78.mhs-mobile');
  //   final status = await newVersion.getVersionStatus();
  //   debugPrint("Store Link : ${status?.appStoreLink ?? ""}");
  //   final url = Platform.isAndroid
  //       ? status?.appStoreLink ?? ""
  //       : "https://apps.apple.com/id/app/mhs/id6723889295";
  //   final uri = Uri.parse(url);

  //   if(!url.contains(RegExp(r'^(http|https)://'))){
  //     ShowSnackbar.snackbar(context, "Ada kesalahan dengan update aplikasi, silahkan update melalui Playstore atau Appstore", '',
  //         errorColor);
  //   }

  //   if (!await launchUrl(uri)) {
  //     throw Exception('Could not launch $uri');
  //   }
  // }
}
