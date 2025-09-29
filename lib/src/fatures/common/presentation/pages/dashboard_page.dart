import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/fatures/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/fatures/courses/presentation/widgets/category_selector.dart';
import 'package:teach_flix/src/fatures/courses/presentation/widgets/horizontal_course_list.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  String? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(LoadCoursesEvent());

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category == 'all' ? null : category);

    if (category == 'all') {
      context.read<CoursesBloc>().add(LoadCoursesEvent());
    } else {
      context.read<CoursesBloc>().add(LoadCoursesByCategoryEvent(category));
    }
  }

  void _onSearch(String query) {
    final q = query.trim();
    if (q.isNotEmpty) {
      context.read<CoursesBloc>().add(SearchCoursesEvent(q));
    } else {
      if (_selectedCategory == null) {
        context.read<CoursesBloc>().add(LoadCoursesEvent());
      } else {
        context.read<CoursesBloc>().add(
          LoadCoursesByCategoryEvent(_selectedCategory!),
        );
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearch('');
  }

  void _onCourseTap(course) {
    // Navigate to course details or preview
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final isRtl = ['ckb', 'ar', 'fa', 'ur', 'he'].contains(locale.languageCode);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<CoursesBloc>().add(RefreshCoursesEvent());
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Header Section
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primaryContainer,
                              colorScheme.secondaryContainer,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final user = state.user;
                            return Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.primary.withOpacity(
                                        0.3,
                                      ),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary.withOpacity(
                                          0.2,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        user?.profilePictureUrl != null
                                        ? NetworkImage(user!.profilePictureUrl!)
                                        : const AssetImage(
                                                'assets/images/profile.png',
                                              )
                                              as ImageProvider,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${t.welcome_back ?? 'Welcome back'},',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onPrimaryContainer
                                              .withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user?.name ?? t.anonymous,
                                        style: textTheme.headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primary
                                              .withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          user?.role.name ?? "student",
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.notifications_outlined,
                                      color: colorScheme.primary,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    // Search Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.shadow.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: _onSearch,
                            onChanged: (value) {
                              if (value.isEmpty) {
                                _onSearch('');
                              }
                            },
                            decoration: InputDecoration(
                              hintText: t.search_courses,
                              hintStyle: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: colorScheme.primary,
                                size: 24,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear_rounded,
                                        color: colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                      onPressed: _clearSearch,
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),

                    // Category Selector
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CategorySelector(
                          selectedCategory: _selectedCategory,
                          onCategorySelected: _onCategorySelected,
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),

                    // Courses Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.courses,
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                context.read<CoursesBloc>().add(
                                  RefreshCoursesEvent(),
                                );
                              },
                              icon: Icon(
                                Icons.refresh_rounded,
                                size: 18,
                                color: colorScheme.primary,
                              ),
                              label: Text(
                                t.refresh,
                                style: TextStyle(color: colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    // Courses Content
                    SliverToBoxAdapter(
                      child: BlocBuilder<CoursesBloc, CoursesState>(
                        builder: (context, state) {
                          if (state is CoursesLoading) {
                            return Container(
                              height: 200,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest
                                    .withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      color: colorScheme.primary,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      t.loading,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (state is CoursesLoaded) {
                            if (state.courses.isEmpty) {
                              return Container(
                                height: 200,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.surfaceContainerHighest
                                      .withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: colorScheme.outline.withOpacity(0.2),
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.school_outlined,
                                        size: 48,
                                        color: colorScheme.onSurface
                                            .withOpacity(0.4),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        t.no_courses_found,
                                        style: textTheme.titleMedium?.copyWith(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        t.try_different_search_or_category,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurface
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: HorizontalCourseList(
                                key: ValueKey(state.courses.length),
                                courses: state.courses,
                                onCourseTap: _onCourseTap,
                              ),
                            );
                          } else if (state is CoursesError) {
                            return Container(
                              height: 200,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.errorContainer.withOpacity(
                                  0.1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: colorScheme.error.withOpacity(0.3),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 48,
                                      color: colorScheme.error,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Oops! Something went wrong',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: colorScheme.error,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                      ),
                                      child: Text(
                                        state.message,
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onErrorContainer,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        context.read<CoursesBloc>().add(
                                          RefreshCoursesEvent(),
                                        );
                                      },
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Try Again'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorScheme.error,
                                        foregroundColor: colorScheme.onError,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
