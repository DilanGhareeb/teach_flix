import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/fatures/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/fatures/auth/presentation/pages/edit_profile_page.dart';
import 'package:teach_flix/src/fatures/settings/presentation/bloc/settings_bloc.dart';
import 'package:teach_flix/src/fatures/settings/presentation/widgets/action_header_card.dart';
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

  Future<String?> _showLanguageSheet(BuildContext context) async {
    final t = AppLocalizations.of(context)!;

    final labels = {'ckb': t.kurdish, 'en': t.english};

    final assets = {'ckb': 'assets/flags/ckb.png', 'en': 'assets/flags/en.png'};

    return showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final code in ['ckb', 'en'])
                ListTile(
                  leading: Image.asset(
                    assets[code]!,
                    fit: BoxFit.cover,
                    height: 20,
                    width: 35,
                  ),

                  title: Text(labels[code]!),
                  onTap: () => Navigator.of(ctx).pop(code),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
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

              return SafeArea(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  children: [
                    /// ACCOUNT HEADER CARD
                    AccountHeaderCard(
                      name: name,
                      email: email,
                      photoUrl: photo,
                      onEditProfile: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );
                      },
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/flags/${state.languageCode}.png',
                                width: 40,
                                height: 24,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                state.languageCode == 'ckb'
                                    ? t.kurdish
                                    : t.english,
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right_rounded),
                            ],
                          ),
                          onTap: () async {
                            final selected = await _showLanguageSheet(context);
                            if (selected != null &&
                                selected != state.languageCode) {
                              context.read<SettingsBloc>().add(
                                SettingsLanguageChanged(selected),
                              );
                            }
                          },
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
                          leading: const Icon(Icons.lock),
                          title: Text(t.change_password),
                          onTap: () {
                            // TODO: navigate to your Profile page
                            // context.push('/profile');
                          },
                        ),
                        Divider(),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
