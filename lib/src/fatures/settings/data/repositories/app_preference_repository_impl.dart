import 'package:teach_flix/src/fatures/settings/data/datasources/app_prefernce_local.dart';
import 'package:teach_flix/src/fatures/settings/domain/repositories/app_preference_repository.dart';

class AppPreferenceRepositoryImpl extends AppPreferenceRepository {
  final AppPreferenceLocal appPreferenceLocal;

  AppPreferenceRepositoryImpl(this.appPreferenceLocal);

  @override
  bool getDarkMode() {
    return appPreferenceLocal.getDarkMode();
  }

  @override
  String getLanguageCode() {
    return appPreferenceLocal.getLanguageCode();
  }

  @override
  Future<void> setDarkMode(bool value) async {
    await appPreferenceLocal.setDarkMode(value);
  }

  @override
  Future<void> setLanguageCode(String code) async {
    await appPreferenceLocal.setLanguageCode(code);
  }
}
