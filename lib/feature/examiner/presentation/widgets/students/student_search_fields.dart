import 'package:masjid/core/constant/export_theme_files.dart';

class ManualCodeField extends StatelessWidget {
  final ValueChanged<String> onSubmitted;

  const ManualCodeField({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return _RoundedField(
      icon: Icons.keyboard_rounded,
      hint: 'كود الطالب (STU-XXXXX)',
      onSubmitted: onSubmitted,
    );
  }
}

class StudentNameSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const StudentNameSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _RoundedField(
      icon: Icons.search_rounded,
      hint: 'البحث باسم الطالب...',
      onChanged: onChanged,
    );
  }
}

class _RoundedField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const _RoundedField({
    required this.icon,
    required this.hint,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: TextField(
        textDirection: TextDirection.rtl,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColor.surfaceContainerLow,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColor.onSurfaceVariant),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
