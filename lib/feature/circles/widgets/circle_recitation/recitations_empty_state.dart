// recitations_empty_state.dart

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';

class RecitationsEmptyState extends StatelessWidget {
  final bool isFiltered;

  const RecitationsEmptyState({super.key, required this.isFiltered});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 56.sp,
            color: AppColor.outlineVariant,
          ),
          SizedBox(height: 12.h),
          Text(
            isFiltered
                ? 'لا توجد تسميعات ضمن هذه الفترة'
                : 'لا توجد تسميعات بعد',
            style: AppTextStyle.bodyMd(
              context,
            ).copyWith(color: AppColor.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
