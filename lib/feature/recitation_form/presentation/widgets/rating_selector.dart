// rating_selector.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/feature/recitation_form/presentation/widgets/rating_option_card.dart';

import '../../../../core/design_app/spacing_system/spacing.dart';
import '../../../../core/design_app/typography/style_app.dart';
import '../cubit/recitation_form_state.dart';

class RatingSelector extends StatelessWidget {
  final RecitationRating? selected;
  final ValueChanged<RecitationRating> onChanged;

  const RatingSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التقييم',
          style: AppTextStyle.labelLg(context, null, 14.sp),
        ),
        AppSpacing.sm.sbH,
        Row(
          children: [
            Expanded(
              child: RatingOptionCard(
                icon: Icons.check_circle_outline_rounded,
                label: 'جيد',
                isSelected: selected == RecitationRating.good,
                onTap: () => onChanged(RecitationRating.good),
              ),
            ),
            AppSpacing.sm.sbW,
            Expanded(
              child: RatingOptionCard(
                icon: Icons.thumb_up_alt_outlined,
                label: 'جيد جداً',
                isSelected: selected == RecitationRating.veryGood,
                onTap: () => onChanged(RecitationRating.veryGood),
              ),
            ),
            AppSpacing.sm.sbW,
            Expanded(
              child: RatingOptionCard(
                icon: Icons.star_rounded,
                label: 'ممتاز',
                isSelected: selected == RecitationRating.excellent,
                onTap: () => onChanged(RecitationRating.excellent),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
