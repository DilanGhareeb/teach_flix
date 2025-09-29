import 'package:flutter/material.dart';
import 'package:teach_flix/src/fatures/courses/domain/entities/video_entity.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({super.key});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _youtubeUrlController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _orderController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _youtubeUrlController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.add_video),
        actions: [TextButton(onPressed: _saveVideo, child: Text(t.save))],
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
            const SizedBox(height: 16),

            TextFormField(
              controller: _youtubeUrlController,
              decoration: InputDecoration(
                labelText: t.youtube_url,
                hintText: t.enter_youtube_url,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _orderController,
              decoration: InputDecoration(
                labelText: t.order_index,
                hintText: t.enter_order_index,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return t.order_required;
                }
                if (int.tryParse(value!) == null) {
                  return t.invalid_order;
                }
                return null;
              },
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
      final video = VideoEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        youtubeUrl: _youtubeUrlController.text,
        orderIndex: int.parse(_orderController.text),
      );

      Navigator.pop(context, video);
    }
  }
}
