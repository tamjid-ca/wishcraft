import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final isFirstLaunch = ref.read(isFirstLaunchProvider).value ?? true;
    final loggedIn = ref.read(authStateChangesProvider).value != null;

    if (loggedIn) {
      context.go('/home');
    } else if (isFirstLaunch) {
      context.go('/onboarding');
    } else {
      context.go('/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 80,
                color: Colors.white,
              ).animate().rotate(duration: 800.ms, curve: Curves.easeInOut),
              const SizedBox(height: 16),
              Text(
                AppStrings.appName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ).animate().fade(duration: 500.ms).slideY(begin: 0.3),
              const SizedBox(height: 8),
              Text(
                AppStrings.appTagline,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fade(delay: 200.ms, duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }
}
