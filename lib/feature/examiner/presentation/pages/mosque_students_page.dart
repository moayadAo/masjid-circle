import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/feature/recitation/presentation/pages/qr_scanner_page.dart';
import 'package:masjid/routing/export_route_files.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

import '../../data/models/examiner_student_model.dart';
import '../cubit/examiner_students_cubit.dart';
import '../cubit/examiner_students_state.dart';
import '../widgets/shared/state_views.dart';
import '../widgets/students/qr_scan_button.dart';
import '../widgets/students/student_card.dart';
import '../widgets/students/student_search_fields.dart';

class MosqueStudentsPage extends StatefulWidget {
  const MosqueStudentsPage({super.key});

  @override
  State<MosqueStudentsPage> createState() => _MosqueStudentsPageState();
}

class _MosqueStudentsPageState extends State<MosqueStudentsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ExaminerStudentsCubit>().loadStudents();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ExaminerStudentsCubit>().loadMore();
    }
  }

  void _openStudent(ExaminerStudentModel student) {
    context.pushNamed(
      Routes.studentJuzExams,
      pathParameters: {'studentId': student.id.toString()},
      extra: student,
    );
  }

  Future<void> _onScanTap() async {
    if (!mounted) return;

    final scannedCode = await Navigator.of(context).push<String?>(
      MaterialPageRoute(builder: (_) => const QrScannerPage()),
    );

    if (!mounted) return;

    final code = scannedCode?.trim();
    if (code == null || code.isEmpty) {
      AppToast.warning(context, 'تم إلغاء المسح أو لم يتم قراءة أي رمز QR');
      return;
    }

    context.read<ExaminerStudentsCubit>().lookupByBarcode(code);
  }

  void _onManualCode(String code) {
    if (code.trim().isEmpty) return;
    context.read<ExaminerStudentsCubit>().lookupByBarcode(code);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExaminerStudentsCubit, ExaminerStudentsState>(
      listener: (context, state) {
        if (state is ExaminerBarcodeSuccessState) {
          _openStudent(state.student);
        } else if (state is ExaminerBarcodeFailureState) {
          AppToast.error(context, state.errMessage);
        }
      },
      builder: (context, state) {
        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                child: Column(
                  children: [
                    QrScanButton(onTap: _onScanTap),
                    16.sbH,
                    ManualCodeField(onSubmitted: _onManualCode),
                    12.sbH,
                    StudentNameSearchField(
                      onChanged: (v) => context
                          .read<ExaminerStudentsCubit>()
                          .loadStudents(search: v),
                    ),
                  ],
                ),
              ),
            ),
            _buildList(state),
          ],
        );
      },
    );
  }

  Widget _buildList(ExaminerStudentsState state) {
    if (state is ExaminerStudentsLoadingState ||
        state is ExaminerStudentsInitialState) {
      return const SliverFillRemaining(child: LoadingView());
    }
    if (state is ExaminerStudentsFailureState) {
      return SliverFillRemaining(
        child: ErrorRetryView(
          message: state.errMessage,
          onRetry: () => context.read<ExaminerStudentsCubit>().loadStudents(),
        ),
      );
    }

    List<ExaminerStudentModel> students = context
        .read<ExaminerStudentsCubit>()
        .lastStudents;
    if (state is ExaminerStudentsSuccessState) students = state.students;

    if (students.isEmpty) {
      return const SliverFillRemaining(
        child: EmptyStateView(
          icon: Icons.search_off_rounded,
          title: 'لا يوجد طلاب حالياً',
          subtitle: 'لم نتمكن من العثور على طالب بهذا الاسم أو الكود.',
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverList.builder(
        itemCount: students.length +
            (state is ExaminerStudentsLoadingMoreState ? 1 : 0),
        itemBuilder: (context, i) {
          if (i >= students.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: LoadingView(),
            );
          }

          return StudentCard(
            student: students[i],
            onTap: () => _openStudent(students[i]),
          );
        },
      ),
    );
  }
}
