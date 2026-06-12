import 'package:get_it/get_it.dart';
import 'package:masjid/core/storage/hive_helper.dart';
import 'package:masjid/feature/attendance/data_source/remote/attendance_service.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_detail_cubit.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_sessions_cubit.dart';
import 'package:masjid/feature/auth/data_source/remote/auth_service.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:masjid/feature/circles/data_source/remote/circles_service.dart';
import 'package:masjid/feature/circles/presentation/cubit/circles_cubit.dart';

void registerBlocs(GetIt getIt) {
  // // ── Auth ──────────────────────────────────────────────────────────────────
  // getIt.registerFactory<AuthBloc>(
  //   () => AuthBloc(
  //     authService: getIt<AuthService>(),
  //     searchHistoryRepository: getIt<SearchHistoryRepository>(),
  //   ),
  // );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      authService: getIt<AuthService>(),
      hiveHelper: getIt<HiveHelper>(),
    ),
  );
  getIt.registerFactory<AttendanceDetailCubit>(
    () => AttendanceDetailCubit(attendanceService: getIt<AttendanceService>()),
  );
  getIt.registerFactory<AttendanceSessionsCubit>(
    () =>
        AttendanceSessionsCubit(attendanceService: getIt<AttendanceService>()),
  );
  getIt.registerFactory<CirclesCubit>(
    () => CirclesCubit(circlesService: getIt<CirclesService>()),
  );
  // // ── Report ────────────────────────────────────────────────────────────────
  // getIt.registerFactory<ReportBloc>(
  //   () => ReportBloc(reportRemote: getIt<ReportRemote>()),
  // );
  // //================== <Payment> ==================
  // getIt.registerFactory<PaymentBloc>(
  //   () => PaymentBloc(remote: getIt<PaymentRemote>()),
  // );

  // getIt.registerFactory<AllTransactionsBloc>(
  //   () => AllTransactionsBloc(remote: getIt<PaymentRemote>()),
  // );

  // // ── Create Ad ─────────────────────────────────────────────────────────────
  // getIt.registerFactory<CreateAdBloc>(
  //   () => CreateAdBloc(service: getIt<CreateAdService>()),
  // );

  // // ── Home ──────────────────────────────────────────────────────────────────
  // getIt.registerFactory<HomeBloc>(
  //   () => HomeBloc(getAdsUseCase: getIt<GetAdsUseCase>()),
  // );

  // // ── My Ads ────────────────────────────────────────────────────────────────
  // getIt.registerFactory<MyAdsBloc>(
  //   () => MyAdsBloc(
  //     getMyAdsUseCase: getIt<GetMyAdsUseCase>(),
  //     deleteMyAdUseCase: getIt<DeleteMyAdUseCase>(),
  //     checkUpdateTimeUseCase: getIt<CheckUpdateTimeUseCase>(),
  //     updateMyAdUseCase: getIt<UpdateMyAdUseCase>(),
  //     markSoldUseCase: getIt<MarkSoldUseCase>(),
  //     repostMyAdUseCase: getIt<RepostMyAdUseCase>(),
  //     cancelReviewUseCase: getIt<CancelReviewUseCase>(),
  //   ),
  // );
}
