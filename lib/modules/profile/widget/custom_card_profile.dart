part of '../view/profile_page.dart';

final GlobalKey _ktaKey = GlobalKey();

class CustomCardProfile extends StatelessWidget {
  final String noKta;
  final String nama;
  final String tempatTglLahir;
  final String agama;
  final String alamat;
  final String fotoPath;

  const CustomCardProfile({
    super.key,
    required this.noKta,
    required this.nama,
    required this.tempatTglLahir,
    required this.agama,
    required this.alamat,
    required this.fotoPath,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _ktaKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 350;
          final imageWidth = isSmall ? 65.0 : 70.0;
          final imageHeight = isSmall ? 80.0 : 90.0;
          return Card(
            color: Colors.transparent,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAlias,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/card.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: imageWidth,
                          height: imageHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: fotoPath.startsWith('http')
                                  ? NetworkImage(fotoPath)
                                  : AssetImage(fotoPath) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InfoLine(
                                  label: 'No. KTA               ',
                                  value: noKta),
                              InfoLine(
                                  label: 'Nama                   ',
                                  value: nama),
                              InfoLine(
                                  label: 'Tempat/Tgl Lahir',
                                  value: tempatTglLahir),
                              InfoLine(
                                  label: 'Agama                 ',
                                  value: agama),
                              InfoLine(
                                  label: 'Alamat                 ',
                                  value: alamat),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: BarcodeWidget(
                      barcode: Barcode.qrCode(),
                      data: noKta,
                      width: 60,
                      height: 60,
                      drawText: false,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const InfoLine({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            '$label :',
            style: AppTextStyles.textStyleNormal.copyWith(
              color: AppColors.whiteColor,
              fontSize: 7,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.textStyleNormal.copyWith(
              color: AppColors.whiteColor,
              fontSize: 7,
            ),
          ),
        ),
      ],
    );
  }
}
