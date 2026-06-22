import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_sessions_cubit.dart';
import 'package:masjid/feature/attendance/presentation/cubit/attendance_sessions_state.dart';
import 'package:masjid/feature/attendance/widgets/add_session_bottom_sheet.dart';
import 'package:masjid/feature/circles/presentation/cubit/circles_cubit.dart';
import 'package:masjid/feature/circles/presentation/pages/circle_details/circle_details_action_button.dart';
import 'package:masjid/feature/circles/presentation/pages/circle_details/circle_details_app_bar.dart';
import 'package:masjid/feature/circles/presentation/pages/circle_details/circle_details_body.dart';
import 'package:masjid/routing/app_router.dart';

class CircleDetailsView extends StatefulWidget {
  final int circleId;
  final String circleName;

  const CircleDetailsView({
    super.key,
    required this.circleId,
    required this.circleName,
  });

  @override
  State<CircleDetailsView> createState() => _CircleDetailsViewState();
}

class _CircleDetailsViewState extends State<CircleDetailsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _hasLoadedStudents = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_onTabChanged);

    context.read<AttendanceSessionsCubit>().loadSessions(
      circleId: widget.circleId,
    );
  }

  void _onTabChanged() {
    if (_tabController.index == 1 && !_hasLoadedStudents) {
      _hasLoadedStudents = true;
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

    final cubitState = context.read<AttendanceSessionsCubit>().state;
    if (cubitState is OpenSessionSuccessState) {
      await context.push(
        Routes.attendanceSessionPath(cubitState.session.id),
        extra: cubitState.session,
      );

      if (!mounted) {
        return;
      }

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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CircleDetailsAppBar(circleName: widget.circleName),
        body: CircleDetailsBody(
          tabController: _tabController,
          circleId: widget.circleId,
        ),
        floatingActionButton: CircleDetailsActionButton(
          isVisible: _tabController.index == 0,
          onPressed: _showAddSessionSheet,
        ),
      ),
    );
  }
}
