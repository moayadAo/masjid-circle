import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/core/di/service_locator.dart';
import 'package:masjid/feature/circles/widgets/circle_recitation/recitation_card.dart';
import 'package:masjid/feature/circles/widgets/circle_recitation/recitations_empty_state.dart';
import 'package:masjid/feature/circles/widgets/circle_recitation/recitations_filter_button.dart';
import 'package:masjid/feature/circles/widgets/circle_recitation/recitations_filter_sheet.dart';
import 'package:masjid/feature/daily_report/widgets/export_report_button.dart';
import '../cubit/circle_recitations_cubit.dart';
import '../cubit/circle_recitations_state.dart';

class CircleRecitationsTab extends StatelessWidget {
  final int circleId;
  final String circleName;

  const CircleRecitationsTab({
    super.key,
    required this.circleId,
    required this.circleName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CircleRecitationsCubit(service: getIt())
            ..loadRecitations(circleId: circleId),
      child: _CircleRecitationsTabBody(
        circleId: circleId,
        circleName: circleName,
      ),
    );
  }
}

class _CircleRecitationsTabBody extends StatefulWidget {
  final int circleId;
  final String circleName;

  const _CircleRecitationsTabBody({
    required this.circleId,
    required this.circleName,
  });

  @override
  State<_CircleRecitationsTabBody> createState() =>
      _CircleRecitationsTabBodyState();
}

class _CircleRecitationsTabBodyState extends State<_CircleRecitationsTabBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    debugPrint(
      'pixels=${_scrollController.position.pixels}'
      ' max=${_scrollController.position.maxScrollExtent}',
    );
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      debugPrint('LOAD MORE');
      context.read<CircleRecitationsCubit>().loadMore();
    }
    if (!_scrollController.hasClients) return;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openFilterSheet(CircleRecitationsCubit cubit) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecitationsFilterSheet(
        initialFromDate: cubit.fromDate,
        initialToDate: cubit.toDate,
        onApply: (fromDate, toDate) =>
            cubit.applyFilter(fromDate: fromDate, toDate: toDate),
        onClear: cubit.clearFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CircleRecitationsCubit>();

    return BlocListener<CircleRecitationsCubit, CircleRecitationsState>(
      listener: (context, state) {
        if (state is CircleRecitationsFailureState) {
          AppToast.error(context, state.errMessage);
        }
      },
      child: RefreshIndicator(
        color: AppColor.primary,
        onRefresh: () => cubit.loadRecitations(circleId: widget.circleId),
        child: ListView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RecitationsFilterButton(
                  isActive: cubit.hasActiveFilter,
                  onTap: () => _openFilterSheet(cubit),
                ),
                ExportReportButton(
                  circleId: widget.circleId,
                  circleName: widget.circleName,
                ),
              ],
            ),

            SizedBox(height: 28.h),

            ..._buildContent(context, cubit.state, cubit.hasActiveFilter),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent(
    BuildContext context,
    CircleRecitationsState state,
    bool hasActiveFilter,
  ) {
    if (state is CircleRecitationsInitialState ||
        state is CircleRecitationsLoadingState) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 60.h),
          child: Center(
            child: CircularProgressIndicator(color: AppColor.primary),
          ),
        ),
      ];
    }

    if (state is CircleRecitationsLoadMoreState) {
      return [
        ...state.currentItems.map((r) => RecitationCard(recitation: r)),
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
      ];
    }

    if (state is CircleRecitationsSuccessState) {
      if (state.items.isEmpty) {
        return [RecitationsEmptyState(isFiltered: hasActiveFilter)];
      }
      return state.items.map((r) => RecitationCard(recitation: r)).toList();
    }

    if (state is CircleRecitationsFailureState) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 60.h),
          child: Center(
            child: Text(
              state.errMessage,
              style: AppTextStyle.bodyMd(
                context,
              ).copyWith(color: AppColor.error),
            ),
          ),
        ),
      ];
    }

    return [];
  }
}
