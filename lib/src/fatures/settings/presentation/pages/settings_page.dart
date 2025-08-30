import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/fatures/settings/presentation/bloc/settings_bloc.dart';
import 'package:teach_flix/src/fatures/settings/presentation/widgets/action_header_card.dart';
import 'package:teach_flix/src/fatures/settings/presentation/widgets/quick_action.dart';
import 'package:teach_flix/src/fatures/settings/presentation/widgets/section_card.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const SettingsBootstrapRequested());
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, userState) {
          return BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state.status == SettingsStatus.loading ||
                  state.status == SettingsStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }

              final user = userState.user;
              final name = user?.name ?? t.anonymous;
              final email = user?.email ?? t.no_email;
              final photo = user?.profilePictureUrl;

              return ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                children: [
                  /// ACCOUNT HEADER CARD
                  AccountHeaderCard(
                    name: name,
                    email: email,
                    photoUrl: photo,
                    onEditProfile: () {
                      // TODO: navigate to your Edit Profile page
                      // context.push('/profile/edit');
                    },
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: QuickAction(
                          icon: Icons.lock_outline,
                          label: t.change_password,
                          onTap: () {
                            // TODO: navigate to change password
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: QuickAction(
                          icon: Icons.history,
                          label: t.activity,
                          onTap: () {
                            // TODO: navigate to activity/logs
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: QuickAction(
                          icon: Icons.verified_user_outlined,
                          label: t.security,
                          onTap: () {
                            // TODO: navigate to 2FA/security
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// APPEARANCE
                  Text(t.appearance, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SectionCard(
                    children: [
                      SwitchListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        title: Text(t.dark_mode),
                        value: state.isDark,
                        onChanged: (v) => context.read<SettingsBloc>().add(
                          SettingsThemeChanged(v),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// LANGUAGE
                  Text(t.language, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SectionCard(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        title: Text(t.language),
                        trailing: DropdownButton<String>(
                          value: state.languageCode,
                          onChanged: (String? newLanguage) {
                            if (newLanguage != null &&
                                newLanguage != state.languageCode) {
                              context.read<SettingsBloc>().add(
                                SettingsLanguageChanged(newLanguage),
                              );
                            }
                          },
                          items: [
                            DropdownMenuItem(
                              value: 'ckb',
                              child: Text(t.kurdish),
                            ),
                            DropdownMenuItem(
                              value: 'en',
                              child: Text(t.english),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// ACCOUNT & SECURITY
                  Text(t.account, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SectionCard(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        leading: const Icon(Icons.badge_outlined),
                        subtitle: Text(user?.id ?? '-'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        leading: const Icon(Icons.logout),
                        title: Text(t.logout),
                        onTap: () {
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: Text(
                      t.app_version('1.0.0'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF9E9E9E), // grey600
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
