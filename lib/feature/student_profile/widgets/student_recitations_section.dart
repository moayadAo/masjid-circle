import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/circles/widgets/circle_recitation/recitations_empty_state.dart';
import 'package:masjid/feature/circles/widgets/circle_recitation/recitations_filter_button.dart';
import 'package:masjid/feature/circles/widgets/circle_recitation/recitations_filter_sheet.dart';
import 'package:masjid/feature/student_profile/presentation/cubit/student_recitations_cubit.dart';
import 'package:masjid/feature/student_profile/presentation/cubit/student_recitations_state.dart';
import 'package:masjid/feature/student_profile/widgets/student_recitation_card.dart';
import 'package:shimmer/shimmer.dart';

class StudentRecitationsSection extends StatelessWidget {
  final int studentId;
  final BuildContext pageContext; // outer page context for filter sheet

  const StudentRecitationsSection({
    super.key,
    required this.studentId,
    required this.pageContext,
  });

  Future<void> _openFilterSheet(
    BuildContext context,
    StudentRecitationsCubit cubit,
  ) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecitationsFilterSheet(
        initialFromDate: cubit.fromDate,
        initialToDate: cubit.toDate,
        onApply: (from, to) => cubit.applyFilter(fromDate: from, toDate: to),
        onClear: cubit.clearFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<StudentRecitationsCubit>();
    final state = cubit.state;

    return BlocListener<StudentRecitationsCubit, StudentRecitationsState>(
      listener: (ctx, state) {
        if (state is StudentRecitationsFailureState) {
          AppToast.error(ctx, state.errMessage);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColor.primaryContainer.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.history_edu_rounded,
                    size: AppIconSize.sm,
                    color: AppColor.primaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'سجل التسميع',
                  style: AppTextStyle.headlineMd(
                    context,
                  ).copyWith(fontSize: 18),
                ),
                const Spacer(),
                RecitationsFilterButton(
                  isActive: cubit.hasActiveFilter,
                  onTap: () => _openFilterSheet(context, cubit),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Content ───────────────────────────────────────
          _buildContent(context, state, cubit.hasActiveFilter),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    StudentRecitationsState state,
    bool hasActiveFilter,
  ) {
    if (state is StudentRecitationsInitialState ||
        state is StudentRecitationsLoadingState) {
      return _RecitationsShimmer();
    }

    if (state is StudentRecitationsLoadMoreState) {
      return Column(
        children: [
          ...state.currentItems.map(
            (r) => StudentRecitationCard(recitation: r),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Center(
              child: SizedBox(
                width: 22.w,
                height: 22.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColor.primary,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (state is StudentRecitationsSuccessState) {
      if (state.items.isEmpty) {
        return Center(
          child: RecitationsEmptyState(isFiltered: hasActiveFilter),
        );
      }
      return Column(
        children: state.items
            .map((r) => StudentRecitationCard(recitation: r))
            .toList(),
      );
    }

    if (state is StudentRecitationsFailureState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Center(
          child: Text(
            state.errMessage,
            style: AppTextStyle.bodyMd(context).copyWith(color: AppColor.error),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _RecitationsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.surfaceContainerHigh,
      highlightColor: AppColor.surfaceContainerLowest,
      child: Column(
        children: List.generate(
          3,
          (_) => Container(
            height: 110,
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColor.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
          ),
        ),
      ),
    );
  }
}
