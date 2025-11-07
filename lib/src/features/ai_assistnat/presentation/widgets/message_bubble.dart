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

    // AI messages - full width, no bubble, no avatar
    if (!isUser) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.type == MessageType.image && message.mediaUrl != null)
              _buildImageContent(context),
            if (message.type == MessageType.file && message.mediaUrl != null)
              _buildFileContent(context, localization),
            if (message.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: _buildMessageText(context),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                Formatter.formatTime(
                  message.createdAt,
                  localization: localization,
                ),
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      );
    }

    // User messages - bubble style, no avatar, aligned right
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 48, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
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
                  Text(
                    message.text,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Formatter.formatTime(
                    message.createdAt,
                    localization: localization,
                  ),
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                if (message.status != MessageStatus.sent) ...[
                  const SizedBox(width: 4),
                  _buildStatusIcon(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageText(BuildContext context) {
    // For AI messages, render as markdown with full width
    final theme = Theme.of(context);
    if (!isUser) {
      return MarkdownBody(
        data: message.text,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 15,
            height: 1.5,
          ),
          code: TextStyle(
            backgroundColor: Colors.grey[300],
            color: Colors.black87,
            fontSize: 14,
            fontFamily: 'monospace',
          ),
          codeblockPadding: const EdgeInsets.all(12),
          codeblockDecoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          blockquote: TextStyle(color: Colors.grey[700], fontSize: 15),
          blockquotePadding: const EdgeInsets.all(12),
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
          h1Padding: const EdgeInsets.symmetric(vertical: 8),
          h2Padding: const EdgeInsets.symmetric(vertical: 6),
          h3Padding: const EdgeInsets.symmetric(vertical: 4),
          listBullet: const TextStyle(color: Colors.black87, fontSize: 15),
          listIndent: 24,
          tableHead: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          tableBody: const TextStyle(color: Colors.black87),
          tableBorder: TableBorder.all(color: Colors.grey[300]!, width: 1),
          tableCellsPadding: const EdgeInsets.all(8),
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
      style: const TextStyle(color: Colors.white, fontSize: 15),
    );
  }

  Widget _buildImageContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: message.mediaUrl!,
          width: isUser ? 200 : double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            width: isUser ? 200 : double.infinity,
            height: 150,
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            width: isUser ? 200 : double.infinity,
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
        color: isUser ? Colors.white.withOpacity(0.2) : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
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
