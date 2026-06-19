import 'dart:developer';

class ErrorMessageConverter {
  const ErrorMessageConverter._();

  static final Map<String, String> _exactTranslations = {
    'An attendance session already exists for this circle on this date':
        'توجد بالفعل جلسة حضور لهذه الحلقة في هذا التاريخ',
    'Network error': 'خطأ في الشبكة',
    'Request timeout': 'انتهت مهلة الطلب',
    'Unauthorized': 'غير مصرح لك',
    'Forbidden': 'تم رفض الوصول',
    'Not found': 'العنصر غير موجود',
    'Internal server error': 'خطأ داخلي في الخادم',
    'Bad request': 'طلب غير صالح',
    'Validation error': 'خطأ في التحقق من البيانات',
    'Unknown error': 'حدث خطأ غير معروف',
  };

  static final Map<String, String> _containsTranslations = {
    'already exists': 'العنصر موجود بالفعل',
    'attendance session': 'توجد مشكلة في جلسة الحضور',
    'circle': 'توجد مشكلة متعلقة بالحلقة',
    'date': 'توجد مشكلة متعلقة بالتاريخ',
    'timeout': 'انتهت مهلة الاتصال',
    'network': 'تعذر الاتصال بالشبكة',
    'unauthorized': 'غير مصرح لك بتنفيذ هذا الإجراء',
    'forbidden': 'ليس لديك صلاحية الوصول',
    'not found': 'لم يتم العثور على المطلوب',
    'validation': 'البيانات المدخلة غير صحيحة',
    'required': 'هذا الحقل مطلوب',
    'invalid': 'قيمة غير صالحة',
  };

  static String toArabic(String? message) {
    if (message == null || message.trim().isEmpty) {
      return 'حدث خطأ غير متوقع';
    }

    final normalized = removePunctuationMarks(message.trim());

    for (final entry in _exactTranslations.entries) {
      log('normalized.toLowerCase() = ${message.toLowerCase()}');
      log('entry.key.toLowerCase() = ${entry.key.toLowerCase()}');

      if (normalized.toLowerCase() == entry.key.toLowerCase()) {
        return entry.value;
      }
    }

    final lower = normalized.toLowerCase();
    for (final entry in _containsTranslations.entries) {
      if (lower.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }

    return normalized;
  }

  static String removePunctuationMarks(String message) {
    return message.replaceAll(_punctuationMarksRegex, '');
  }

  static final RegExp _punctuationMarksRegex = RegExp(
    r'''[.,!?;:"'،؛؟ـ\-—_()\[\]{}<>/\\…]''',
  );
}
