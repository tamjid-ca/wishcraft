import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/providers.dart';
import '../../widgets/auth/google_sign_in_button.dart';
import '../../widgets/common/error_snackbar.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AsyncValue>(authViewModelProvider, (_, state) {
      if (state is AsyncError) {
        ErrorSnackbar.show(context, state.error.toString());
      }
    });

    final isLoading = authState is AsyncLoading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(
                Icons.auto_awesome,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.signInSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white90,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              GoogleSignInButton(
                onPressed: isLoading
                    ? null
                    : () => ref.read(authViewModelProvider.notifier).signInWithGoogle(),
                isLoading: isLoading,
              ),
              const SizedBox(height: 24),
              const Text(
                AppStrings.privacyNote,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
