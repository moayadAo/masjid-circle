// surah_picker_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';
import 'package:masjid/feature/recitation_form/presentation/widgets/surah_grid_item.dart';
import 'package:masjid/feature/recitation_form/presentation/widgets/surah_search_field.dart';

import '../../../../core/design_app/spacing_system/icon_sizes.dart';
import '../../../../core/design_app/spacing_system/radius.dart';
import '../../../../core/design_app/spacing_system/spacing.dart';
import '../../../../core/design_app/typography/style_app.dart';
import '../../../../core/di/service_locator.dart';
import '../../data/models/surah_model.dart';
import '../../data/remote/surah_local_service.dart';

/// Shows the Surah picker as a modal bottom sheet and returns the
/// selected [SurahModel], or null if dismissed without a selection.
Future<SurahModel?> showSurahPickerBottomSheet(
  BuildContext context, {
  SurahModel? currentSurah,
}) {
  return showModalBottomSheet<SurahModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SurahPickerBottomSheet(currentSurah: currentSurah),
  );
}

class SurahPickerBottomSheet extends StatefulWidget {
  final SurahModel? currentSurah;

  const SurahPickerBottomSheet({super.key, this.currentSurah});

  @override
  State<SurahPickerBottomSheet> createState() => _SurahPickerBottomSheetState();
}

class _SurahPickerBottomSheetState extends State<SurahPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  List<SurahModel> _allSurahs = [];
  List<SurahModel> _filteredSurahs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSurahs();
  }

  Future<void> _loadSurahs() async {
    final surahs = await getIt<SurahLocalService>().getSurahs();
    setState(() {
      _allSurahs = surahs;
      _filteredSurahs = surahs;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    final trimmed = query.trim();
    setState(() {
      _filteredSurahs = trimmed.isEmpty
          ? _allSurahs
          : _allSurahs
              .where((s) => s.nameAr.contains(trimmed))
              .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md.w,
            AppSpacing.md.h,
            AppSpacing.md.w,
            AppSpacing.md.h,
          ),
          decoration: BoxDecoration(
            color: AppColor.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl.r),
            ),
          ),
          child: Column(
            children: [
              _Header(),
              AppSpacing.md.sbH,
              SurahSearchField(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
              AppSpacing.md.sbH,
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        controller: scrollController,
                        itemCount: _filteredSurahs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: AppSpacing.sm.h,
                          crossAxisSpacing: AppSpacing.sm.w,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final surah = _filteredSurahs[index];
                          final isSelected =
                              surah.id == widget.currentSurah?.id;

                          return SurahGridItem(
                            surah: surah,
                            isSelected: isSelected,
                            onTap: () => Navigator.pop(context, surah),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(
            Icons.close_rounded,
            color: AppColor.outline,
            size: AppIconSize.md.sp,
          ),
        ),
        Expanded(
          child: Text(
            'اختر السورة',
            textAlign: TextAlign.center,
            style: AppTextStyle.headlineMd(context).copyWith(fontSize: 18.sp),
          ),
        ),
        SizedBox(width: AppIconSize.md.sp),
      ],
    );
  }
}
