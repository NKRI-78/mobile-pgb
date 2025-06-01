part of '../view/profile_page.dart';

class CustomDownloadKta extends StatelessWidget {
  const CustomDownloadKta({super.key, required this.controller});
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondaryColor,
            foregroundColor: AppColors.blackColor,
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () async {
            // Simpan halaman depan
            await saveKta(_ktaFrontKey, 'kta_front', context);

            // Pindah ke halaman belakang
            controller.jumpToPage(1); // atau animateToPage untuk animasi
            await Future.delayed(
                const Duration(milliseconds: 300)); // tunggu render

            // Simpan halaman belakang
            await saveKta(_ktaBackKey, 'kta_back', context);

            // (Opsional) kembali ke halaman depan
            controller.jumpToPage(0);
          },
          icon: const Icon(Icons.download_outlined,
              size: 20, color: AppColors.whiteColor),
          label: Text('Download KTA',
              style: AppTextStyles.textStyleNormal
                  .copyWith(color: AppColors.whiteColor)),
        ),
      ),
    );
  }

  Future<void> saveKta(
      GlobalKey key, String filename, BuildContext context) async {
    try {
      // Tunggu hingga frame selesai dirender
      await Future.delayed(
          Duration(milliseconds: 100)); // opsional delay tambahan

      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;

      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 20));
        return saveKta(key, filename, context); // coba ulangi sampai siap
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/$filename.png';
      final file = await File(filePath).writeAsBytes(pngBytes);

      final success =
          await GallerySaver.saveImage(file.path, albumName: 'KTA_PGM');

      if (success == true) {
        ShowSnackbar.snackbar(context, "KTA berhasil disimpan ke galeri",
            isSuccess: true);
      } else {
        ShowSnackbar.snackbar(context, "Gagal menyimpan KTA", isSuccess: false);
      }
    } catch (e) {
      debugPrint('Error saving KTA: $e');
      ShowSnackbar.snackbar(context, "Terjadi kesalahan saat menyimpan",
          isSuccess: false);
    }
  }
}
