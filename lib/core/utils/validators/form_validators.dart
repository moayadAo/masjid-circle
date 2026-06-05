class FormValidators {
  static String? validateName(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الاسم مطلوب';
    }
    return null;
  }

  static String? validateEmail(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }

    final RegExp emailRegex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$',
    ); // Simple email regex

    if (!emailRegex.hasMatch(value.trim())) {
      return 'أدخل بريد إلكتروني صالح';
    }

    return null;
  }

  static String? validatePhone(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الحقل مطلوب';
    }

    final phone = value.trim();

    // Check if contains only digits
    if (!RegExp(r'^\d+$').hasMatch(phone)) {
      return 'يجب إدخال أرقام فقط';
    }

    // Check length
    if (phone.length != 10) {
      return 'يجب أن يكون الرقم 10 أرقام';
    }

    // Check if starts with 09
    if (!phone.startsWith('09')) {
      return 'يجب أن يكون الرقم سوري';
    }

    return null; // Valid
  }

  static String? validateUserName(final String? value) {
    if (validatePhone(value) != null && validateEmail(value) != null) {
      return 'يجب أن يكون البريد الإلكتروني أو رقم الهاتف صالح';
    } else {
      return null;
    }
  }

  /// this Just checks if the field is not empty, used in fields that are required
  static String? validateIsRequired(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الحقل مطلوب';
    }
    return null;
  }

  /// this validator is used in both verficiation pages for email and phone, so it checks if the input is a valid 6 digit code
  static String? validateOtpCode(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الحقل مطلوب';
    }

    final RegExp otpRegex = RegExp(r'^\d{6}$');

    if (!otpRegex.hasMatch(value.trim())) {
      return 'رمز التحقق يجب أن يكون 6 أرقام';
    }

    return null;
  }

  /// This validator is used in both change email and change phone number forms, so it checks if the input is either a valid email or a valid phone number
  static String? validateEmailOrPhone(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'الحقل مطلوب';
    }

    final RegExp isEmail = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,4}$');
    final RegExp isPhone = RegExp(r'^\d{10}$');

    if (!isEmail.hasMatch(value.trim()) && !isPhone.hasMatch(value.trim())) {
      return 'أدخل بريد صحيح أو رقم هاتف من 10 أرقام';
    }

    return null;
  }

  static String? validatePasswordTemp(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    final password = value.trim();

    // Length check
    if (password.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }

    return null; // Valid
  }

  static String? validatePassword(final String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'كلمة المرور مطلوبة';
    }

    final password = value.trim();

    // Length check
    if (password.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }

    // At least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'يجب أن تحتوي كلمة المرور على حرف كبير واحد على الأقل';
    }

    // At least one number
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';
    }

    return null; // Valid
  }

  static String? validateConfirmPassword(
    final String? value,
    final String original,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    } else if (value != original) {
      return 'كلمتا المرور غير متطابقتين';
    }
    return null;
  }
}
