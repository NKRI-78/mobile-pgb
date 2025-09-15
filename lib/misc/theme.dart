import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var baseTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Colors.white,
  ),
  appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  )),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);

const String imageDefaultBanner = "assets/images/no_banner.png";
const String imageDefaultUser = "assets/images/no_user.jpg";
const String imageDefaultData = "assets/images/no_data.png";

//Font Size
const double fontSizeOverExtraSmall = 9.0;
const double fontSizeExtraSmall = 10.0;
const double fontSizeSmall = 12.0;
const double fontSizeDefault = 14.0;
const double fontSizeLarge = 16.0;
const double fontSizeExtraLarge = 18.0;
const double fontSizeOverLarge = 20.0;
const double fontSizeTitle = 32.0;
