import 'package:shared_preferences/shared_preferences.dart';

abstract class AppPreferenceLocal {
  Future<void> init();
  bool getDarkMode();
  Future<void> setDarkMode(bool value);
  String getLanguageCode();
  Future<void> setLanguageCode(String code);
}

class AppPreferenceLocalImpl implements AppPreferenceLocal {
  final SharedPreferences sharedPreferences;

  late bool isDark;
  late String languageCode;

  final String languageCodeKey = 'languageCode';
  final String darkModeKey = 'isDark';

  AppPreferenceLocalImpl(this.sharedPreferences) {
    init();
  }

  @override
  Future<void> init() async {
    isDark = getDarkMode();
    languageCode = getLanguageCode();
  }

  @override
  bool getDarkMode() {
    isDark = sharedPreferences.getBool(darkModeKey) ?? false;
    return isDark;
  }

  @override
  String getLanguageCode() {
    languageCode = sharedPreferences.getString(languageCodeKey) ?? 'ckb';
    return languageCode;
  }

  @override
  Future<void> setDarkMode(bool value) async {
    await sharedPreferences.setBool(darkModeKey, value);
  }

  @override
  Future<void> setLanguageCode(String code) async {
    await sharedPreferences.setString(languageCodeKey, code);
  }
}
