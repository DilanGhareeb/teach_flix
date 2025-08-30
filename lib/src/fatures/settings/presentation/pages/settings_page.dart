import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/fatures/settings/presentation/bloc/settings_bloc.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(t.settings)),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state.status == SettingsStatus.loading ||
              state.status == SettingsStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.only(top: 30, left: 25.0, right: 25.0),
            children: [
              // Theme toggle
              SwitchListTile(
                title: Text(
                  t.dark_mode,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                value: state.isDark,
                onChanged: (v) {
                  context.read<SettingsBloc>().add(SettingsThemeChanged(v));
                },
              ),

              const SizedBox(height: 10),

              // Language selection dropdown
              ListTile(
                title: Text(
                  t.language,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: DropdownButton<String>(
                  value: state.languageCode,
                  onChanged: (String? newLanguage) {
                    if (newLanguage != null &&
                        newLanguage != state.languageCode) {
                      context.read<SettingsBloc>().add(
                        SettingsLanguageChanged(newLanguage),
                      );
                      // If your app supports hot language switching, trigger it elsewhere
                      // (e.g., via a LocaleNotifier or Router refresh)
                    }
                  },
                  items: [
                    DropdownMenuItem(value: 'ckb', child: Text(t.kurdish)),
                    DropdownMenuItem(value: 'en', child: Text(t.english)),
                  ],
                ),
              ),

              // App version info
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Center(
                  child: Text(
                    t.app_version('1.0.0'),
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
