import '../../data/repositories/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository _repository;
  SignOutUsecase(this._repository);

  Future<void> call() => _repository.signOut();
}
