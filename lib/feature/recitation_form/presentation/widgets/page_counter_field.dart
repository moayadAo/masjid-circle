// page_counter_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masjid/core/design_app/screen_util_ext/screen_util_ext.dart';
import 'package:masjid/core/design_app/theme/app_colors.dart';

import '../../../../core/design_app/spacing_system/icon_sizes.dart';
import '../../../../core/design_app/spacing_system/radius.dart';
import '../../../../core/design_app/spacing_system/spacing.dart';
import '../../../../core/design_app/typography/style_app.dart';

class PageCounterField extends StatefulWidget {
  final String label;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final ValueChanged<int> onManualChanged;

  const PageCounterField({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    required this.onManualChanged,
  });

  @override
  State<PageCounterField> createState() => _PageCounterFieldState();
}

class _PageCounterFieldState extends State<PageCounterField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(covariant PageCounterField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep internal text state aligned with state changes from outer cubit incrementers
    if (widget.value.toString() != _controller.text && !_focusNode.hasFocus) {
      _controller.text = widget.value.toString();
    }
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CounterButton(icon: Icons.remove_rounded, onTap: widget.onDecrement),
              Container(
                width: 72.w, // Extended width comfort for large numbers
                height: 36.h,
                margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.sm.r),
                  border: Border.all(color: AppColor.border),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLines: 1,
                  style: AppTextStyle.labelLg(context, null, 16.sp),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 6),
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    final parsed = int.tryParse(text) ?? 1;
                    widget.onManualChanged(parsed);
                  },
                ),
              ),
              _CounterButton(icon: Icons.add_rounded, onTap: widget.onIncrement),
            ],
          ),
        ),
        Text(
          widget.label,
          style: AppTextStyle.labelLg(context, null, 15.sp),
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CounterButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm.r),
      child: Container(
        width: 36.w,
        height: 36.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(AppRadius.sm.r),
        ),
        child: Icon(icon, color: AppColor.onPrimary, size: AppIconSize.sm.sp),
      ),
    );
  }
}