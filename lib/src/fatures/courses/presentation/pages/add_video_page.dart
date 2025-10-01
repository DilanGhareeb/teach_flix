import 'package:flutter/material.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/video_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class AddVideoPage extends StatefulWidget {
  final VideoEntity? existingVideo;

  const AddVideoPage({super.key, this.existingVideo});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool get isEditMode => widget.existingVideo != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _titleController.text = widget.existingVideo!.title;
      _youtubeUrlController.text = widget.existingVideo!.youtubeUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _youtubeUrlController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? t.edit_video : t.add_video),
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _saveVideo,
            icon: const Icon(Icons.check_circle_rounded),
            label: Text(t.save),
            style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: t.video_title,
                hintText: t.enter_video_title,
                prefixIcon: Icon(
                  Icons.title_rounded,
                  color: colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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
            const SizedBox(height: 16),

            TextFormField(
              controller: _youtubeUrlController,
              decoration: InputDecoration(
                labelText: t.youtube_url,
                hintText: t.enter_youtube_url,
                prefixIcon: Icon(
                  Icons.link_rounded,
                  color: colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return t.youtube_url_required;
                }
                if (!_isValidYouTubeUrl(value!)) {
                  return t.invalid_youtube_url;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: t.description,
                hintText: t.enter_video_description,
                prefixIcon: Icon(
                  Icons.description_rounded,
                  color: colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            // Info card explaining auto-ordering
            Card(
              color: colorScheme.primaryContainer.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t.video_order_info ??
                            'Video order is determined by the position in the list. You can reorder videos by dragging them.',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidYouTubeUrl(String url) {
    final youtubeRegex = RegExp(
      r'^https?:\/\/(www\.)?(youtube\.com\/(watch\?v=|embed\/)|youtu\.be\/)[\w-]+',
      caseSensitive: false,
    );
    return youtubeRegex.hasMatch(url);
  }

  void _saveVideo() {
    if (_formKey.currentState?.validate() ?? false) {
      // Order index will be set by the parent based on position in the list
      final video = VideoEntity(
        id: isEditMode
            ? widget.existingVideo!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        youtubeUrl: _youtubeUrlController.text,
        orderIndex: isEditMode
            ? widget.existingVideo!.orderIndex
            : 0, // Temporary value, will be updated by parent
      );

      Navigator.pop(context, video);
    }
  }
}
