import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:teach_flix/src/features/ai_assistnat/presentation/bloc/ai_chat_bloc.dart';
import 'package:teach_flix/src/features/ai_assistnat/presentation/widgets/new_chat_dialog.dart';
import 'package:teach_flix/src/features/common/error_localizer.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';

class ChatSessionsPage extends StatelessWidget {
  const ChatSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ai_assistant ?? 'AI Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
            tooltip: l10n.info ?? 'Info',
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
          if (state.status == AiChatStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.sessions.isEmpty) {
            return _EmptyState(onNewChat: () => _showNewChatDialog(context));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.sessions.length,
            itemBuilder: (context, index) {
              final session = state.sessions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.chat, color: Colors.white),
                  ),
                  title: Text(
                    session.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (session.lastMessageText != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          session.lastMessageText!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(context, session.updatedAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(l10n.delete ?? 'delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteDialog(context, session.id);
                      }
                    },
                  ),
                  onTap: () {
                    context.read<AiChatBloc>().add(
                      AiChatSessionSelected(session.id),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewChatDialog(context),
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.new_chat ?? 'New Chat'),
      ),
    );
  }

  void _showNewChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<AiChatBloc>(),
        child: NewChatDialog(
          onCreateChat: (title) {
            final userId = context.read<AuthBloc>().state.user!.id;
            context.read<AiChatBloc>().add(
              AiChatNewSessionRequested(userId: userId, title: title),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String sessionId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete_chat ?? 'delete_chat'),
        content: Text(
          l10n.delete_chat_confirmation ?? 'delete_chat_confirmation',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel ?? 'cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AiChatBloc>().add(AiChatSessionDeleted(sessionId));
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete ?? 'delete'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.ai_assistant ?? 'ai_assistant'),
        content: Text(l10n.ai_assistant_info ?? 'ai_assistant_info'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok ?? 'ok'),
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final l10n = AppLocalizations.of(context)!;

    if (difference.inDays == 0) {
      return DateFormat('HH:mm', 'en').format(date);
    } else if (difference.inDays == 1) {
      return l10n.yesterday ?? 'yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE', 'en').format(date);
    } else {
      return DateFormat('MMM dd', 'en').format(date);
    }
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onNewChat;

  const _EmptyState({required this.onNewChat});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 100, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              l10n.no_chats_yet ?? 'no_chats_yet',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.start_conversation_with_ai ?? 'start_conversation_with_ai',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: onNewChat,
              icon: const Icon(Icons.add),
              label: Text(l10n.start_new_chat ?? 'start_new_chat'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
