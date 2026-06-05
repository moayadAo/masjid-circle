import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle _baseStyle({
    double? size,
    FontWeight? weight,
    Color? color,
    String? family,
  }) {
    return TextStyle(
      fontFamily: family ?? 'IBM Plex Sans Arabic',
      fontSize: size,
      fontWeight: weight,
      color: color ?? const Color(0xFF1B1C1B),
    );
  }

  static TextStyle headlineLg(BuildContext context) =>
      _baseStyle(size: 32, weight: FontWeight.w600);
  static TextStyle headlineMd(BuildContext context) =>
      _baseStyle(size: 24, weight: FontWeight.w500);
  static TextStyle bodyLg(BuildContext context) =>
      _baseStyle(size: 18, weight: FontWeight.w400);
  static TextStyle bodyMd(BuildContext context) =>
      _baseStyle(size: 16, weight: FontWeight.w400);
  static TextStyle labelLg(
    BuildContext context,
    Color? color,
    double? fontSize,
  ) => _baseStyle(size: fontSize ?? 14, weight: FontWeight.w600, color: color);

  static TextStyle quranText(BuildContext context) => _baseStyle(
    family: 'Amiri',
    size: 28,
    weight: FontWeight.w400,
    color: const Color(0xFF1B1C1B),
  );
}
