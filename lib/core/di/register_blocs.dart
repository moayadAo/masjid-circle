import 'package:hive/hive.dart';
import 'package:get_it/get_it.dart';

void registerBlocs(GetIt getIt) {
  // // ── Auth ──────────────────────────────────────────────────────────────────
  // getIt.registerFactory<AuthBloc>(
  //   () => AuthBloc(
  //     authService: getIt<AuthService>(),
  //     searchHistoryRepository: getIt<SearchHistoryRepository>(),
  //   ),
  // );

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
