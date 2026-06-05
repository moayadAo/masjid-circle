import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/spacing_system/icon_sizes.dart';
import 'package:masjid/core/design_app/spacing_system/radius.dart';
import 'package:masjid/core/design_app/spacing_system/spacing.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';
import 'package:masjid/core/design_app/typography/style_app.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? prefixWidget;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textAlign: TextAlign.right,

      textDirection: TextDirection.rtl,
      validator: validator,
      style: AppTextStyle.bodyMd(context).copyWith(color: AppColor.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle.bodyMd(
          context,
        ).copyWith(color: AppColor.outline),
        filled: true,
        fillColor: const Color(0xFFF7F3EF),
        prefixIcon:
            prefixWidget ??
            (prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppColor.outline,
                    size: AppIconSize.md,
                  )
                : null),
        suffixIcon:
            suffixWidget ??
            (suffixIcon != null
                ? Icon(
                    suffixIcon,
                    color: AppColor.outline,
                    size: AppIconSize.md,
                  )
                : null),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: AppColor.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(
            color: AppColor.primaryContainer,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}
