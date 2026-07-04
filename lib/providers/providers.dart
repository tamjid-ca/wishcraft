import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/app_user.dart';
import '../data/datasources/remote/firebase_auth_datasource.dart';
import '../data/datasources/remote/gemini_functions_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/card_repository_impl.dart';
import '../data/repositories/ai_repository_impl.dart';
import '../data/services/gemini_service.dart';
import '../data/services/export_service.dart';
import '../data/services/share_service.dart';
import '../domain/usecases/sign_in_with_google_usecase.dart';
import '../domain/usecases/sign_out_usecase.dart';
import '../domain/usecases/delete_account_usecase.dart';
import '../domain/usecases/generate_wish_usecase.dart';
import '../domain/usecases/save_card_usecase.dart';
import '../presentation/viewmodels/auth_viewmodel.dart';
import '../presentation/viewmodels/home_viewmodel.dart';
import '../presentation/viewmodels/occasion_viewmodel.dart';
import '../presentation/viewmodels/wish_generator_viewmodel.dart';
import '../presentation/viewmodels/card_editor_viewmodel.dart';
import '../presentation/viewmodels/preview_viewmodel.dart';
import '../presentation/viewmodels/saved_cards_viewmodel.dart';

// ── Firebase SDK instances ───────────────────────────────────────────────────

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());
final firestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final firebaseStorageProvider =
    Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);
final firebaseFunctionsProvider =
    Provider<FirebaseFunctions>((ref) => FirebaseFunctions.instance);

// ── Datasources ────────────────────────────────────────────────────────────────

final firebaseAuthDatasourceProvider = Provider<FirebaseAuthDatasource>(
  (ref) => FirebaseAuthDatasource(
    ref.watch(firebaseAuthProvider),
    ref.watch(googleSignInProvider),
  ),
);

final geminiFunctionsDatasourceProvider = Provider<GeminiFunctionsDatasource>(
  (ref) => GeminiFunctionsDatasource(ref.watch(firebaseFunctionsProvider)),
);

// ── Repositories ─────────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepositoryImpl>(
  (ref) => AuthRepositoryImpl(ref.watch(firebaseAuthDatasourceProvider)),
);

final cardRepositoryProvider = Provider<CardRepositoryImpl>(
  (ref) => CardRepositoryImpl(
    ref.watch(firestoreProvider),
    ref.watch(firebaseStorageProvider),
    ref.watch(firebaseAuthProvider),
  ),
);

final aiRepositoryProvider = Provider<AiRepositoryImpl>(
  (ref) =>
      AiRepositoryImpl(GeminiService(ref.watch(geminiFunctionsDatasourceProvider))),
);

// ── Auth state stream ─────────────────────────────────────────────────────────

final authStateChangesProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

final isFirstLaunchProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return !(prefs.getBool('first_launch_complete') ?? false);
});

// ── Services ─────────────────────────────────────────────────────────────────

final exportServiceProvider = Provider<ExportService>((ref) => ExportService());
final shareServiceProvider = Provider<ShareService>((ref) => ShareService());

// ── Use Cases ─────────────────────────────────────────────────────────────────

final signInWithGoogleUsecaseProvider = Provider<SignInWithGoogleUsecase>(
  (ref) => SignInWithGoogleUsecase(ref.watch(authRepositoryProvider)),
);
final signOutUsecaseProvider = Provider<SignOutUsecase>(
  (ref) => SignOutUsecase(ref.watch(authRepositoryProvider)),
);
final deleteAccountUsecaseProvider = Provider<DeleteAccountUsecase>(
  (ref) => DeleteAccountUsecase(ref.watch(authRepositoryProvider)),
);
final generateWishUsecaseProvider = Provider<GenerateWishUsecase>(
  (ref) => GenerateWishUsecase(ref.watch(aiRepositoryProvider)),
);
final saveCardUsecaseProvider = Provider<SaveCardUsecase>(
  (ref) => SaveCardUsecase(ref.watch(cardRepositoryProvider)),
);

// ── ViewModels ────────────────────────────────────────────────────────────────

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AsyncValue<AppUser?>>(
  (ref) => AuthViewModel(
    ref.watch(signInWithGoogleUsecaseProvider),
    ref.watch(signOutUsecaseProvider),
    ref.watch(deleteAccountUsecaseProvider),
  ),
);

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(),
);

final occasionViewModelProvider =
    StateNotifierProvider<OccasionViewModel, OccasionState>(
  (ref) => OccasionViewModel(),
);

final wishGeneratorViewModelProvider = StateNotifierProvider.family<
    WishGeneratorViewModel, WishGeneratorState, String>(
  (ref, occasionId) =>
      WishGeneratorViewModel(ref.watch(generateWishUsecaseProvider), occasionId),
);

final cardEditorViewModelProvider =
    StateNotifierProvider<CardEditorViewModel, CardEditorState>(
  (ref) => CardEditorViewModel(),
);

final previewViewModelProvider =
    StateNotifierProvider<PreviewViewModel, PreviewState>(
  (ref) => PreviewViewModel(
    ref.watch(exportServiceProvider),
    ref.watch(shareServiceProvider),
    ref.watch(saveCardUsecaseProvider),
  ),
);

final savedCardsViewModelProvider =
    StateNotifierProvider<SavedCardsViewModel, SavedCardsState>(
  (ref) => SavedCardsViewModel(ref.watch(cardRepositoryProvider)),
);

// ── Current user convenience provider ────────────────────────────────────────

final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateChangesProvider).value;
});
