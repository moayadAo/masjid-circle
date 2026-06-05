import 'dart:io';
import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData buildAppTheme() {
  final bool isIOS = Platform.isIOS;

  return ThemeData(
    useMaterial3: true,

    platform: isIOS ? TargetPlatform.iOS : TargetPlatform.android,

    scaffoldBackgroundColor: AppColor.background,
    fontFamily: null,

    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      primary: AppColor.primary,
      onPrimary: AppColor.onPrimary,
      primaryContainer: AppColor.primaryContainer,
      onPrimaryContainer: AppColor.onPrimaryContainer,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,

      contentPadding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: isIOS ? 10 : 12,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isIOS ? 14 : 12),
        borderSide: const BorderSide(color: AppColor.border),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isIOS ? 14 : 12),
        borderSide: const BorderSide(color: AppColor.border, width: 1),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(isIOS ? 14 : 12),
        borderSide: const BorderSide(color: AppColor.primary, width: 1.2),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isIOS ? 14 : 12),
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.primary,
      selectionColor: AppColor.primary.withOpacity(0.3),
      selectionHandleColor: AppColor.primary,
    ),

    appBarTheme: AppBarTheme(
      centerTitle: isIOS,
      elevation: 0,
      backgroundColor: AppColor.secondary,
      foregroundColor: AppColor.onPrimary,
    ),
  );
}
