import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/di/service_locator.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get appProviders => [
  // BlocProvider(create: (_) => NavigationBloc()),

  // BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
  BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
  // BlocProvider(create: (context) => getIt<ReportBloc>()),
  // BlocProvider(create: (context) => getIt<PaymentBloc>()),
  // BlocProvider(create: (context) => getIt<BankInfoBloc>()),
  // BlocProvider<CreateAdBloc>(create: (_) => getIt<CreateAdBloc>()),

  // BlocProvider<AdDetailsBloc>(
  //   create: (_) => AdDetailsBloc(adService: getIt<CreateAdService>()),
  // ),
  // BlocProvider<AdDetailsFormBloc>(create: (_) => getIt<AdDetailsFormBloc>()),
];
