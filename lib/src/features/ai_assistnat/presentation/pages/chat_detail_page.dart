import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
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
          onPressed: () {
            final userId = context.read<AuthBloc>().state.user?.id;
            if (userId != null) {
              context.read<AiChatBloc>().add(AiChatSessionRequested(userId));
            }
          },
        ),
        title: Text(chatState.currentSession?.title ?? l10n.chat ?? 'Chat'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    const Icon(Icons.clear_all),
                    const SizedBox(width: 8),
                    Text(l10n.clear_messages ?? 'clear_messages'),
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
      body: BlocConsumer<AiChatBloc, AiChatState>(
        listener: (context, state) {
          if (state.status == AiChatStatus.failure && state.failure != null) {
            final errorMessage = ErrorLocalizer.of(state.failure!, l10n);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: state.messages.isEmpty
                    ? _buildEmptyState(context)
                    : _buildMessageList(context, state),
              ),
              if (state.isSending) const LinearProgressIndicator(minHeight: 2),
              _buildMessageInput(context, state),
            ],
          );
        },
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
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: state.isSending
                  ? null
                  : () => _handleAttachmentPressed(context),
              tooltip: l10n.attach_file ?? 'attach_file',
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !state.isSending,
                decoration: InputDecoration(
                  hintText: l10n.type_message ?? 'type_message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: state.isSending
                    ? null
                    : (_) => _sendMessage(context),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(state.isSending ? Icons.hourglass_empty : Icons.send),
              onPressed: state.isSending ? null : () => _sendMessage(context),
              tooltip: l10n.send ?? 'send',
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    if (!mounted) return;

    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    try {
      context.read<AiChatBloc>().add(AiChatMessageSent(text));
      _messageController.clear();
    } catch (e) {
      debugPrint('Error sending message: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleAttachmentPressed(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l10n.photo ?? 'photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: Text(l10n.file ?? 'file'),
              onTap: () {
                Navigator.pop(context);
                _pickFile(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final picker = ImagePicker();

    try {
      final result = await picker.pickImage(source: ImageSource.gallery);

      if (!mounted) return;

      if (result != null) {
        context.read<AiChatBloc>().add(
          AiChatMediaMessageSent(
            text: '',
            filePath: result.path,
            messageType: MessageType.image,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.no_image_selected ?? 'No image selected'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickFile(BuildContext context) async {
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    try {
      final result = await FilePicker.platform.pickFiles();

      if (!mounted) return;

      if (result != null && result.files.single.path != null) {
        context.read<AiChatBloc>().add(
          AiChatMediaMessageSent(
            text: '',
            filePath: result.files.single.path!,
            messageType: MessageType.file,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.no_file_selected ?? 'No file selected')),
        );
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showClearDialog(BuildContext context, String sessionId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clear_messages ?? 'clear_messages'),
        content: Text(
          l10n.clear_messages_confirmation ?? 'clear_messages_confirmation',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel ?? 'cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AiChatBloc>().add(AiChatMessagesCleared(sessionId));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.clear ?? 'clear'),
          ),
        ],
      ),
    );
  }
}
