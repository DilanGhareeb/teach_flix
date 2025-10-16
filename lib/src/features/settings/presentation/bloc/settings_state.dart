part of 'settings_bloc.dart';

enum SettingsStatus { initial, loading, ready }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final String languageCode;
  final bool isDark;

  const SettingsState({
    required this.status,
    required this.languageCode,
    required this.isDark,
  });

  const SettingsState.initial()
    : status = SettingsStatus.initial,
      languageCode = 'ckb',
      isDark = false;

  SettingsState copyWith({
    SettingsStatus? status,
    String? languageCode,
    bool? isDark,
  }) {
    return SettingsState(
      status: status ?? this.status,
      languageCode: languageCode ?? this.languageCode,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  List<Object?> get props => [status, languageCode, isDark];
}
