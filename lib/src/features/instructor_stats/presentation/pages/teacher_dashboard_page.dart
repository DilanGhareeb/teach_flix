import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/courses_bloc.dart'; // Import CoursesBloc
import 'package:teach_flix/src/features/courses/presentation/pages/create_course_page.dart';
import 'package:teach_flix/src/features/instructor_stats/presentation/bloc/instructor_stats_bloc.dart';
import 'package:teach_flix/src/features/instructor_stats/presentation/widgets/dashboard_stat_card.dart';
import 'package:teach_flix/src/features/instructor_stats/presentation/widgets/instructor_course_card.dart';
import 'package:teach_flix/src/features/instructor_stats/presentation/widgets/profit_card.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class TeacherDashboardPage extends StatefulWidget {
  const TeacherDashboardPage({super.key});

  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  @override
  bool get wantKeepAlive => true;

  bool _isInitialized = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized && !_isDisposed) {
      _isInitialized = true;
      _startWatching();
    }
  }

  void _startWatching() {
    if (_isDisposed) return;

    try {
      final authState = context.read<AuthBloc>().state;
      final instructorId = authState.user?.id ?? '';

      if (instructorId.isNotEmpty && mounted && !_isDisposed) {
        context.read<InstructorStatsBloc>().add(
          InstructorStatsWatchStarted(instructorId),
        );
      }
    } catch (e) {
      // Safely handle any bloc access errors
      debugPrint('Error starting stats watch: $e');
    }
  }

  void _stopWatching() {
    if (_isDisposed) return;

    try {
      if (mounted) {
        context.read<InstructorStatsBloc>().add(InstructorStatsWatchStopped());
      }
    } catch (e) {
      // Safely handle any bloc access errors
      debugPrint('Error stopping stats watch: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isDisposed) return;

    if (state == AppLifecycleState.paused) {
      // Stop watching when app goes to background
      _stopWatching();
    } else if (state == AppLifecycleState.resumed) {
      // Resume watching when app comes back
      if (_isInitialized && !_isDisposed) {
        _startWatching();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _stopWatching();
    super.dispose();
  }

  // NEW: Method to handle course tap using CoursesBloc
  void _handleCourseTap(String courseId) {
    if (_isDisposed || !mounted) return;

    // Dispatch event to load course details
    context.read<CoursesBloc>().add(LoadCourseDetailEvent(courseId));

    // Listen for the course detail loaded state and navigate
    _navigateToCourseEdit();
  }

  // NEW: Method to listen for course detail loading and navigate
  void _navigateToCourseEdit() {
    // We'll use a listener pattern to handle the navigation
    // This ensures we navigate only when the course is successfully loaded
    Future.delayed(Duration.zero, () {
      final coursesState = context.read<CoursesBloc>().state;

      if (coursesState.status == CoursesStatus.courseDetailLoaded &&
          coursesState.selectedCourse != null) {
        // Navigate to CreateCoursePage with the loaded course
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) =>
                CreateCoursePage(existingCourse: coursesState.selectedCourse!),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isDisposed) {
      return const SizedBox.shrink();
    }

    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            // NEW: Listen for course detail loading states
            BlocListener<CoursesBloc, CoursesState>(
              listener: (context, coursesState) {
                if (coursesState.status == CoursesStatus.courseDetailLoaded &&
                    coursesState.selectedCourse != null) {
                  // Navigate when course is loaded
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && !_isDisposed) {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (_) => CreateCoursePage(
                            existingCourse: coursesState.selectedCourse!,
                          ),
                        ),
                      );
                    }
                  });
                } else if (coursesState.status == CoursesStatus.failure) {
                  // Show error if loading fails
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && !_isDisposed) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to load course details: ${coursesState.failure?.code ?? 'Unknown error'}',
                          ),
                          backgroundColor: cs.error,
                        ),
                      );
                    }
                  });
                }
              },
            ),
          ],
          child: BlocBuilder<InstructorStatsBloc, InstructorStatsState>(
            builder: (context, state) {
              if (state.isLoading && !state.hasStats) {
                return _buildLoadingState(context);
              }

              if (state.isFailure && !state.hasStats) {
                return _buildErrorState(context, state.errorMessage);
              }

              final stats = state.stats;
              if (stats == null) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  if (_isDisposed) return;

                  final authState = context.read<AuthBloc>().state;
                  final instructorId = authState.user?.id ?? '';

                  if (instructorId.isNotEmpty && mounted && !_isDisposed) {
                    context.read<InstructorStatsBloc>().add(
                      InstructorStatsLoadRequested(instructorId),
                    );
                  }
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    // Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        t.instructor_dashboard,
                                        style: textTheme.headlineLarge
                                            ?.copyWith(
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
                                if (state.isWatching)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: cs.primaryContainer,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.wifi,
                                          size: 16,
                                          color: cs.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Live',
                                          style: textTheme.labelSmall?.copyWith(
                                            color: cs.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
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
                                value: stats.totalCourses.toString(),
                                icon: Icons.school_rounded,
                                color: cs.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DashboardStatCard(
                                title: t.total_students,
                                value: stats.totalStudents.toString(),
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
                          todayProfit: stats.todayProfit,
                          monthProfit: stats.monthProfit,
                          yearProfit: stats.yearProfit,
                          totalProfit: stats.totalProfit,
                          last30DaysProfits: stats.last30DaysProfits,
                          last12MonthsProfits: stats.last12MonthsProfits,
                          allTimeProfits: stats.allTimeProfits,
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
                                if (_isDisposed || !mounted) return;

                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (_) => const CreateCoursePage(),
                                  ),
                                );
                              },
                              elevation: 2,
                              backgroundColor: cs.primary,
                              child: Icon(
                                Icons.add_rounded,
                                color: cs.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // Courses List
                    if (stats.courseStats.isEmpty)
                      SliverToBoxAdapter(
                        child: _buildEmptyCoursesState(context),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final course = stats.courseStats[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InstructorCourseCard(
                                courseStats: course,
                                onTap: () => _handleCourseTap(course.courseId),
                              ),
                            );
                          }, childCount: stats.courseStats.length),
                        ),
                      ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(BuildContext context, String? errorMessage) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64, color: cs.error),
            const SizedBox(height: 16),
            Text(
              t.error_loading_stats ?? 'Error loading stats',
              style: textTheme.titleLarge?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? t.unknown_error ?? 'Unknown error occurred',
              style: textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                if (_isDisposed || !mounted) return;

                final authState = context.read<AuthBloc>().state;
                final instructorId = authState.user?.id ?? '';

                if (instructorId.isNotEmpty) {
                  context.read<InstructorStatsBloc>().add(
                    InstructorStatsLoadRequested(instructorId),
                  );
                }
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(t.try_again ?? 'Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insights_rounded,
              size: 64,
              color: cs.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              t.no_stats_yet ?? 'No stats available',
              style: textTheme.titleLarge?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCoursesState(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
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
                if (_isDisposed || !mounted) return;

                Navigator.of(context).push(
                  CupertinoPageRoute(builder: (_) => const CreateCoursePage()),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: Text(t.create_course),
            ),
          ],
        ),
      ),
    );
  }
}
