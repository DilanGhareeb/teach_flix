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
    final screenWidth = MediaQuery.of(context).size.width;

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 120,
                        maxWidth: screenWidth - 120,
                      ),
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
                            vertical: 10,
                          ),
                          isDense: true,
                        ),
                        maxLines: null,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        onSubmitted: state.isSending
                            ? null
                            : (_) => _sendMessage(context),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: IconButton(
                      icon: Icon(
                        state.isSending ? Icons.hourglass_empty : Icons.send,
                      ),
                      onPressed: state.isSending
                          ? null
                          : () => _sendMessage(context),
                      tooltip: l10n.send ?? 'send',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    if (!mounted) return;

    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Get BLoC and messenger before any async operations
    final chatBloc = context.read<AiChatBloc>();
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);

    try {
      chatBloc.add(AiChatMessageSent(text));
      _messageController.clear();
    } catch (e) {
      debugPrint('Error sending message: $e');
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              l10n?.failed_to_send_message ?? 'Failed to send message',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: Text(l10n.camera ?? 'Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.camera);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: Text(l10n.gallery ?? 'Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    if (!mounted) return;

    // Get localization before async gap
    final l10n = AppLocalizations.of(context);
    // Get ScaffoldMessenger before async gap
    final messenger = ScaffoldMessenger.of(context);
    // Get BLoC before async gap
    final chatBloc = context.read<AiChatBloc>();

    // Check if we have a current session
    final currentSession = chatBloc.state.currentSession;
    if (currentSession == null) {
      messenger.showSnackBar(
        SnackBar(
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

      if (!mounted) return;

      if (image != null) {
        debugPrint('Image picked: ${image.path}');

        // Send the image message
        chatBloc.add(
          AiChatMediaMessageSent(
            text: '',
            filePath: image.path,
            messageType: MessageType.image,
          ),
        );

        debugPrint('Image message sent to BLoC');
      } else {
        // User cancelled the picker
        debugPrint('Image picker cancelled');
        if (source == ImageSource.camera) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(l10n?.camera_cancelled ?? 'Camera cancelled'),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              l10n?.failed_to_pick_image ??
                  'Failed to pick image: ${e.toString()}',
            ),
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
