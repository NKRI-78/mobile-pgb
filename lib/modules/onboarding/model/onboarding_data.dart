import 'package:flutter/material.dart';

import '../../../misc/text_style.dart';

final List<Map<String, dynamic>> onboardingContent = [
  {
    'title': [
      TextSpan(
        text: 'Payment ',
        style: AppTextStyles.buttonTextBlue,
      ),
      TextSpan(
        text: 'Point Online Bank',
        style: AppTextStyles.buttonTextBlue1,
      ),
    ],
    'description':
        'Semua pembayaran partai kini lebih mudah! Dengan fitur PPOB, kamu bisa beli pulsa, dan lainnya langsung dari aplikasi - praktis, cepat, dan terpercaya.',
    'image': 'assets/images/onboarding_1.png',
  },
  {
    'title': [
      TextSpan(
        text: 'Fitur ',
        style: AppTextStyles.buttonTextBlue,
      ),
      TextSpan(
        text: 'Interaksi',
        style: AppTextStyles.buttonTextBlue1,
      ),
    ],
    'description':
        'Fitur Interaksi, memudahkan seluruh Anggota di Partai Gema Bangsa untuk berkomunikasi, berdiskusi, dan berbagi informasi secara langsung melalui aplikasi.',
    'image': 'assets/images/onboarding_2.png',
  },
  {
    'title': [
      TextSpan(
        text: 'Fitur ',
        style: AppTextStyles.buttonTextBlue,
      ),
      TextSpan(
        text: 'Panic Button',
        style: AppTextStyles.buttonTextBlue1,
      ),
    ],
    'description':
        'Fitur panic button dapat memudahkan anggota dalam memberikan informasi situasi darurat dengan sekali tekan, Anggota dapat langsung mengirimkan sinyal bantuan ke Anggota lainnya secara real time.',
    'image': 'assets/images/onboarding_3.png',
  },
];
