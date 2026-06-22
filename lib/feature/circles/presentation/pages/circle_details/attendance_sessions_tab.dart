import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/core/widgets/app_error_widget.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_sessions_cubit.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_sessions_state.dart';
import 'package:masjid/feature/attendance/widgets/attendance_session_card_shimmer.dart';
import 'package:masjid/feature/attendance/widgets/attendance_session_card_widget.dart';
import 'package:masjid/routing/app_router.dart';

class AttendanceSessionsTab extends StatelessWidget {
  final int circleId;

  const AttendanceSessionsTab({super.key, required this.circleId});

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
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  child: Center(
                    child: Text(
                      'لا توجد جلسات سابقة',
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

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 100) {
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
              itemBuilder: (_, index) {
                if (index == sessions.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return AttendanceSessionCardWidget(
                  session: sessions[index],
                  onTap: () => context.push(
                    Routes.attendanceSessionPath(sessions[index].id),
                    extra: sessions[index],
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
