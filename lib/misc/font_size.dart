import 'package:flutter/material.dart';

double responsiveFont(
  BuildContext context,
  double fontSize,
) {
  final height = MediaQuery.of(context).size.height;

  final scale = (height / 430).clamp(0.85, 1.20);

  return fontSize * scale;
}
