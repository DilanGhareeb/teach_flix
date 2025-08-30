import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class AccountHeaderCard extends StatelessWidget {
  const AccountHeaderCard({
    super.key,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.onEditProfile,
  });

  final String name;
  final String email;
  final String? photoUrl;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withAlpha(
              180,
            ), // softer end without withOpacity
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: theme.colorScheme.onPrimary.withAlpha(20),
                backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
                    ? CachedNetworkImageProvider(photoUrl!)
                    : null,
                child: (photoUrl == null || photoUrl!.isEmpty)
                    ? Icon(
                        Icons.person,
                        size: 34,
                        color: theme.colorScheme.onPrimary,
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      width: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: DefaultTextStyle(
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimary.withAlpha(220),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.onPrimary,
                        foregroundColor: theme.colorScheme.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      onPressed: onEditProfile,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: Text(
                        AppLocalizations.of(context)!.edit_profile,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
