part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class SettingsBootstrapRequested extends SettingsEvent {
  const SettingsBootstrapRequested();
}

class SettingsLanguageChanged extends SettingsEvent {
  final String languageCode;
  const SettingsLanguageChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class SettingsThemeChanged extends SettingsEvent {
  final bool isDark;
  const SettingsThemeChanged(this.isDark);

  @override
  List<Object?> get props => [isDark];
}
