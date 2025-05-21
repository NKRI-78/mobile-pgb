import 'package:flutter/material.dart';

import '../../../../misc/colors.dart';
import '../../../../misc/text_style.dart';

class CustomCardMedia extends StatelessWidget {
  final String label;
  final String iconAssetPath;
  final VoidCallback onTap;

  const CustomCardMedia({
    super.key,
    required this.label,
    required this.iconAssetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: Colors.white.withValues(alpha: 0.2),
        highlightColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 150,
              height: 100,
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(3, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.textStyleBold.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.6),
                      blurRadius: 8,
                      offset: const Offset(3, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    iconAssetPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
