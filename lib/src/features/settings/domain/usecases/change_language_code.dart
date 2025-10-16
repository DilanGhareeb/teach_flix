import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/features/settings/domain/repositories/app_preference_repository.dart';

class ChangeLanguageCode extends NormalParamsUsecase<String, void> {
  final AppPreferenceRepository repository;

  ChangeLanguageCode(this.repository);

  @override
  void call({required String params}) {
    repository.setLanguageCode(params);
  }
}
