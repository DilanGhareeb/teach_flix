import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:teach_flix/src/config/app_theme.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_state.dart';
import 'package:teach_flix/src/features/common/presentation/pages/dashboard_page.dart';
import 'package:teach_flix/src/features/courses/presentation/pages/my_course_page.dart';
import 'package:teach_flix/src/features/instructor_stats/presentation/pages/teacher_dashboard_page.dart';
import 'package:teach_flix/src/features/live_conference/presentation/pages/active_conferences_page.dart';
import 'package:teach_flix/src/features/settings/presentation/pages/settings_page.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pageCtrl = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  List<Widget> _getPages(bool isTeacher) {
    if (isTeacher) {
      return const [
        DashboardPage(),
        MyCoursesPage(),
        ActiveConferencesPage(),
        TeacherDashboardPage(),
        SettingsPage(),
      ];
    } else {
      return const [
        DashboardPage(),
        MyCoursesPage(),
        ActiveConferencesPage(),
        SettingsPage(),
      ];
    }
  }

  List<SalomonBottomBarItem> _getBottomBarItems(
    BuildContext context,
    bool isTeacher,
  ) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final languageCode = Localizations.localeOf(context).languageCode;

    List<SalomonBottomBarItem> items = [
      // Dashboard
      SalomonBottomBarItem(
        icon: const Icon(Icons.dashboard_rounded),
        title: Text(
          t.dashboard,
          style: TextStyle(fontFamily: AppTheme.getFontFamily(languageCode)),
        ),
        selectedColor: cs.primary,
      ),
      // Courses
      SalomonBottomBarItem(
        icon: const Icon(Icons.school_rounded),
        title: Text(
          t.courses,
          style: TextStyle(fontFamily: AppTheme.getFontFamily(languageCode)),
        ),
        selectedColor: Colors.blue,
      ),
      // Live
      SalomonBottomBarItem(
        icon: const Icon(Icons.live_tv_rounded),
        title: Text(
          t.live,
          style: TextStyle(fontFamily: AppTheme.getFontFamily(languageCode)),
        ),
        selectedColor: Colors.red,
      ),
    ];

    // Add teacher-only tab
    if (isTeacher) {
      items.add(
        SalomonBottomBarItem(
          icon: const Icon(Icons.analytics_rounded),
          title: Text(
            t.instructor,
            style: TextStyle(fontFamily: AppTheme.getFontFamily(languageCode)),
          ),
          selectedColor: Colors.purple,
        ),
      );
    }

    // Settings (always last)
    items.add(
      SalomonBottomBarItem(
        icon: const Icon(Icons.settings_rounded),
        title: Text(
          t.settings,
          style: TextStyle(fontFamily: AppTheme.getFontFamily(languageCode)),
        ),
        selectedColor: Colors.teal,
      ),
    );

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // Check if user is a teacher/instructor
        final isTeacher =
            authState.user?.role.name.toLowerCase() == 'teacher' ||
            authState.user?.role.name.toLowerCase() == 'instructor';

        final pages = _getPages(isTeacher);
        final bottomBarItems = _getBottomBarItems(context, isTeacher);

        // Reset index if it's out of bounds (can happen when switching between teacher/student)
        if (_index >= pages.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _index = 0);
            _pageCtrl.jumpToPage(0);
          });
        }

        return Scaffold(
          body: PageView(
            controller: _pageCtrl,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (i) => setState(() => _index = i),
            children: pages,
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SalomonBottomBar(
              backgroundColor:
                  Theme.of(context).appBarTheme.backgroundColor ?? cs.surface,
              itemPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              itemShape: const StadiumBorder(),
              currentIndex: _index,
              onTap: (i) {
                final difference = (i - _index).abs();
                if (difference > 1) {
                  _pageCtrl.jumpToPage(i);
                  return setState(() => _index = i);
                }
                setState(() => _index = i);
                _pageCtrl.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                );
              },
              selectedItemColor: cs.primary,
              unselectedItemColor: cs.onSurfaceVariant,
              items: bottomBarItems,
            ),
          ),
        );
      },
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
