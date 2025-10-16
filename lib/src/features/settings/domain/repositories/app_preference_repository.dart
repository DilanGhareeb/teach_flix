abstract class AppPreferenceRepository {
  bool getDarkMode();
  Future<void> setDarkMode(bool value);
  String getLanguageCode();
  Future<void> setLanguageCode(String code);
}
