import 'package:teach_flix/src/core/usecases/usecase.dart';
import 'package:teach_flix/src/features/settings/domain/repositories/app_preference_repository.dart';

class GetLanguageCode extends NormalNoParamsUsecase<String> {
  final AppPreferenceRepository repository;

  GetLanguageCode(this.repository);

  @override
  String call() {
    return repository.getLanguageCode();
  }
}
