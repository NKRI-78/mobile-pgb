import 'package:flutter/material.dart';

import 'colors.dart';

class AppTextStyles {
  static TextStyle textStyleBold = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
    fontFamily: 'Inter',
  );
  static TextStyle textStyleNormal = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.blackColor,
    fontFamily: 'Inter',
  );
  static TextStyle buttonTextBlue = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.blueColor,
    fontFamily: 'Inter',
  );
  static TextStyle buttonTextBlue1 = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.tertiaryColor,
    fontFamily: 'Inter',
  );
  static TextStyle buttonTextWhite = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.whiteColor,
    fontFamily: 'Inter',
  );
  AppTextStyles._();
}
