import '../../data/repositories/auth_repository.dart';

class DeleteAccountUsecase {
  final AuthRepository _repository;
  DeleteAccountUsecase(this._repository);

  Future<void> call() => _repository.deleteAccount();
}
