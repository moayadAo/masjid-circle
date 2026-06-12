// surah_model.dart

/// Represents a single Quran Surah, loaded from
/// `assets/data/surahs.json`.
class SurahModel {
  final int id;
  final String nameAr;

  /// "meccan" or "medinan"
  final String revelationType;
  final int versesCount;
  final int startPage;
  final int endPage;

  const SurahModel({
    required this.id,
    required this.nameAr,
    required this.revelationType,
    required this.versesCount,
    required this.startPage,
    required this.endPage,
  });

  bool get isMeccan => revelationType == 'meccan';

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      revelationType: json['revelation_type'] as String,
      versesCount: json['verses_count'] as int,
      startPage: json['start_page'] as int,
      endPage: json['end_page'] as int,
    );
  }
}
