import 'package:flutter/material.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/chapter_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/video_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/fatures/courses/presentation/pages/add_video_page.dart';
import 'package:teach_flix/src/fatures/courses/presentation/pages/add_quiz_page.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class AddChapterPage extends StatefulWidget {
  final String courseId;
  final ChapterEntity? existingChapter;

  const AddChapterPage({
    super.key,
    required this.courseId,
    this.existingChapter,
  });

  @override
  State<AddChapterPage> createState() => _AddChapterPageState();
}

class _AddChapterPageState extends State<AddChapterPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  List<VideoEntity> _videos = [];
  List<QuizEntity> _quizzes = [];

  bool get isEditMode => widget.existingChapter != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _titleController.text = widget.existingChapter!.title;
      _videos = List.from(widget.existingChapter!.videosUrls);
      _quizzes = List.from(widget.existingChapter!.quizzes);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? t.edit_chapter : t.add_chapter),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _saveChapter,
            icon: const Icon(Icons.check_circle_rounded),
            label: Text(t.save),
            style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chapter Title
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: t.chapter_title,
                        hintText: t.enter_chapter_title,
                        prefixIcon: Icon(
                          Icons.title_rounded,
                          color: colorScheme.primary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest,
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return t.title_required;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Videos Section
                    _buildVideosSection(colorScheme, textTheme, t),

                    const SizedBox(height: 24),

                    // Quizzes Section
                    _buildQuizzesSection(colorScheme, textTheme, t),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosSection(
    ColorScheme colorScheme,
    TextTheme textTheme,
    AppLocalizations t,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.play_circle_rounded, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      t.videos,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_videos.length}',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _addVideo(),
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          if (_videos.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.video_library_outlined,
                      size: 48,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      t.no_videos_added,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _videos.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final video = _videos.removeAt(oldIndex);
                  _videos.insert(newIndex, video);
                });
              },
              itemBuilder: (context, index) {
                final video = _videos[index];
                return _buildVideoCard(
                  video,
                  index,
                  colorScheme,
                  key: ValueKey(video.id),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(
    VideoEntity video,
    int index,
    ColorScheme colorScheme, {
    required Key key,
  }) {
    final t = AppLocalizations.of(context)!;

    return Card(
      key: key,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.drag_handle_rounded,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          video.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Position: ${index + 1}',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
              onPressed: () => _editVideo(index),
              tooltip: t.edit,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: Colors.red[400]),
              onPressed: () => _removeVideo(index),
              tooltip: t.delete,
            ),
          ],
        ),
        onTap: () => _editVideo(index),
      ),
    );
  }

  Widget _buildQuizzesSection(
    ColorScheme colorScheme,
    TextTheme textTheme,
    AppLocalizations t,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.quiz_rounded, color: Colors.purple[700]),
                    const SizedBox(width: 8),
                    Text(
                      t.quizzes,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_quizzes.length}',
                        style: TextStyle(
                          color: Colors.purple[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => _addQuiz(),
                  icon: Icon(
                    Icons.add_circle_rounded,
                    color: Colors.purple[700],
                  ),
                ),
              ],
            ),
          ),

          if (_quizzes.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.quiz_outlined,
                      size: 48,
                      color: colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      t.no_quizzes_added,
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _quizzes.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final quiz = _quizzes.removeAt(oldIndex);
                  _quizzes.insert(newIndex, quiz);
                });
              },
              itemBuilder: (context, index) {
                final quiz = _quizzes[index];
                return _buildQuizCard(
                  quiz,
                  index,
                  colorScheme,
                  key: ValueKey(quiz.id),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildQuizCard(
    QuizEntity quiz,
    int index,
    ColorScheme colorScheme, {
    required Key key,
  }) {
    final t = AppLocalizations.of(context)!;

    return Card(
      key: key,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.drag_handle_rounded,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.purple.withOpacity(0.1),
              child: Icon(Icons.quiz_outlined, color: Colors.purple[700]),
            ),
          ],
        ),
        title: Text(
          quiz.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${quiz.questions.length} questions • ${quiz.timeLimit.inMinutes} min',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: Colors.purple[700]),
              onPressed: () => _editQuiz(index),
              tooltip: t.edit,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: Colors.red[400]),
              onPressed: () => _removeQuiz(index),
              tooltip: t.delete,
            ),
          ],
        ),
        onTap: () => _editQuiz(index),
      ),
    );
  }

  Future<void> _addVideo() async {
    final result = await Navigator.push<VideoEntity>(
      context,
      MaterialPageRoute(builder: (context) => const AddVideoPage()),
    );

    if (result != null) {
      setState(() {
        _videos.add(result);
      });
    }
  }

  Future<void> _editVideo(int index) async {
    final result = await Navigator.push<VideoEntity>(
      context,
      MaterialPageRoute(
        builder: (context) => AddVideoPage(existingVideo: _videos[index]),
      ),
    );

    if (result != null) {
      setState(() {
        _videos[index] = result;
      });
    }
  }

  Future<void> _addQuiz() async {
    final result = await Navigator.push<QuizEntity>(
      context,
      MaterialPageRoute(builder: (context) => const AddQuizPage()),
    );

    if (result != null) {
      setState(() {
        _quizzes.add(result);
      });
    }
  }

  Future<void> _editQuiz(int index) async {
    final result = await Navigator.push<QuizEntity>(
      context,
      MaterialPageRoute(
        builder: (context) => AddQuizPage(existingQuiz: _quizzes[index]),
      ),
    );

    if (result != null) {
      setState(() {
        _quizzes[index] = result;
      });
    }
  }

  void _removeVideo(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete_video),
        content: Text(AppLocalizations.of(context)!.delete_video_confirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _videos.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _removeQuiz(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete_quiz),
        content: Text(AppLocalizations.of(context)!.delete_quiz_confirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _quizzes.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _saveChapter() {
    if (_formKey.currentState?.validate() ?? false) {
      // Update video order indices based on current position in list
      final videosWithUpdatedOrder = _videos.asMap().entries.map((entry) {
        return VideoEntity(
          id: entry.value.id,
          title: entry.value.title,
          youtubeUrl: entry.value.youtubeUrl,
          orderIndex: entry.key, // Use array index as order
        );
      }).toList();

      final chapter = ChapterEntity(
        id: isEditMode
            ? widget.existingChapter!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        videosUrls: videosWithUpdatedOrder,
        quizzes: _quizzes,
      );

      Navigator.pop(context, chapter);
    }
  }
}
