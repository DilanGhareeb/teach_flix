import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/message.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isUser;

  const MessageBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[_buildAvatar(context), const SizedBox(width: 8)],
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth * 0.85,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(isUser ? 20 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (message.type == MessageType.image &&
                              message.mediaUrl != null)
                            _buildImageContent(context),
                          if (message.type == MessageType.file &&
                              message.mediaUrl != null)
                            _buildFileContent(context, localization),
                          if (message.text.isNotEmpty)
                            _buildMessageText(context),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: IntrinsicWidth(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                Formatter.formatTime(
                                  message.createdAt,
                                  localization: localization,
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            if (isUser &&
                                message.status != MessageStatus.sent) ...[
                              const SizedBox(width: 4),
                              _buildStatusIcon(),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          if (isUser) ...[const SizedBox(width: 8), _buildAvatar(context)],
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: isUser
          ? Theme.of(context).colorScheme.primary
          : Colors.grey[400],
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy,
        size: 18,
        color: Colors.white,
      ),
    );
  }

  Widget _buildMessageText(BuildContext context) {
    // For AI messages (non-user), render as markdown
    if (!isUser) {
      return MarkdownBody(
        data: message.text,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(color: Colors.black87, fontSize: 15),
          code: TextStyle(
            backgroundColor: Colors.grey[300],
            color: Colors.black87,
            fontSize: 14,
            fontFamily: 'monospace',
          ),
          codeblockDecoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          blockquote: TextStyle(color: Colors.grey[700], fontSize: 15),
          blockquoteDecoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
            border: Border(
              left: BorderSide(color: Colors.grey[400]!, width: 4),
            ),
          ),
          h1: const TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          h2: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          h3: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          listBullet: const TextStyle(color: Colors.black87, fontSize: 15),
          tableHead: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          tableBody: const TextStyle(color: Colors.black87),
          strong: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          em: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.black87,
          ),
          a: TextStyle(
            color: Colors.blue[700],
            decoration: TextDecoration.underline,
          ),
        ),
      );
    }

    // For user messages, render as plain text
    return Text(
      message.text,
      style: TextStyle(
        color: isUser ? Colors.white : Colors.black87,
        fontSize: 15,
      ),
    );
  }

  Widget _buildImageContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: message.mediaUrl!,
          width: 200,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: 200,
            height: 150,
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            width: 200,
            height: 150,
            color: Colors.grey[300],
            child: const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildFileContent(
    BuildContext context,
    AppLocalizations? localization,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isUser ? Colors.white.withOpacity(0.2) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.insert_drive_file,
              color: isUser ? Colors.white : Colors.grey[700],
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.mediaName ?? 'File',
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (message.mediaSize != null)
                    Text(
                      Formatter.formatFileSize(
                        message.mediaSize!,
                        localization: localization,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: isUser
                            ? Colors.white.withOpacity(0.8)
                            : Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case MessageStatus.failed:
        return Icon(Icons.error_outline, size: 14, color: Colors.red[300]);
      default:
        return const SizedBox.shrink();
    }
  }
}
