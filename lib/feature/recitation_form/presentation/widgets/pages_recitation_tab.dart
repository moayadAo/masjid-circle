// pages_recitation_tab.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/feature/recitation_form/presentation/widgets/page_counter_field.dart';

import '../../../../core/design_app/spacing_system/spacing.dart';

class PagesRecitationTab extends StatelessWidget {
  final int fromPage;
  final int toPage;
  final VoidCallback onFromIncrement;
  final VoidCallback onFromDecrement;
  final VoidCallback onToIncrement;
  final VoidCallback onToDecrement;

  const PagesRecitationTab({
    super.key,
    required this.fromPage,
    required this.toPage,
    required this.onFromIncrement,
    required this.onFromDecrement,
    required this.onToIncrement,
    required this.onToDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageCounterField(
          label: 'من صفحة',
          value: fromPage,
          onIncrement: onFromIncrement,
          onDecrement: onFromDecrement,
        ),
        AppSpacing.md.sbH,
        PageCounterField(
          label: 'إلى صفحة',
          value: toPage,
          onIncrement: onToIncrement,
          onDecrement: onToDecrement,
        ),
      ],
    );
  }
}
