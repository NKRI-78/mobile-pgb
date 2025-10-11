import 'package:flutter/material.dart';
import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';

class MaintenancePages extends StatelessWidget {
  const MaintenancePages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.build_rounded,
                  color: AppColors.secondaryColor,
                  size: 120,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Sedang Dalam Perbaikan",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  "Kami sedang melakukan perbaikan untuk meningkatkan pengalamanmu. "
                  "Silakan coba beberapa saat lagi.",
                  style: AppTextStyles.textStyleNormal
                      .copyWith(color: AppColors.greyColor, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.home,
                    color: AppColors.buttonWhiteColor,
                  ),
                  label: Text(
                    "Kembali Ke Beranda",
                    style: AppTextStyles.textStyleNormal
                        .copyWith(color: AppColors.whiteColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
