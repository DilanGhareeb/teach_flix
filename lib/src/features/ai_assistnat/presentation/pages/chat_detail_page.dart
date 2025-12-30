import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/message.dart';
import 'package:teach_flix/src/features/ai_assistnat/presentation/bloc/ai_chat_bloc.dart';
import 'package:teach_flix/src/features/ai_assistnat/presentation/widgets/message_bubble.dart';
import 'package:teach_flix/src/features/common/error_localizer.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();

  // Selected image state
  String? _selectedImagePath;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chatState = context.watch<AiChatBloc>().state;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(chatState.currentSession?.title ?? l10n.chat ?? 'Chat'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.clear_all),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n.clear_messages ?? 'clear_messages',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'clear' && chatState.currentSession != null) {
                _showClearDialog(context, chatState.currentSession!.id);
              }
            },
          ),
        ],
      ),
      body: BlocListener<AiChatBloc, AiChatState>(
        listenWhen: (previous, current) =>
            previous.failure != current.failure && current.failure != null,
        listener: (context, state) {
          if (state.failure != null) {
            final errorMessage = ErrorLocalizer.of(state.failure!, l10n);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: chatState.messages.isEmpty
                  ? _buildEmptyState(context)
                  : _buildMessageList(context, chatState),
            ),
            if (chatState.isSending)
              const LinearProgressIndicator(minHeight: 2),
            _buildMessageInput(context, chatState),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.start_chatting ?? 'start_chatting',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context, AiChatState state) {
    final userId = context.read<AuthBloc>().state.user!.id;

    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.all(16),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[index];
        final isUser = message.authorId == userId;

        return MessageBubble(message: message, isUser: isUser);
      },
    );
  }

  Widget _buildMessageInput(BuildContext context, AiChatState state) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image preview section
            if (_selectedImagePath != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    // Image preview
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_selectedImagePath!),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Image info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedImagePath!.split('/').last,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.image_attached ?? 'Image attached',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Remove button
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        setState(() {
                          _selectedImagePath = null;
                        });
                      },
                      tooltip: l10n.delete ?? 'Remove',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ),
            // Input row
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Image picker button
                SizedBox(
                  width: 48,
                  child: IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: state.isSending
                        ? null
                        : () => _showImageSourceDialog(context),
                    tooltip: l10n.upload_image ?? 'Attach Image',
                    padding: EdgeInsets.zero,
                  ),
                ),
                // Text input
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: TextField(
                      controller: _messageController,
                      enabled: !state.isSending,
                      decoration: InputDecoration(
                        hintText: _selectedImagePath != null
                            ? (l10n.add_message_to_image ?? 'Add a message...')
                            : (l10n.type_message ?? 'Type a message...'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                      maxLines: null,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: state.isSending
                          ? null
                          : (_) => _sendMessage(),
                    ),
                  ),
                ),
                // Send button
                SizedBox(
                  width: 48,
                  child: IconButton(
                    icon: Icon(
                      state.isSending ? Icons.hourglass_empty : Icons.send,
                    ),
                    onPressed: state.isSending ? null : () => _sendMessage(),
                    tooltip: l10n.send ?? 'Send',
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    // Check if we have either text or image
    if (text.isEmpty && _selectedImagePath == null) return;

    try {
      if (_selectedImagePath != null) {
        // Send image with optional text
        context.read<AiChatBloc>().add(
          AiChatMediaMessageSent(
            text: text,
            filePath: _selectedImagePath!,
            messageType: MessageType.image,
          ),
        );

        // Clear both text and image
        _messageController.clear();
        setState(() {
          _selectedImagePath = null;
        });
      } else {
        // Send text only
        context.read<AiChatBloc>().add(AiChatMessageSent(text));
        _messageController.clear();
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: Text(l10n.camera ?? 'Camera'),
                onTap: () {
                  Navigator.pop(modalContext);
                  _pickImage(ImageSource.camera);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: Text(l10n.gallery ?? 'Gallery'),
                onTap: () {
                  Navigator.pop(modalContext);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    // Check if we have a current session
    final currentSession = context.read<AiChatBloc>().state.currentSession;
    if (currentSession == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No active chat session'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        debugPrint('Image picked: ${image.path}');

        // Set the selected image - don't send yet
        setState(() {
          _selectedImagePath = image.path;
        });

        // Focus on the text field so user can type
        FocusScope.of(context).requestFocus(FocusNode());
      } else {
        debugPrint('Image picker cancelled');
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showClearDialog(BuildContext context, String sessionId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.clear_messages ?? 'Clear Messages'),
        content: Text(
          l10n.clear_messages_confirmation ??
              'Are you sure you want to clear all messages?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AiChatBloc>().add(AiChatMessagesCleared(sessionId));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.clear ?? 'Clear'),
          ),
        ],
      ),
    );
  }
}
