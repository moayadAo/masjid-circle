import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/core/widgets/app_error_widget.dart';
import 'package:masjid/feature/auth/presentation/cubit/auth_cubit.dart';
import 'package:masjid/feature/circles/presentation/cubit/circles_cubit.dart';
import 'package:masjid/feature/circles/presentation/cubit/circles_state.dart';
import 'package:masjid/feature/circles/presentation/pages/student_list_item_widget.dart';
import 'package:masjid/feature/circles/widgets/student_list_item_shimmer.dart';
import 'package:masjid/routing/app_router.dart';

class StudentsTab extends StatelessWidget {
  final int circleId;

  const StudentsTab({super.key, required this.circleId});

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
              itemBuilder: (_, index) => StudentListItemWidget(
                student: state.students[index],
                onTap: () async {
                  final int resolvedCycleId = await context
                      .read<AuthCubit>()
                      .cycleId;
                  context.push(
                    Routes.recitationForm,
                    extra: {
                      'studentId': state.students[index].id,
                      // state.data.student.id,
                      'studentName': state.students[index].fullName,
                      'circleId': circleId,
                      'cycleId': resolvedCycleId,
                    },
                  );
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
