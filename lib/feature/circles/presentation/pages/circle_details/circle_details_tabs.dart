import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/circles/presentation/pages/circle_details/attendance_sessions_tab.dart';
import 'package:masjid/feature/circles/presentation/pages/circle_details/students_tab.dart';
import 'package:masjid/feature/circles/presentation/pages/circle_recitations_tab.dart';

class CircleDetailsTabs extends StatelessWidget {
  final TabController tabController;
  final int circleId;

  const CircleDetailsTabs({
    super.key,
    required this.tabController,
    required this.circleId,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            color: AppColor.surfaceContainerLowest,
            child: TabBar(
              controller: tabController,
              labelColor: AppColor.primary,
              unselectedLabelColor: AppColor.outline,
              indicatorColor: AppColor.primaryContainer,
              indicatorWeight: 3,
              labelStyle: AppTextStyle.labelLg(context, null, null),
              tabs: const [
                Tab(text: 'جلسات الحضور'),
                Tab(text: 'الطلاب'),
                Tab(text: 'تسميع'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                AttendanceSessionsTab(circleId: circleId),
                StudentsTab(circleId: circleId),
                CircleRecitationsTab(circleId: circleId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
