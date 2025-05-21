

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
    static Future<void> openLink({required String url, required BuildContext context}) async {
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
