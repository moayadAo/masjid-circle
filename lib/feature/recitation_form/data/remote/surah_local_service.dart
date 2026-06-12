// surah_local_service.dart
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/surah_model.dart';

/// Loads the 114 Surahs from `assets/data/surahs.json`.
///
/// Make sure the file is registered in `pubspec.yaml`:
/// ```yaml
/// flutter:
///   assets:
///     - assets/data/surahs.json
/// ```
abstract class SurahLocalService {
  Future<List<SurahModel>> getSurahs();
}

class SurahLocalServiceImpl implements SurahLocalService {
  static const String _assetPath = 'assets/data/surahs.json';

  List<SurahModel>? _cache;

  @override
  Future<List<SurahModel>> getSurahs() async {
    if (_cache != null) return _cache!;

    final raw = await rootBundle.loadString(_assetPath);
    final list = jsonDecode(raw) as List<dynamic>;

    _cache = list
        .map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return _cache!;
  }
}
