import 'package:flutter/material.dart';
import 'package:masjid/core/constant/export_theme_files.dart';
import 'package:masjid/core/design_app/typography/style_app.dart';
import 'package:masjid/core/widgets/logout_confirm_dialog.dart';

import 'juz_exams_list_page.dart';
import 'mosque_students_page.dart';

class ExaminerHomePage extends StatefulWidget {
  const ExaminerHomePage({super.key});

  @override
  State<ExaminerHomePage> createState() => _ExaminerHomePageState();
}

class _ExaminerHomePageState extends State<ExaminerHomePage> {
  int _index = 0;

  static const _pages = [
    _NavTab(
      title: 'طلاب المسجد',
      icon: Icons.group_rounded,
      // Wrapped in Scaffold here only if it needs its own AppBar; the
      // mosque students content doesn't include one, so add one here.
    ),
    _NavTab(title: 'اختبارات الأجزاء', icon: Icons.quiz_rounded),
  ];
  Future<void> _handleLogoutPressed() async {
    final shouldLogout = await showLogoutConfirmDialog(context);
    if (!mounted || !shouldLogout) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: _index == 0
          ? AppBar(
              title: const Text('طلاب المسجد'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: AppColor.background),
                  onPressed: _handleLogoutPressed,
                ),
              ],
            )
          : null,
      body: IndexedStack(
        index: _index,
        children: const [MosqueStudentsPage(), JuzExamsListPage()],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: AppColor.surface,
        indicatorColor: AppColor.primaryFixed.withOpacity(0.4),
        destinations: _pages
            .map(
              (t) => NavigationDestination(icon: Icon(t.icon), label: t.title),
            )
            .toList(),
      ),
    );
  }
}

class _NavTab {
  final String title;
  final IconData icon;
  const _NavTab({required this.title, required this.icon});
}
