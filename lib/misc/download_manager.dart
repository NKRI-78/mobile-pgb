import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'snackbar.dart';
import 'package:path/path.dart' as p;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import 'colors.dart';
import 'file_storage.dart';

class DownloadHelper {
  static Future<void> downloadDoc({
    required BuildContext context,
    required String url,
  }) async {
    // ✅ Deteksi apakah file lokal (dari kamera/galeri)
    final bool isLocalFile = url.startsWith('/') || url.startsWith('file://');

    if (isLocalFile) {
      // ✅ Simpan file lokal ke galeri
      final filePath = url.startsWith('file://') ? Uri.parse(url).path : url;

      final pr = ProgressDialog(context: context);
      pr.show(
        backgroundColor: AppColors.whiteColor,
        msgTextAlign: TextAlign.start,
        max: 100,
        msgColor: AppColors.secondaryColor,
        msg: "Menyimpan ke galeri...",
        progressBgColor: AppColors.secondaryColor,
        progressValueColor: AppColors.whiteColor,
      );

      try {
        final success = await GallerySaver.saveVideo(filePath);
        pr.close();

        if (success == true && context.mounted) {
          ShowSnackbar.snackbar(
            context,
            "Video berhasil disimpan ke galeri",
            isSuccess: true,
          );
        } else {
          ShowSnackbar.snackbar(
            context,
            "Gagal menyimpan video ke galeri",
            isSuccess: false,
          );
        }
      } catch (e) {
        pr.close();
        ShowSnackbar.snackbar(
          context,
          "Error saat menyimpan ke galeri: $e",
          isSuccess: false,
        );
      }
      return;
    }

    // ✅ Jika file dari internet (URL valid)
    int total = 0;
    int received = 0;
    final List<int> bytes = [];

    String originName = p.basename(url.split('/').last).split('.').first;
    String ext = p.basename(url).toString().split('.').last;
    String filename =
        "${DateFormat('yyyydd').format(DateTime.now())}-$originName.$ext";

    bool isExistFile = await FileStorage.checkFileExist(filename);

    if (!isExistFile && context.mounted) {
      ProgressDialog pr = ProgressDialog(context: context);
      pr.show(
        backgroundColor: AppColors.whiteColor,
        msgTextAlign: TextAlign.start,
        max: 100,
        msgColor: AppColors.secondaryColor,
        msg: "Please wait...",
        progressBgColor: AppColors.secondaryColor,
        progressValueColor: AppColors.whiteColor,
      );

      try {
        final request = http.Request('GET', Uri.parse(url));
        final response = await http.Client().send(request);
        total = response.contentLength ?? 0;

        if (total == 0) {
          pr.close();
          ShowSnackbar.snackbar(context, "Ukuran file tidak diketahui",
              isSuccess: false);
          return;
        }

        response.stream.listen(
          (value) {
            bytes.addAll(value);
            received += value.length;
            int progress = ((received / total) * 100).toInt();
            pr.update(value: progress, msg: 'Mengunduh file...');
          },
          onDone: () async {
            pr.close();
            Uint8List uint8List = Uint8List.fromList(bytes);

            await FileStorage.saveFileUrl(uint8List, filename);
            if (context.mounted) {
              await FileStorage.getFileFromAsset(filename, context, false);
            }
          },
          onError: (e) {
            pr.close();
            ShowSnackbar.snackbar(context, "Download gagal: $e",
                isSuccess: false);
          },
          cancelOnError: true,
        );
      } catch (e) {
        pr.close();
        ShowSnackbar.snackbar(context, "Gagal mengunduh file: $e",
            isSuccess: false);
      }
    } else {
      if (context.mounted) {
        await FileStorage.getFileFromAsset(filename, context, isExistFile);
      }
    }
  }

  static Future<void> downloadQrFromUrl({
    required BuildContext context,
    required String url,
  }) async {
    try {
      ProgressDialog pr = ProgressDialog(context: context);
      pr.show(msg: "Mengunduh QR...", max: 100);

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final pngBytes = response.bodyBytes;
        final filename =
            "qr-${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.png";

        await FileStorage.saveFileUrl(pngBytes, filename);

        pr.close();
        ShowSnackbar.snackbar(context, "QR berhasil disimpan ke Galeri",
            isSuccess: true);
      } else {
        pr.close();
        ShowSnackbar.snackbar(context, "Gagal mengunduh QR", isSuccess: false);
      }
    } catch (e) {
      ShowSnackbar.snackbar(context, "Error: $e", isSuccess: false);
    }
  }
}
