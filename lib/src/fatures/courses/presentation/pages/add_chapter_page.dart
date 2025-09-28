import 'package:flutter/material.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/chapter_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/video_entity.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/quiz_entity.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(t.add_chapter),
        actions: [TextButton(onPressed: _saveChapter, child: Text(t.save))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: t.chapter_title,
                hintText: t.enter_chapter_title,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return t.title_required;
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(t.videos, () => _addVideo()),
            const SizedBox(height: 8),

            if (_videos.isEmpty)
              _buildEmptyState(t.no_videos_added, Icons.video_library_outlined)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _videos.length,
                itemBuilder: (context, index) {
                  final video = _videos[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.play_circle_outline),
                      title: Text(video.title),
                      subtitle: Text('${video.duration.inMinutes} min'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeVideo(index),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 24),

            _buildSectionHeader(t.quizzes, () => _addQuiz()),
            const SizedBox(height: 8),

            if (_quizzes.isEmpty)
              _buildEmptyState(t.no_quizzes_added, Icons.quiz_outlined)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = _quizzes[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.quiz_outlined),
                      title: Text(quiz.title),
                      subtitle: Text('${quiz.questions.length} questions'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _removeQuiz(index),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: Text(AppLocalizations.of(context)!.add),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _addVideo() {
    Navigator.pushNamed(context, '/add-video', arguments: widget.courseId).then(
      (result) {
        if (result is VideoEntity) {
          setState(() {
            _videos.add(result);
          });
        }
      },
    );
  }

  void _addQuiz() {
    Navigator.pushNamed(context, '/add-quiz', arguments: widget.courseId).then((
      result,
    ) {
      if (result is QuizEntity) {
        setState(() {
          _quizzes.add(result);
        });
      }
    });
  }

  void _removeVideo(int index) {
    setState(() {
      _videos.removeAt(index);
    });
  }

  void _removeQuiz(int index) {
    setState(() {
      _quizzes.removeAt(index);
    });
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
