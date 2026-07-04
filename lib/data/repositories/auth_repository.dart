import '../../domain/entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  AppUser? get currentUser;
  Future<AppUser> signInWithGoogle();
  Future<void> signOut();
  Future<void> deleteAccount();
}
