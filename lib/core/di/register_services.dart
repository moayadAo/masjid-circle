import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:masjid/feature/attendance/data_source/remote/attendance_service.dart';
import 'package:masjid/feature/auth/data_source/remote/auth_service.dart';
import 'package:masjid/feature/circles/data_source/remote/circles_service.dart';
import 'package:masjid/feature/recitation_form/data/remote/surah_local_service.dart';

import '../../feature/recitation/data/remote/recitation_service.dart';
import '../../feature/recitation_form/data/remote/recitation_form_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Reverb / API constants — single source of truth.
// ═══════════════════════════════════════════════════════════════════════════

/// FIXED: was '8lmq6pmogf6yrglweui1' (missing the 's' after 'm').
const _reverbAppKey = '8lmq6pmogf6yrglweui1';
const _reverbHost = 'backend.sellit-app.com';
const _reverbPort = 443;
const _reverbTls = true;

/// API base URL used for `/broadcasting/auth`. Must be the same Laravel app
/// that issued the user's Bearer token. If your test env uses a different
/// API host (e.g. `test.backend.sellit-app.com`), change this.
const _apiBaseUrl = 'https://alzahraa-api.cronica-co.com/';

// ═══════════════════════════════════════════════════════════════════════════
// Registration
// ═══════════════════════════════════════════════════════════════════════════

void registerServices(GetIt getIt) {
  // // ── Auth ──────────────────────────────────────────────────────────────────
  // getIt.registerLazySingleton<AuthService>(
  //   () => AuthServiceImpl(apiConsumer: getIt()),
  // );
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(apiConsumer: getIt()),
  );

  getIt.registerLazySingleton<RecitationService>(
    () => RecitationServiceImpl(apiConsumer: getIt()),
  );

  getIt.registerLazySingleton<RecitationFormService>(
    () => RecitationFormServiceImpl(apiConsumer: getIt()),
  );
  getIt.registerLazySingleton<SurahLocalService>(() => SurahLocalServiceImpl());
  getIt.registerLazySingleton<AttendanceService>(
    () => AttendanceServiceImpl(apiConsumer: getIt()),
  );
  getIt.registerLazySingleton<CirclesService>(
    () => CirclesServiceImpl(apiConsumer: getIt()),
  );
}
