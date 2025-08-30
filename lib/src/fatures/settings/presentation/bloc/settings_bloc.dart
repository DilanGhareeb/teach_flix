import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/fatures/settings/domain/usecases/change_language_code.dart';
import 'package:teach_flix/src/fatures/settings/domain/usecases/change_theme_usecase.dart';
import 'package:teach_flix/src/fatures/settings/domain/usecases/get_language_code.dart';
import 'package:teach_flix/src/fatures/settings/domain/usecases/get_theme_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetLanguageCode getLanguageCode;
  final GetTheme getTheme;
  final ChangeLanguageCode changeLanguageCode;
  final ChangeTheme changeTheme;

  SettingsBloc({
    required this.getLanguageCode,
    required this.getTheme,
    required this.changeLanguageCode,
    required this.changeTheme,
  }) : super(const SettingsState.initial()) {
    on<SettingsBootstrapRequested>(_onBootstrap);
    on<SettingsLanguageChanged>(_onLanguageChanged);
    on<SettingsThemeChanged>(_onThemeChanged);
  }

  void _onBootstrap(
    SettingsBootstrapRequested event,
    Emitter<SettingsState> emit,
  ) {
    emit(state.copyWith(status: SettingsStatus.loading));
    final lang = getLanguageCode();
    final dark = getTheme();
    emit(
      state.copyWith(
        status: SettingsStatus.ready,
        languageCode: lang,
        isDark: dark,
      ),
    );
  }

  void _onLanguageChanged(
    SettingsLanguageChanged event,
    Emitter<SettingsState> emit,
  ) {
    changeLanguageCode(params: event.languageCode);
    emit(state.copyWith(languageCode: event.languageCode));
  }

  void _onThemeChanged(
    SettingsThemeChanged event,
    Emitter<SettingsState> emit,
  ) {
    changeTheme(params: event.isDark);
    emit(state.copyWith(isDark: event.isDark));
  }
}
