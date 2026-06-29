import 'package:flutter/material.dart';
import 'package:masjid/feature/circles/presentation/pages/circle_details/circle_details_banner.dart';
import 'package:masjid/feature/circles/presentation/pages/circle_details/circle_details_tabs.dart';

class CircleDetailsBody extends StatelessWidget {
  final TabController tabController;
  final int circleId;
  final String circleName;

  const CircleDetailsBody({
    super.key,
    required this.tabController,
    required this.circleName,
    required this.circleId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleDetailsBanner(),
        CircleDetailsTabs(
          tabController: tabController,
          circleId: circleId,
          circleName: circleName,
        ),
      ],
    );
  }
}
