part of '../view/profile_page.dart';

class CustomDownloadKta extends StatelessWidget {
  const CustomDownloadKta({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white70,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            try {
              // Ambil widget dari RepaintBoundary
              final RenderRepaintBoundary boundary = _ktaKey.currentContext!
                  .findRenderObject() as RenderRepaintBoundary;
              final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
              final byteData =
                  await image.toByteData(format: ui.ImageByteFormat.png);
              final pngBytes = byteData!.buffer.asUint8List();

              // Simpan sementara
              final tempDir = await getTemporaryDirectory();
              final filePath = '${tempDir.path}/kta_pgm.png';
              final file = await File(filePath).writeAsBytes(pngBytes);

              // Simpan ke galeri
              final success =
                  await GallerySaver.saveImage(file.path, albumName: 'KTA_PGM');

              if (success == true) {
                ShowSnackbar.snackbar(
                    context, "KTA berhasil disimpan ke galeri",
                    isSuccess: true);
              } else {
                ShowSnackbar.snackbar(context, "Gagal menyimpan KTA",
                    isSuccess: false);
              }
            } catch (e) {
              debugPrint('Error saving image: $e');
              ShowSnackbar.snackbar(context, "Terjadi kesalahan saat menyimpan",
                  isSuccess: false);
            }
          },
          icon: Icon(
            Icons.download_outlined,
            size: 20,
            color: AppColors.blackColor,
          ),
          label: Text('Download KTA', style: AppTextStyles.textStyleNormal),
        ),
      ),
    );
  }
}
