// daily_report_model.dart

class DailyReportSurah {
  final int id;
  final String nameArabic;
  final String nameEnglish;

  const DailyReportSurah({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
  });

  factory DailyReportSurah.fromJson(Map<String, dynamic> json) {
    return DailyReportSurah(
      id: json['id'] as int,
      nameArabic: json['name_arabic'] as String? ?? '',
      nameEnglish: json['name_english'] as String? ?? '',
    );
  }
}

class DailyReportAyahRange {
  final int surahId;
  final String surahNameArabic;
  final String surahNameEnglish;
  final int fromAyah;
  final int toAyah;

  const DailyReportAyahRange({
    required this.surahId,
    required this.surahNameArabic,
    required this.surahNameEnglish,
    required this.fromAyah,
    required this.toAyah,
  });

  factory DailyReportAyahRange.fromJson(Map<String, dynamic> json) {
    return DailyReportAyahRange(
      surahId: json['surah_id'] as int,
      surahNameArabic: json['surah_name_arabic'] as String? ?? '',
      surahNameEnglish: json['surah_name_english'] as String? ?? '',
      fromAyah: json['from_ayah'] as int,
      toAyah: json['to_ayah'] as int,
    );
  }
}

/// A single recitation entry within a rating group.
/// Exactly one of [pages], [surahs], [ayahRanges] will be non-null
/// depending on [recitationType].
class DailyReportRecitationEntry {
  final String recitationType; // pages | surah | ayah_range
  final List<int> pages;
  final List<DailyReportSurah> surahs;
  final List<DailyReportAyahRange> ayahRanges;

  const DailyReportRecitationEntry({
    required this.recitationType,
    required this.pages,
    required this.surahs,
    required this.ayahRanges,
  });

  factory DailyReportRecitationEntry.fromJson(Map<String, dynamic> json) {
    return DailyReportRecitationEntry(
      recitationType: json['recitation_type'] as String? ?? 'pages',
      pages: (json['pages'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      surahs: (json['surahs'] as List<dynamic>?)
              ?.map((e) => DailyReportSurah.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      ayahRanges: (json['ayah_ranges'] as List<dynamic>?)
              ?.map((e) =>
                  DailyReportAyahRange.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get isEmpty => pages.isEmpty && surahs.isEmpty && ayahRanges.isEmpty;
}

class DailyReportRecitationsByRating {
  final List<DailyReportRecitationEntry> excellent;
  final List<DailyReportRecitationEntry> veryGood;
  final List<DailyReportRecitationEntry> good;

  const DailyReportRecitationsByRating({
    required this.excellent,
    required this.veryGood,
    required this.good,
  });

  bool get hasNoRecitations =>
      excellent.isEmpty && veryGood.isEmpty && good.isEmpty;

  factory DailyReportRecitationsByRating.fromJson(Map<String, dynamic> json) {
    List<DailyReportRecitationEntry> _parseList(dynamic raw) =>
        (raw as List<dynamic>?)
            ?.map((e) => DailyReportRecitationEntry.fromJson(
                e as Map<String, dynamic>))
            .where((e) => !e.isEmpty)
            .toList() ??
        [];

    return DailyReportRecitationsByRating(
      excellent: _parseList(json['excellent']),
      veryGood: _parseList(json['very_good']),
      good: _parseList(json['good']),
    );
  }
}

class DailyReportStudentModel {
  final int studentId;
  final String studentName;
  final String publicCode;
  final String circleName;
  final String? lastRecitationDate;
  final DailyReportRecitationsByRating recitationsByRating;

  const DailyReportStudentModel({
    required this.studentId,
    required this.studentName,
    required this.publicCode,
    required this.circleName,
    this.lastRecitationDate,
    required this.recitationsByRating,
  });

  bool get didNotReciteToday =>
      recitationsByRating.hasNoRecitations;

  factory DailyReportStudentModel.fromJson(Map<String, dynamic> json) {
    return DailyReportStudentModel(
      studentId: json['student_id'] as int,
      studentName: json['student_name'] as String? ?? '',
      publicCode: json['public_code'] as String? ?? '',
      circleName: json['circle_name'] as String? ?? '',
      lastRecitationDate: json['last_recitation_date'] as String?,
      recitationsByRating: DailyReportRecitationsByRating.fromJson(
        json['recitations_by_rating'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}
