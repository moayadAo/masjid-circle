import 'package:flutter/material.dart';

import 'package:masjid/feature/circles/presentation/pages/circle_details/circle_details_view.dart';

class CircleDetailsPage extends StatelessWidget {
  final int circleId;
  final String circleName;

  const CircleDetailsPage({
    super.key,
    required this.circleId,
    required this.circleName,
  });

  @override
  Widget build(BuildContext context) {
    return CircleDetailsView(
      circleId: circleId,
      circleName: circleName,
    );
  }
}
