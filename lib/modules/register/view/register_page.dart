import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../misc/register_akun_extra.dart';
import '../cubit/register_cubit.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../../../router/builder.dart';
import '../../../widgets/button/custom_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Selamat Datang di',
                        style: AppTextStyles.textStyleBold.copyWith(
                          color: AppColors.whiteColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 50),
                      Image.asset(
                        'assets/images/logo_transparant.png',
                        height: size.height * 0.25,
                      ),
                      SizedBox(height: 80),
                      CustomButton(
                        text: "Login",
                        backgroundColour: AppColors.whiteColor,
                        textColour: AppColors.blackColor,
                        onPressed: () {
                          LoginRoute().go(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: AppColors.greyColor,
                                thickness: 0.5,
                              ),
                            ),
                            SizedBox(width: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Atau',
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  color: AppColors.whiteColor.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            const Expanded(
                              child: Divider(
                                color: AppColors.greyColor,
                                thickness: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        text: "Registrasi",
                        backgroundColour: AppColors.buttonBlueColor,
                        textColour: AppColors.whiteColor,
                        onPressed: () {
                          showKtpInstructionDialog(context);
                        },
                      ),
                      SizedBox(height: 10),
                      CustomButton(
                        leading: Image.asset(
                          'assets/icons/google.png',
                          height: 20,
                          width: 20,
                        ),
                        text: "Sign Up With Google",
                        backgroundColour: AppColors.whiteColor,
                        textColour: AppColors.blackColor,
                        onPressed: () async {
                          final permissionStatus =
                              await Permission.camera.request();

                          if (permissionStatus.isGranted) {
                            context
                                .read<RegisterCubit>()
                                .loginWithGoogle(context);
                          } else if (permissionStatus.isPermanentlyDenied) {
                            showPermissionDialog(context);
                          } else {
                            //
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showPermissionDialog(BuildContext context) {
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
            Icon(Icons.no_photography,
                size: 60, color: AppColors.secondaryColor),
            const SizedBox(height: 10),
            const Text(
              "Aplikasi memerlukan akses kamera untuk melanjutkan. Silakan aktifkan izin kamera di pengaturan.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redColor,
                    ),
                    child: Text(
                      "Batal",
                      style: AppTextStyles.textStyleNormal
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      openAppSettings();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                    ),
                    child: Text(
                      "Pengaturan",
                      style: AppTextStyles.textStyleNormal
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showKtpInstructionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
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
                      Text(
                        'Siapkan KTP Anda',
                        style: AppTextStyles.textStyleBold.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Pastikan KTP terlihat jelas dan diletakkan di tempat terang.\n'
                        'Hindari bayangan atau buram agar proses registrasi berjalan lancar.',
                        style: AppTextStyles.textStyleNormal.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.redColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: Text(
                                'Batal',
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.greenColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                Navigator.of(dialogContext).pop();

                                // ✅ Tambahkan cek permission kamera di sini
                                final permissionStatus =
                                    await Permission.camera.request();

                                if (permissionStatus.isGranted) {
                                  // ➔ lanjut ke halaman RegisterKtpRoute
                                  RegisterKtpRoute($extra: RegisterAkunExtra())
                                      .go(context);
                                } else if (permissionStatus
                                    .isPermanentlyDenied) {
                                  showPermissionDialog(context);
                                } else {
                                  //
                                }
                              },
                              child: Text(
                                'Lanjutkan',
                                style: AppTextStyles.textStyleNormal.copyWith(
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
                  top: -60,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/icons/dialog.png',
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
