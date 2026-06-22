// recitation_card.dart

import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/feature/circles/data_source/model/circle_recitation_model.dart';
import 'package:masjid/feature/circles/widgets/circle_recitation/surah_name_lookup.dart';

import 'recitation_rating_badge.dart';

class RecitationCard extends StatelessWidget {
  final CircleRecitationModel recitation;

  const RecitationCard({super.key, required this.recitation});

  Color get _borderColor {
    switch (recitation.rating) {
      case 'excellent':
        return AppColor.tertiaryContainer;
      case 'very_good':
        return AppColor.secondary;
      default:
        return AppColor.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border(
          right: BorderSide(color: _borderColor, width: 4.w),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryContainer.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recitation.student.fullName,
                      style: AppTextStyle.headlineMd(
                        context,
                      ).copyWith(color: AppColor.primary, fontSize: 18.sp),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'المعلم: ${recitation.teacher.name}',
                      style: AppTextStyle.bodyMd(context).copyWith(
                        color: AppColor.onSurfaceVariant,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              RecitationRatingBadge(rating: recitation.rating),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 6.h,
            children: [
              _InfoChip(
                icon: recitation.isPages
                    ? Icons.menu_book_rounded
                    : Icons.auto_stories_rounded,
                label: recitation.isPages ? 'تسميع صفحات' : 'تسميع سورة',
              ),
              if (recitation.isPages)
                _InfoChip(
                  icon: Icons.format_list_numbered_rounded,
                  label:
                      'من صفحة ${recitation.fromPage} إلى ${recitation.toPage}',
                ),
              if (recitation.isSurah)
                _InfoChip(
                  icon: Icons.description_outlined,
                  label: 'سورة ${SurahNameLookup.nameOf(recitation.surahId)}',
                ),
              _InfoChip(
                icon: Icons.calendar_today_rounded,
                label: recitation.recitedAt,
              ),
            ],
          ),
          if (recitation.notes != null &&
              recitation.notes!.trim().isNotEmpty) ...[
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.only(top: 10.h),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColor.surfaceContainer),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.notes_rounded,
                    size: 16.sp,
                    color: AppColor.onSurfaceVariant,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      recitation.notes!,
                      style: AppTextStyle.labelLg(
                        context,
                        AppColor.onSurfaceVariant,
                        13,
                      ).copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15.sp, color: AppColor.onSurfaceVariant),
        SizedBox(width: 5.w),
        Text(
          label,
          style: AppTextStyle.bodyMd(
            context,
          ).copyWith(color: AppColor.onSurfaceVariant, fontSize: 13.sp),
        ),
      ],
    );
  }
}
