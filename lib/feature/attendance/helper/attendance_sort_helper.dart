class AttendanceSortHelper {
  static List<T> sortByArabicName<T>(
    List<T> items,
    String Function(T item) nameSelector,
  ) {
    final sortedRecords = List<T>.from(items);
    sortedRecords.sort((left, right) {
      return _compareArabicNames(nameSelector(left), nameSelector(right));
    });
    return sortedRecords;
  }

  static int _compareArabicNames(String left, String right) {
    final leftKey = _normalizedArabicSortKey(left);
    final rightKey = _normalizedArabicSortKey(right);
    return leftKey.compareTo(rightKey);
  }

  static String _normalizedArabicSortKey(String value) {
    final buffer = StringBuffer();
    for (final rune in value.trim().runes) {
      final character = String.fromCharCode(rune);
      final normalizedCharacter =
          _arabicSortCharacterMap[character] ?? character;
      if (_ignoredCharacters.contains(normalizedCharacter)) {
        continue;
      }
      buffer.write(normalizedCharacter);
    }
    return buffer.toString();
  }

  static const Set<String> _ignoredCharacters = {
    ' ',
    '\t',
    '\n',
    '\r',
    '\u0640', // tatweel
    '\u064B',
    '\u064C',
    '\u064D',
    '\u064E',
    '\u064F',
    '\u0650',
    '\u0651',
    '\u0652',
    '\u0653',
    '\u0654',
    '\u0655',
  };

  static const Map<String, String> _arabicSortCharacterMap = {
    'أ': 'ا',
    'إ': 'ا',
    'آ': 'ا',
    'ٱ': 'ا',
    'ى': 'ي',
    'ئ': 'ي',
    'ؤ': 'و',
    'ة': 'ه',
  };
}
