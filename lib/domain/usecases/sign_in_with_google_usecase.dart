import '../../domain/entities/app_user.dart';
import '../../data/repositories/auth_repository.dart';

class SignInWithGoogleUsecase {
  final AuthRepository _repository;
  SignInWithGoogleUsecase(this._repository);

  Future<AppUser> call() => _repository.signInWithGoogle();
}
