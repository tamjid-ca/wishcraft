import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/onboarding/sign_in_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/occasion/occasion_selection_screen.dart';
import '../../presentation/screens/wish_generator/wish_generator_screen.dart';
import '../../presentation/screens/card_editor/card_editor_screen.dart';
import '../../presentation/screens/preview/card_preview_screen.dart';
import '../../presentation/screens/saved_cards/saved_cards_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../providers/providers.dart';

// GoRouter refresh listenable helper
import 'dart:async';
import 'package:flutter/foundation.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final isFirstLaunch = ref.watch(isFirstLaunchProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authRepositoryProvider).authStateChanges(),
    ),
    redirect: (context, state) {
      final loggedIn = authState.value != null;
      final onAuthRoute = state.matchedLocation == '/sign-in' ||
          state.matchedLocation == '/onboarding';

      if (authState.isLoading || isFirstLaunch.isLoading) return null;

      if (!loggedIn) {
        if (isFirstLaunch.value == true && state.matchedLocation != '/onboarding') {
          return '/onboarding';
        }
        return onAuthRoute ? null : '/sign-in';
      }

      if (loggedIn && onAuthRoute) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/sign-in', builder: (_, __) => const SignInScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/occasions', builder: (_, __) => const OccasionSelectionScreen()),
      GoRoute(
        path: '/wish-generator/:occasionId',
        builder: (_, state) => WishGeneratorScreen(
          occasionId: state.pathParameters['occasionId']!,
        ),
      ),
      GoRoute(path: '/card-editor', builder: (_, __) => const CardEditorScreen()),
      GoRoute(path: '/preview', builder: (_, __) => const CardPreviewScreen()),
      GoRoute(path: '/saved-cards', builder: (_, __) => const SavedCardsScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    ],
  );
});
