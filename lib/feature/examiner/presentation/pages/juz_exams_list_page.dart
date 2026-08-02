import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

import '../cubit/all_juz_exams_cubit.dart';
import '../cubit/all_juz_exams_state.dart';
import '../widgets/exams/exam_card.dart';
import '../widgets/exams/exams_filter_sheet.dart';
import '../widgets/shared/state_views.dart';

class JuzExamsListPage extends StatefulWidget {
  const JuzExamsListPage({super.key});

  @override
  State<JuzExamsListPage> createState() => _JuzExamsListPageState();
}

class _JuzExamsListPageState extends State<JuzExamsListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AllJuzExamsCubit>().applyFilters();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AllJuzExamsCubit>().loadMore();
    }
  }

  Future<void> _openFilters() async {
    final cubit = context.read<AllJuzExamsCubit>();
    final result = await showExamsFilterSheet(
      context,
      currentJuz: cubit.juzNumber,
      currentRating: cubit.rating,
      currentOrderBy: cubit.orderBy,
      currentOrderDirection: cubit.orderDirection,
    );
    if (result != null) {
      cubit.applyFilters(
        juzNumber: result.juzNumber,
        rating: result.rating,
        dateFrom: result.dateFrom,
        dateTo: result.dateTo,
        orderBy: result.orderBy,
        orderDirection: result.orderDirection,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text('اختبارات الأجزاء'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: _openFilters,
          ),
        ],
      ),
      body: BlocBuilder<AllJuzExamsCubit, AllJuzExamsState>(
        builder: (context, state) {
          if (state is AllJuzExamsInitialState ||
              state is AllJuzExamsLoadingState) {
            return const LoadingView();
          }
          if (state is AllJuzExamsFailureState) {
            return ErrorRetryView(
              message: state.errMessage,
              onRetry: () => context.read<AllJuzExamsCubit>().applyFilters(),
            );
          }

          final exams = state is AllJuzExamsSuccessState
              ? state.exams
              : state is AllJuzExamsLoadingMoreState
              ? state.exams
              : [];

          if (exams.isEmpty) {
            return const EmptyStateView(
              icon: Icons.history_edu_rounded,
              title: 'لا توجد نتائج',
              subtitle:
                  'حاول تغيير كلمات البحث أو المرشحات للعثور على ما تبحث عنه.',
            );
          }

          return ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(16.w),
            itemCount:
                exams.length + (state is AllJuzExamsLoadingMoreState ? 1 : 0),
            itemBuilder: (context, i) {
              if (i >= exams.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: LoadingView(),
                );
              }
              return ExamCard(exam: exams[i], showStudentName: true);
            },
          );
        },
      ),
    );
  }
}
