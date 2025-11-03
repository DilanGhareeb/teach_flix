import 'package:flutter/material.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class NewChatDialog extends StatefulWidget {
  final Function(String title) onCreateChat;

  const NewChatDialog({super.key, required this.onCreateChat});

  @override
  State<NewChatDialog> createState() => _NewChatDialogState();
}

class _NewChatDialogState extends State<NewChatDialog> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.new_chat),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _titleController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l10n.chat_title,
            hintText: l10n.enter_chat_title,
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.title_required;
            }
            if (value.trim().length < 3) {
              return l10n.title_too_short;
            }
            return null;
          },
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(onPressed: _submit, child: Text(l10n.create)),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      widget.onCreateChat(title);
      Navigator.pop(context);
    }
  }
}
