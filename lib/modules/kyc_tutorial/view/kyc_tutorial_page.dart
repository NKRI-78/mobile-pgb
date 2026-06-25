import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../misc/colors.dart';
import '../../../misc/register_akun_extra.dart';
import '../../../misc/text_style.dart';
import '../../../router/builder.dart';
import '../../../widgets/button/custom_button.dart';
import '../../app/models/user_google_model.dart';

class KycTutorialPage extends StatelessWidget {
  const KycTutorialPage({
    super.key,
    this.userGoogle,
  });

  final UserGoogleModel? userGoogle;

  @override
  Widget build(BuildContext context) {
    return KycTutorialView(
      userGoogle: userGoogle,
    );
  }
}

class KycTutorialView extends StatefulWidget {
  const KycTutorialView({
    super.key,
    this.userGoogle,
  });

  final UserGoogleModel? userGoogle;

  @override
  State<KycTutorialView> createState() => _KycTutorialViewState();
}

class _KycTutorialViewState extends State<KycTutorialView>
    with WidgetsBindingObserver {
  bool _isPermissionDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint('APP STATE: $state');
    if (state == AppLifecycleState.resumed && _isPermissionDialogOpen) {
      final status = await Permission.camera.status;

      debugPrint('CAMERA STATUS: $status');
      if (status.isGranted && mounted) {
        debugPrint('CAMERA GRANTED');
        _isPermissionDialogOpen = false;

        Navigator.of(context, rootNavigator: true).pop();

        await Future.delayed(const Duration(milliseconds: 100));

        if (!mounted) return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSso = widget.userGoogle != null;

    debugPrint("===== KYC PAGE =====");
    debugPrint("userGoogle = ${widget.userGoogle}");
    debugPrint("SSO = $isSso");

    if (widget.userGoogle != null) {
      debugPrint("EMAIL   = ${widget.userGoogle!.email}");
      debugPrint("NAME    = ${widget.userGoogle!.name}");
      debugPrint("OAUTHID = ${widget.userGoogle!.oauthId}");
    }

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Cara Menggunakan KYC KTP',
          style: AppTextStyles.textStyleBold.copyWith(
            color: AppColors.blackColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.blackColor,
          ),
          onPressed: () async {
            if (widget.userGoogle != null) {
              await GoogleSignIn().signOut();
            }

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        minimum: const EdgeInsets.all(12),
        child: CustomButton(
            backgroundColour: AppColors.secondaryColor,
            textColour: AppColors.whiteColor,
            text: 'Mulai Verifikasi KTP',
            onPressed: () async {
              final status = await Permission.camera.status;

              if (status.isGranted) {
                RegisterKtpRoute(
                  $extra: RegisterAkunExtra(
                    userGoogle: widget.userGoogle,
                  ),
                ).push(context);
                return;
              }

              final result = await Permission.camera.request();

              if (result.isGranted) {
                RegisterKtpRoute(
                  $extra: RegisterAkunExtra(
                    userGoogle: widget.userGoogle,
                  ),
                ).push(context);
              } else if (result.isPermanentlyDenied) {
                showPermissionDialog(context);
              }
            }),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Ikuti 2 langkah berikut untuk memastikan verifikasi berhasil',
                style: AppTextStyles.textStyleBold.copyWith(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Putar HP ke arah kiri dan pastikan posisi sesuai dengan KTP',
                          style: AppTextStyles.textStyleBold.copyWith(
                            fontSize: 14,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/kyc1.jpg',
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          color: AppColors.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Posisikan KTP sesuai dengan letak NIK, Face, dan Biodata',
                          style: AppTextStyles.textStyleBold.copyWith(
                            fontSize: 14,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/images/kyc2.jpg',
                  ),
                  const SizedBox(height: 20),
                  _buildCheckItem(
                    Icons.crop_free,
                    'Pastikan seluruh KTP terlihat jelas di dalam frame',
                  ),
                  _buildCheckItem(
                    Icons.wb_sunny_outlined,
                    'Pastikan pencahayaan cukup dan tidak ada pantulan',
                  ),
                  _buildCheckItem(
                    Icons.phone_android,
                    'Pastikan tangan stabil dan tidak goyang',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.verified,
                    color: AppColors.secondaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Pastikan data pada KTP terlihat jelas dan tidak terpotong. '
                      'Proses verifikasi hanya memakan waktu beberapa detik.',
                      style: AppTextStyles.textStyleNormal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckItem(
    IconData icon,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.secondaryColor,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.textStyleNormal.copyWith(
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showPermissionDialog(BuildContext context) {
    _isPermissionDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          "Izin Kamera Ditolak",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.no_photography,
              size: 60,
              color: AppColors.redColor,
            ),
            const SizedBox(height: 10),
            Text(
              "Aplikasi memerlukan akses kamera untuk melanjutkan. Silakan aktifkan izin kamera di pengaturan.",
              style: AppTextStyles.textStyleNormal,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _isPermissionDialogOpen = false;
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    "Batal",
                    style: AppTextStyles.textStyleNormal.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await openAppSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    "Pengaturan",
                    style: AppTextStyles.textStyleNormal.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).then(
      (_) {
        _isPermissionDialogOpen = false;
      },
    );
  }
}
