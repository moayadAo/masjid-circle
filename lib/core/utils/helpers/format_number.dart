import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberFormatter {
  NumberFormatter._();

  // =============================
  // Internal formatter - نستخدم تنسيق #,### بدلاً من locale
  // =============================
  static final NumberFormat _decimalFormatter = NumberFormat('#,###', 'en_US');

  // =====================================================
  // 1) FOR BACKEND VALUES (DISPLAY ONLY)
  // =====================================================
  static String withThousandsSeparator(dynamic value) {
    if (value == null) return '0';

    final number = int.tryParse(value.toString());
    if (number == null) return value.toString();

    return _decimalFormatter.format(number);
  }

  // =====================================================
  // 2) FOR COMMENTS / LIKES (K, M, B)
  // =====================================================
  static String compact(int number) {
    if (number >= 1000000000) {
      return "${(number / 1000000000).toStringAsFixed(1)}B";
    } else if (number >= 1000000) {
      return "${(number / 1000000).toStringAsFixed(1)}M";
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}K";
    } else {
      return number.toString();
    }
  }

  // =====================================================
  // 3) INPUT FORMATTER (TextField)
  // =====================================================
  static TextInputFormatter thousandsInputFormatter =
  _ThousandsSeparatorInputFormatter();
}

// =====================================================
// PRIVATE INPUT FORMATTER
// =====================================================
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final digitsOnly = newValue.text.replaceAll(',', '');

    if (digitsOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final number = int.tryParse(digitsOnly);
    if (number == null) return oldValue;

    final newText = _formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}