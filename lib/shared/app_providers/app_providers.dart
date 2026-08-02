import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/di/service_locator.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_detail_cubit.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_sessions_cubit.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:masjid/feature/circles/presentation/cubit/circles_cubit.dart';
import 'package:masjid/feature/examiner/presentation/cubit/all_juz_exams_cubit.dart';
import 'package:masjid/feature/examiner/presentation/cubit/examiner_students_cubit.dart';
import 'package:masjid/feature/examiner/presentation/cubit/juz_exam_form_cubit.dart';
import 'package:masjid/feature/examiner/presentation/cubit/student_juz_exams_cubit.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get appProviders => [
  // BlocProvider(create: (_) => NavigationBloc()),

  // BlocProvider<AuthBloc>(create: (_) => getIt<AuthBloc>()),
  BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
  BlocProvider<AttendanceDetailCubit>(
    create: (_) => getIt<AttendanceDetailCubit>(),
  ),
  BlocProvider<AttendanceSessionsCubit>(
    create: (_) => getIt<AttendanceSessionsCubit>(),
  ),
  BlocProvider<CirclesCubit>(create: (_) => getIt<CirclesCubit>()),
  BlocProvider<ExaminerStudentsCubit>(
    create: (_) => getIt<ExaminerStudentsCubit>(),
  ),
  BlocProvider<StudentJuzExamsCubit>(
    create: (_) => getIt<StudentJuzExamsCubit>(),
  ),
  BlocProvider<AllJuzExamsCubit>(create: (_) => getIt<AllJuzExamsCubit>()),
  BlocProvider<JuzExamFormCubit>(create: (_) => getIt<JuzExamFormCubit>()),
  // BlocProvider(create: (context) => getIt<ReportBloc>()),
  // BlocProvider(create: (context) => getIt<PaymentBloc>()),
  // BlocProvider(create: (context) => getIt<BankInfoBloc>()),
  // BlocProvider<CreateAdBloc>(create: (_) => getIt<CreateAdBloc>()),

  // BlocProvider<AdDetailsBloc>(
  //   create: (_) => AdDetailsBloc(adService: getIt<CreateAdService>()),
  // ),
  // BlocProvider<AdDetailsFormBloc>(create: (_) => getIt<AdDetailsFormBloc>()),
];
