import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/fatures/common/error_localizer.dart';
import 'package:teach_flix/src/fatures/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/fatures/courses/presentation/widgets/category_selector.dart';
import 'package:teach_flix/src/fatures/courses/presentation/widgets/horizontal_course_list.dart';
import 'package:teach_flix/src/fatures/courses/presentation/pages/course_detail_page.dart';
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
  bool _isSearching = false;

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

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (query.isNotEmpty) {
      context.read<CoursesBloc>().add(SearchCoursesEvent(query));
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

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category == 'all' ? null : category);

    if (category == 'all') {
      context.read<CoursesBloc>().add(LoadCoursesEvent());
    } else {
      context.read<CoursesBloc>().add(LoadCoursesByCategoryEvent(category));
    }
  }

  void _clearSearch() {
    _searchController.clear();
  }

  void _onCourseTap(course) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CourseDetailPage(course: course),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
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
                          builder: (context, authState) {
                            final user = authState.user;
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
                                        (user?.profilePictureUrl != null &&
                                            user!.profilePictureUrl!.isNotEmpty)
                                        ? CachedNetworkImageProvider(
                                            user.profilePictureUrl!,
                                          )
                                        : null,
                                    child:
                                        (user?.profilePictureUrl == null ||
                                            user!.profilePictureUrl!.isEmpty)
                                        ? Image.asset(
                                            'assets/images/profile.png',
                                            fit: BoxFit.cover,
                                          )
                                        : null,
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
                              ],
                            );
                          },
                        ),
                      ),
                    ),

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

                    if (!_isSearching)
                      SliverToBoxAdapter(
                        child: CategorySelector(
                          selectedCategory: _selectedCategory,
                          onCategorySelected: _onCategorySelected,
                        ),
                      ),

                    if (!_isSearching)
                      const SliverToBoxAdapter(child: SizedBox(height: 24)),

                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _isSearching ? t.search_results : t.courses,
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 16)),

                    SliverToBoxAdapter(
                      child: BlocBuilder<CoursesBloc, CoursesState>(
                        builder: (context, state) {
                          if (state.status == CoursesStatus.loading &&
                              state.courses == null) {
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
                                      _isSearching ? t.searching : t.loading,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (state.courses != null &&
                              state.courses!.isNotEmpty) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: HorizontalCourseList(
                                key: ValueKey(state.courses!.length),
                                courses: state.courses!,
                                onCourseTap: _onCourseTap,
                              ),
                            );
                          }

                          if (state.courses != null && state.courses!.isEmpty) {
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
                                      _isSearching
                                          ? Icons.search_off_rounded
                                          : Icons.school_outlined,
                                      size: 48,
                                      color: colorScheme.onSurface.withOpacity(
                                        0.4,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _isSearching
                                          ? t.no_results_found
                                          : t.no_courses_found,
                                      style: textTheme.titleMedium?.copyWith(
                                        color: colorScheme.onSurface
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _isSearching
                                          ? t.try_different_search
                                          : t.try_different_search_or_category,
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

                          if (state.status == CoursesStatus.failure &&
                              state.failure != null) {
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
                                        ErrorLocalizer.of(state.failure!, t),
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
