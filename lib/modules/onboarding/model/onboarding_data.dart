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
        'Satu Aplikasi, Banyak Kemudahan untuk Kader dan Pengurus Partai Kelola kebutuhan pembayaran harian partai dengan cepat, aman, dan efisien - semua dalam satu aplikasi.',
    'image': 'assets/images/onboarding_1.png',
  },
  {
    'title': [
      TextSpan(
        text: 'Fitur ',
        style: AppTextStyles.buttonTextBlue,
      ),
      TextSpan(
        text: 'Forum',
        style: AppTextStyles.buttonTextBlue1,
      ),
    ],
    'description':
        'Fitur Forum,  memungkinkan seluruh Anggota di Partai Gema Bangsa untuk berkomunikasi, berdiskusi, dan berbagi informasi secara langsung melalui aplikasi.',
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
        'Fitur Panic Button dirancang untuk memberikan keamanan ekstra bagi anggota dalam situasi darurat. Dengan sekali tekan, Anggota dapat langsung mengirimkan sinyal bantuan ke Anggota lainnya secara real time.',
    'image': 'assets/images/onboarding_3.png',
  },
];
