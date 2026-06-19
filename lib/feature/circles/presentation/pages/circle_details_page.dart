import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/constant/assets_manager.dart';
import 'package:masjid/core/widgets/app_error_widget.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_sessions_cubit.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_sessions_state.dart';
import 'package:masjid/feature/attendance/widgets/add_session_bottom_sheet.dart';
import 'package:masjid/feature/attendance/widgets/attendance_session_card_shimmer.dart';
import 'package:masjid/feature/attendance/widgets/attendance_session_card_widget.dart';
import 'package:masjid/feature/circles/presentation/cubit/circles_cubit.dart';
import 'package:masjid/feature/circles/presentation/cubit/circles_state.dart';
import 'package:masjid/feature/circles/presentation/pages/student_list_item_widget.dart';
import 'package:masjid/feature/circles/widgets/student_list_item_shimmer.dart';
import 'package:masjid/routing/app_router.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class CircleDetailsPage extends StatefulWidget {
  final int circleId;
  final String circleName;

  const CircleDetailsPage({
    super.key,
    required this.circleId,
    required this.circleName,
  });

  @override
  State<CircleDetailsPage> createState() => _CircleDetailsPageState();
}

class _CircleDetailsPageState extends State<CircleDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Load sessions on start
    context.read<AttendanceSessionsCubit>().loadSessions(
      circleId: widget.circleId,
    );
  }

  void _onTabChanged() {
    if (_tabController.index == 1) {
      // Load students when switching to students tab
      context.read<CirclesCubit>().getCircleStudents(circleId: widget.circleId);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showAddSessionSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<AttendanceSessionsCubit>(),
        child: AddSessionBottomSheet(circleId: widget.circleId),
      ),
    );

    // After sheet closes, if session was created, navigate to it and refresh
    // the circle sessions list when returning to this page.
    final cubitState = context.read<AttendanceSessionsCubit>().state;
    if (cubitState is OpenSessionSuccessState) {
      await context.push(
        Routes.attendanceSessionPath(cubitState.session.id),
        extra: cubitState.session,
      );

      if (!mounted) return;

      await context.read<AttendanceSessionsCubit>().loadSessions(
        circleId: widget.circleId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          backgroundColor: AppColor.surfaceContainerLowest,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColor.primary),
            onPressed: () => context.pop(),
          ),
          title: Text(
            widget.circleName,
            style: AppTextStyle.headlineMd(
              context,
            ).copyWith(color: AppColor.primary),
          ),
        ),
        body: Column(
          children: [
            // ── Hero banner ─────────────────────────────────
            _HeroBanner(),

            // ── Tab bar ──────────────────────────────────────
            Container(
              color: AppColor.surfaceContainerLowest,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColor.primary,
                unselectedLabelColor: AppColor.outline,
                indicatorColor: AppColor.primaryContainer,
                indicatorWeight: 3,
                labelStyle: AppTextStyle.labelLg(context, null, null),
                tabs: const [
                  Tab(text: 'جلسات الحضور'),
                  Tab(text: 'الطلاب'),
                ],
              ),
            ),

            // ── Tab content ──────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _AttendanceSessionsTab(circleId: widget.circleId),
                  _StudentsTab(circleId: widget.circleId),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _tabController.index == 0
            ? FloatingActionButton.extended(
                onPressed: _showAddSessionSheet,
                backgroundColor: AppColor.primaryContainer,
                foregroundColor: AppColor.onPrimary,
                icon: const Icon(Icons.add),
                label: Text(
                  'إضافة جلسة حضور',
                  style: AppTextStyle.labelLg(
                    context,
                    AppColor.onPrimary,
                    null,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

// ── Hero Banner ──────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AssetsManager.heroImageCircleDetails,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Container(height: 160, color: AppColor.primaryContainer),
        ),
        Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColor.primary.withOpacity(0.2),
                AppColor.primary.withOpacity(0.8),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: AppSpacing.md,
          right: AppSpacing.md,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'تفاصيل الحلقة',
                style: AppTextStyle.headlineLg(
                  context,
                ).copyWith(color: AppColor.onPrimary),
              ),
              Text(
                'إدارة حضور الطلاب',
                style: AppTextStyle.bodyMd(
                  context,
                ).copyWith(color: AppColor.onPrimaryContainer),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Attendance Sessions Tab ──────────────────────────────
class _AttendanceSessionsTab extends StatelessWidget {
  final int circleId;
  const _AttendanceSessionsTab({required this.circleId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceSessionsCubit, AttendanceSessionsState>(
      buildWhen: (_, state) =>
          state is AttendanceSessionsLoadingState ||
          state is AttendanceSessionsSuccessState ||
          state is AttendanceSessionsFailureState ||
          state is AttendanceSessionsLoadMoreState,
      builder: (context, state) {
        if (state is AttendanceSessionsLoadingState) {
          return const AttendanceSessionListShimmer();
        }
        if (state is AttendanceSessionsFailureState) {
          return AppErrorWidget(
            message: state.errMessage,
            onRetry: () => context.read<AttendanceSessionsCubit>().loadSessions(
              circleId: circleId,
            ),
          );
        }

        final sessions = state is AttendanceSessionsSuccessState
            ? state.sessions
            : state is AttendanceSessionsLoadMoreState
            ? state.currentSessions
            : <dynamic>[];

        if (sessions.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<AttendanceSessionsCubit>().loadSessions(
                circleId: circleId,
              );
              await Future.delayed(const Duration(milliseconds: 300));
            },
            child: Center(
              child: Text(
                'لا توجد جلسات سابقة',
                style: AppTextStyle.bodyLg(
                  context,
                ).copyWith(color: AppColor.outline),
              ),
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (n) {
            if (n.metrics.pixels >= n.metrics.maxScrollExtent - 100) {
              context.read<AttendanceSessionsCubit>().loadMore();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              await context.read<AttendanceSessionsCubit>().loadSessions(
                circleId: circleId,
              );
              await Future.delayed(const Duration(milliseconds: 300));
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount:
                  sessions.length +
                  (state is AttendanceSessionsLoadMoreState ? 1 : 0),
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (_, i) {
                if (i == sessions.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return AttendanceSessionCardWidget(
                  session: sessions[i],
                  onTap: () => context.push(
                    Routes.attendanceSessionPath(sessions[i].id),
                    extra: sessions[i],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ── Students Tab ─────────────────────────────────────────
class _StudentsTab extends StatelessWidget {
  final int circleId;
  const _StudentsTab({required this.circleId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CirclesCubit, CirclesState>(
      buildWhen: (_, state) =>
          state is GetStudentsLoadingState ||
          state is GetStudentsSuccessState ||
          state is GetStudentsFailureState,
      builder: (context, state) {
        if (state is GetStudentsLoadingState) {
          return const StudentListShimmer();
        }
        if (state is GetStudentsFailureState) {
          return AppErrorWidget(
            message: state.errMessage,
            onRetry: () {
              context.read<CirclesCubit>().getCircleStudents(
                circleId: circleId,
              );
            },
          );
        }
        if (state is GetStudentsSuccessState) {
          if (state.students.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CirclesCubit>().getCircleStudents(
                  circleId: circleId,
                );
                // wait briefly for cubit to fetch
                await Future.delayed(const Duration(milliseconds: 300));
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.lg),
                      child: Text(
                        'لا يوجد طلاب في هذه الحلقة',
                        style: AppTextStyle.bodyLg(
                          context,
                        ).copyWith(color: AppColor.outline),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CirclesCubit>().getCircleStudents(
                circleId: circleId,
              );
              await Future.delayed(const Duration(milliseconds: 300));
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.students.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (_, i) =>
                  StudentListItemWidget(student: state.students[i]),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
