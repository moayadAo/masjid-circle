import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/routing/export_route_files.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

import '../../data/models/examiner_student_model.dart';
import '../../data/models/juz_exam_model.dart';
import '../cubit/student_juz_exams_cubit.dart';
import '../cubit/student_juz_exams_state.dart';
import '../widgets/exams/exam_card.dart';
import '../widgets/exams/student_header_card.dart';
import '../widgets/shared/state_views.dart';

class StudentJuzExamsPage extends StatefulWidget {
  final ExaminerStudentModel student;

  const StudentJuzExamsPage({super.key, required this.student});

  @override
  State<StudentJuzExamsPage> createState() => _StudentJuzExamsPageState();
}

class _StudentJuzExamsPageState extends State<StudentJuzExamsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<StudentJuzExamsCubit>().loadExams(
      studentId: widget.student.id,
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<StudentJuzExamsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _goCreateExam() async {
    final created = await context.pushNamed<bool>(
      Routes.juzExamForm,
      extra: widget.student,
    );
    if (created == true && mounted) {
      context.read<StudentJuzExamsCubit>().loadExams(
        studentId: widget.student.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(title: Text(widget.student.fullName)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goCreateExam,
        icon: const Icon(Icons.add_rounded),
        label: const Text('اختبار'),
      ),
      body: Column(
        children: [
          StudentHeaderCard(student: widget.student),
          Expanded(
            child: BlocBuilder<StudentJuzExamsCubit, StudentJuzExamsState>(
              builder: (context, state) {
                if (state is StudentJuzExamsInitialState ||
                    (state is StudentJuzExamsLoadingState &&
                        state is! StudentJuzExamsLoadingMoreState)) {
                  return const LoadingView();
                }
                if (state is StudentJuzExamsFailureState) {
                  return ErrorRetryView(
                    message: state.errMessage,
                    onRetry: () => context
                        .read<StudentJuzExamsCubit>()
                        .loadExams(studentId: widget.student.id),
                  );
                }

                final exams = state is StudentJuzExamsSuccessState
                    ? state.exams
                    : state is StudentJuzExamsLoadingMoreState
                    ? state.exams
                    : <JuzExamModel>[];

                if (exams.isEmpty) {
                  return const EmptyStateView(
                    icon: Icons.history_edu_rounded,
                    title: 'لا توجد اختبارات مسجلة',
                    subtitle: 'ابدأ رحلة التميز وسجل أول اختبار للطالب اليوم',
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 96.h),
                  itemCount:
                      exams.length +
                      (state is StudentJuzExamsLoadingMoreState ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i >= exams.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: LoadingView(),
                      );
                    }
                    return ExamCard(exam: exams[i]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
