import 'package:flutter/material.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/chapter_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/video_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/quiz_entity.dart';
import 'package:teach_flix/src/fatures/courses/presentation/pages/add_video_page.dart';
import 'package:teach_flix/src/fatures/courses/presentation/pages/add_quiz_page.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class AddChapterPage extends StatefulWidget {
  final String courseId;

  const AddChapterPage({super.key, required this.courseId});

  @override
  State<AddChapterPage> createState() => _AddChapterPageState();
}

class _AddChapterPageState extends State<AddChapterPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  final List<VideoEntity> _videos = [];
  final List<QuizEntity> _quizzes = [];

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
        title: Text(t.add_chapter),
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
                  onPressed: _addVideo,
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _videos.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final video = _videos[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.blue[700],
                      ),
                    ),
                    title: Text(
                      video.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red[400],
                      ),
                      onPressed: () => _removeVideo(index),
                    ),
                  ),
                );
              },
            ),
        ],
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
                  onPressed: _addQuiz,
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _quizzes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final quiz = _quizzes[index];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple.withOpacity(0.1),
                      child: Icon(
                        Icons.quiz_outlined,
                        color: Colors.purple[700],
                      ),
                    ),
                    title: Text(
                      quiz.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      '${quiz.questions.length} questions • ${quiz.timeLimit.inMinutes} min',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red[400],
                      ),
                      onPressed: () => _removeQuiz(index),
                    ),
                  ),
                );
              },
            ),
        ],
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
      final chapter = ChapterEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        videosUrls: _videos,
        quizzes: _quizzes,
      );

      Navigator.pop(context, chapter);
    }
  }
}
