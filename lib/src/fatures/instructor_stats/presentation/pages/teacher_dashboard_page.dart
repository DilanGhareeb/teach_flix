import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:teach_flix/src/fatures/courses/presentation/pages/create_course_page.dart';
import 'package:teach_flix/src/fatures/instructor_stats/presentation/widgets/dashboard_stat_card.dart';
import 'package:teach_flix/src/fatures/instructor_stats/presentation/widgets/instructor_course_card.dart';
import 'package:teach_flix/src/fatures/instructor_stats/presentation/widgets/profit_card.dart';

import 'package:teach_flix/src/l10n/app_localizations.dart';

class TeacherDashboardPage extends StatelessWidget {
  const TeacherDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // TODO: Replace with actual data from BLoC
    final todayProfit = 25000.0;
    final monthProfit = 450000.0;
    final yearProfit = 3200000.0;
    final totalProfit = 5600000.0;

    final totalCourses = 5; // TODO: Get from BLoC
    final totalStudents = 127; // TODO: Get from BLoC

    // TODO: Replace with actual courses from BLoC
    final instructorCourses = [
      // Mock data - replace with actual CourseEntity list
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.instructor_dashboard,
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.manage_your_courses,
                      style: textTheme.bodyMedium?.copyWith(
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Stats Cards
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: DashboardStatCard(
                        title: t.total_courses,
                        value: totalCourses.toString(),
                        icon: Icons.school_rounded,
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DashboardStatCard(
                        title: t.total_students,
                        value: totalStudents.toString(),
                        icon: Icons.people_rounded,
                        color: cs.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Profit Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ProfitCard(
                  todayProfit: todayProfit,
                  monthProfit: monthProfit,
                  yearProfit: yearProfit,
                  totalProfit: totalProfit,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Courses Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.courses,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    FloatingActionButton.small(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => const CreateCoursePage(),
                          ),
                        );
                      },
                      elevation: 2,
                      backgroundColor: cs.primary,
                      child: Icon(Icons.add_rounded, color: cs.onPrimary),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Courses List
            if (instructorCourses.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cs.outline.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 64,
                          color: cs.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          t.no_courses_yet ?? 'No courses yet',
                          style: textTheme.titleMedium?.copyWith(
                            color: cs.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          t.create_your_first_course ??
                              'Create your first course to get started',
                          style: textTheme.bodyMedium?.copyWith(
                            color: cs.onSurface.withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (_) => const CreateCoursePage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_rounded),
                          label: Text(t.create_course),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final course = instructorCourses[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InstructorCourseCard(
                        course: course,
                        onTap: () {
                          // TODO: Navigate to edit course page
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (_) => EditCoursePage(course: course),
                          //   ),
                          // );
                        },
                      ),
                    );
                  }, childCount: instructorCourses.length),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
