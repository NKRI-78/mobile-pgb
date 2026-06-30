import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../misc/colors.dart';

import '../../../misc/text_style.dart';

class KtpInstructionView extends StatelessWidget {
  const KtpInstructionView({
    super.key,
    required this.isLandscape,
    required this.onStart,
  });

  final bool isLandscape;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final isShortScreen = MediaQuery.of(context).size.height < 500;
    final sectionSpacing = isShortScreen ? 18.0 : 32.0;
    final itemSpacing = isShortScreen ? 10.0 : 16.0;
    final buttonSpacing = isShortScreen ? 20.0 : 36.0;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: isLandscape ? 120 : 150,
                    height: isLandscape ? 120 : 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.075),
                      shape: BoxShape.circle,
                    ),
                    child: Lottie.asset(
                      'assets/animations/rotate.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: isLandscape ? 20 : sectionSpacing,
                  ),
                  Text(
                    "Persiapan Pengambilan Foto KTP",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.textStyleBold.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    height: isLandscape ? 10 : itemSpacing,
                  ),
                  Text(
                    isLandscape
                        ? "Perangkat sudah siap. Tekan tombol di bawah untuk membuka kamera."
                        : "Sebelum membuka kamera, pastikan perangkat sudah siap.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.textStyleNormal.copyWith(
                      color: Colors.white54,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: -1,
                          child: child,
                        ),
                      );
                    },
                    child: isLandscape
                        ? Column(
                            key: const ValueKey('landscape'),
                            children: [
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.greenAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Perangkat siap digunakan",
                                    style: AppTextStyles.textStyleBold.copyWith(
                                      color: Colors.greenAccent,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: FilledButton(
                                  onPressed: onStart,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.secondaryColor,
                                    foregroundColor: AppColors.whiteColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text("Buka Kamera"),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            key: const ValueKey('portrait'),
                            children: [
                              const SizedBox(height: 20),
                              const _InstructionItem(
                                icon: Icons.lock_open,
                                text: "Matikan Rotation Lock",
                              ),
                              const _InstructionItem(
                                icon: Icons.screen_rotation_alt,
                                text: "Putar perangkat ke posisi Landscape.",
                              ),
                              const _InstructionItem(
                                icon: Icons.credit_card,
                                text:
                                    "Siapkan KTP asli dan pastikan pencahayaan cukup.",
                              ),
                              SizedBox(height: buttonSpacing),
                              Text(
                                "Putar perangkat ke posisi Landscape untuk melanjutkan.",
                                textAlign: TextAlign.center,
                                style: AppTextStyles.textStyleNormal.copyWith(
                                  color: Colors.orange,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InstructionItem extends StatelessWidget {
  const _InstructionItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.textStyleNormal.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
