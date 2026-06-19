import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/widgets/app_error_widget.dart';
import 'package:masjid/feature/attendance/data_source/model/attendance_models.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_detail_cubit.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_detail_state.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_sessions_cubit.dart';
import 'package:masjid/feature/attendance/widgets/attendance_header_widget.dart';
import 'package:masjid/feature/attendance/widgets/attendance_record_row_widget.dart';
import 'package:masjid/feature/attendance/widgets/attendance_session_page_shimmer.dart';
import 'package:masjid/routing/app_router.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class AttendanceSessionPage extends StatefulWidget {
  final int sessionId;

  /// When navigating from create — pass session directly to skip fetch
  final AttendanceSessionModel? preloadedSession;

  const AttendanceSessionPage({
    super.key,
    required this.sessionId,
    this.preloadedSession,
  });

  @override
  State<AttendanceSessionPage> createState() => _AttendanceSessionPageState();
}

class _AttendanceSessionPageState extends State<AttendanceSessionPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<AttendanceDetailCubit>();
    if (widget.preloadedSession != null) {
      cubit.loadFromSession(widget.preloadedSession!);
    } else {
      cubit.loadSession(sessionId: widget.sessionId);
    }
  }

  void _onSubmit() {
    context.read<AttendanceDetailCubit>().submitAllRecords();
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
            'تسجيل الحضور',
            style: AppTextStyle.headlineMd(
              context,
            ).copyWith(color: AppColor.primary),
          ),
        ),
        body: BlocConsumer<AttendanceDetailCubit, AttendanceDetailState>(
          listener: (context, state) {
            if (state is SubmitRecordsSuccessState) {
              AppToast.success(context, 'تم حفظ سجل الحضور بنجاح');
              context
                  .pop(); // Navigate back to the previous page after successful submission
              context
                  .read<
                    AttendanceSessionsCubit
                  >(); // Refresh the sessions list on the previous page
            }
            if (state is SubmitRecordsFailureState) {
              AppToast.error(context, state.errMessage);
            }
          },
          builder: (context, state) {
            if (state is LoadSessionLoadingState) {
              return const AttendanceSessionPageShimmer();
            }
            if (state is LoadSessionFailureState) {
              return AppErrorWidget(
                message: state.errMessage,
                onRetry: () => context
                    .read<AttendanceDetailCubit>()
                    .loadSession(sessionId: widget.sessionId),
              );
            }

            final session = state is LoadSessionSuccessState
                ? state.session
                : state is RecordStatusChangedState
                ? state.session
                : state is SubmitRecordsSuccessState
                ? state.session
                : context.read<AttendanceDetailCubit>().session;

            if (session == null) return const SizedBox.shrink();
            final records = session.sortedRecords;

            return Column(
              children: [
                // ── Session info header ───────────────────
                AttendanceHeaderWidget(session: session),

                // ── Column labels row ─────────────────────
                _ColumnLabelsRow(),

                // ── Students list ─────────────────────────
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      MediaQuery.of(context).padding.bottom + 72,
                    ),
                    itemCount: records.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (_, i) => AttendanceRecordRowWidget(
                      record: records[i],
                      onStatusChanged: (newStatus) {
                        context
                            .read<AttendanceDetailCubit>()
                            .changeRecordStatus(
                              studentId: records[i].studentId,
                              newStatus: newStatus,
                            );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton:
            BlocBuilder<AttendanceDetailCubit, AttendanceDetailState>(
              buildWhen: (_, state) =>
                  state is SubmitRecordsLoadingState ||
                  state is SubmitRecordsSuccessState ||
                  state is SubmitRecordsFailureState ||
                  state is LoadSessionSuccessState,
              builder: (context, state) {
                final isLoading = state is SubmitRecordsLoadingState;
                return FloatingActionButton.extended(
                  onPressed: isLoading ? null : _onSubmit,
                  backgroundColor: AppColor.primaryContainer,
                  foregroundColor: AppColor.onPrimary,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColor.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    'حفظ سجل الحضور',
                    style: AppTextStyle.labelLg(
                      context,
                      AppColor.onPrimary,
                      null,
                    ),
                  ),
                );
              },
            ),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

// ── Column labels ────────────────────────────────────────
class _ColumnLabelsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColor.primaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'الطالب',
              style: AppTextStyle.labelLg(context, AppColor.onPrimary, null),
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ColLabel(icon: Icons.check_circle_outline, label: 'حاضر'),
                _ColLabel(icon: Icons.cancel_outlined, label: 'غائب'),
                _ColLabel(icon: Icons.schedule_outlined, label: 'متأخر'),
                _ColLabel(icon: Icons.history_outlined, label: 'بعذر'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ColLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColor.onPrimary, size: AppIconSize.sm),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyle.labelLg(context, AppColor.onPrimary, 10),
        ),
      ],
    );
  }
}
