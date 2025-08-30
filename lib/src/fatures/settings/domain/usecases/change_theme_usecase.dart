import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/fatures/settings/domain/repositories/app_preference_repository.dart';

class ChangeTheme extends NormalParamsUsecase<bool, void> {
  final AppPreferenceRepository repository;

  ChangeTheme(this.repository);
  @override
  void call({required bool params}) {
    repository.setDarkMode(params);
  }
}
