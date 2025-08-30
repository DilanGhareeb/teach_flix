import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/fatures/settings/domain/repositories/app_preference_repository.dart';

class GetTheme extends NormalNoParamsUsecase<bool> {
  final AppPreferenceRepository repository;

  GetTheme(this.repository);

  @override
  bool call() {
    return repository.getDarkMode();
  }
}
