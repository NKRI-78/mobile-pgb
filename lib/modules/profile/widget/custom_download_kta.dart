part of '../view/profile_page.dart';

class CustomDownloadKta extends StatelessWidget {
  final PageController controller;
  final String noKta,
      nama,
      tempatTglLahir,
      agama,
      alamat,
      rtRw,
      kelurahan,
      kecamatan,
      fotoPath,
      createAt;
  final GlobalKey ktaFrontKey;

  const CustomDownloadKta({
    super.key,
    required this.controller,
    required this.noKta,
    required this.nama,
    required this.tempatTglLahir,
    required this.agama,
    required this.alamat,
    required this.rtRw,
    required this.kelurahan,
    required this.kecamatan,
    required this.fotoPath,
    required this.createAt,
    required this.ktaFrontKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryColor,
          foregroundColor: AppColors.blackColor,
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () async {
          final result = await Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PreviewKtaPage(
              noKta: noKta,
              nama: nama,
              tempatTglLahir: tempatTglLahir,
              agama: agama,
              alamat: alamat,
              rtRw: rtRw,
              kelurahan: kelurahan,
              kecamatan: kecamatan,
              fotoPath: fotoPath,
              createAt: createAt,
            ),
          ));

          if (result == true && context.mounted) {
            ShowSnackbar.snackbar(context, "KTA berhasil disimpan ke galeri",
                isSuccess: true);
          }
        },
        icon: const Icon(Icons.download_outlined,
            size: 20, color: AppColors.whiteColor),
        label: Text('Download KTA',
            style: AppTextStyles.textStyleNormal
                .copyWith(color: AppColors.whiteColor)),
      ),
    );
  }
}
