import 'package:flutter/material.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';

class CustomName extends StatelessWidget {
  const CustomName({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hello Mira',
                style: AppTextStyles.textStyleBold,
              ),
              Text(
                'Saldo e-Wallet',
                style: AppTextStyles.textStyleNormal.copyWith(
                  color: AppColors.greyColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Partai Gema Bangsa',
                style: AppTextStyles.textStyleNormal.copyWith(
                  color: AppColors.greyColor,
                ),
              ),
              Text(
                'Rp. 150.000',
                style: AppTextStyles.textStyleNormal.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
