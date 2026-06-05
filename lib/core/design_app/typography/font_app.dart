// font_app.dart
import 'package:flutter/material.dart';

class FontApp {
  /// English
  /// - Android: Roboto (default material font)
  /// - iOS: SF Pro (optional if you add it in assets)
  static const String fontFamilyEnglishAndroid = 'Roboto';
  static const String fontFamilyEnglishIOS = 'SF Pro';

  /// Arabic (as per design: SF Arabic / Noto Sans Arabic)
  /// Here we use Noto Sans Arabic.
  //static const String fontFamilyArabic = 'NotoSansArabic';
  static const String fontFamilyArabic = 'NotoSansArabic';
}

class FontWeightApp {
  static const bold = FontWeight.w700;
  static const semiBold = FontWeight.w600;
  static const medium = FontWeight.w500;
  static const regular = FontWeight.w400;
  static const light = FontWeight.w300;
}

class FontSize {
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s13 = 13.0;
  static const double s14 = 14.0;
  static const double s15 = 15.0;
  static const double s16 = 16.0;
  static const double s17 = 17.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
  static const double s22 = 22.0;
  static const double s24 = 24.0;
  static const double s26 = 26.0;
  static const double s28 = 28.0;
  static const double s30 = 30.0;
  static const double s32 = 32.0;
  static const double s36 = 36.0;
  static const double s40 = 40.0;
}
