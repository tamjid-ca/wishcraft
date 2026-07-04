import '../../domain/entities/app_user.dart';
import '../datasources/remote/firebase_auth_datasource.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _datasource;
  AuthRepositoryImpl(this._datasource);

  @override
  Stream<AppUser?> authStateChanges() =>
      _datasource.authStateChanges().map(_toAppUser);

  @override
  AppUser? get currentUser => _toAppUser(_datasource.currentUser);

  @override
  Future<AppUser> signInWithGoogle() async {
    final user = await _datasource.signInWithGoogle();
    return _toAppUser(user)!;
  }

  @override
  Future<void> signOut() => _datasource.signOut();

  @override
  Future<void> deleteAccount() => _datasource.deleteCurrentUser();

  AppUser? _toAppUser(dynamic firebaseUser) {
    if (firebaseUser == null) return null;
    return AppUser(
      uid: firebaseUser.uid as String,
      displayName: firebaseUser.displayName as String?,
      email: firebaseUser.email as String?,
      photoUrl: firebaseUser.photoURL as String?,
    );
  }
}
