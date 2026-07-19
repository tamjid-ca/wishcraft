import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/providers.dart';
import '../../widgets/common/wc_app_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final themeMode = ref.watch(themeModeProvider);
    final authViewModel = ref.watch(authViewModelProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final isLoading = authViewModel is AsyncLoading;

    return Scaffold(
      appBar: const WcAppBar(title: AppStrings.settings),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Account Profile Card ────────────────────────────────
          if (user != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (user.photoUrl != null)
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user.photoUrl!),
                      )
                    else
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: cs.primaryContainer,
                        child: Icon(Icons.person, size: 30, color: cs.onPrimaryContainer),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName ?? 'Google User',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email ?? '',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // ── Account Section ─────────────────────────────────────
          Text(
            AppStrings.account,
            style: theme.textTheme.labelLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: cs.error),
            title: Text(AppStrings.signOut,
                style: theme.textTheme.bodyLarge),
            onTap: isLoading
                ? null
                : () => ref.read(authViewModelProvider.notifier).signOut(),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever, color: cs.error),
            title: Text(AppStrings.deleteAccount,
                style: theme.textTheme.bodyLarge?.copyWith(color: cs.error)),
            onTap: isLoading ? null : () => _showDeleteConfirmation(context, ref),
          ),
          const SizedBox(height: 24),

          // ── Preferences Section ─────────────────────────────────
          Text(
            'App Preferences',
            style: theme.textTheme.labelLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Divider(),
          SwitchListTile(
            secondary: Icon(
              themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
              color: themeMode == ThemeMode.dark ? cs.primary : cs.onSurface.withValues(alpha: 0.5),
            ),
            title: Text('Dark Mode', style: theme.textTheme.bodyLarge),
            subtitle: Text(
              'Toggle between Light and Dark theme',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.55),
              ),
            ),
            value: themeMode == ThemeMode.dark,
            onChanged: (isDark) {
              ref.read(themeModeProvider.notifier).setThemeMode(
                    isDark ? ThemeMode.dark : ThemeMode.light,
                  );
            },
          ),
          const SizedBox(height: 40),
          Center(
            child: Text(
              '${AppStrings.appName} v1.0.0+1',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return AlertDialog(
          title: const Text(AppStrings.deleteAccountConfirmTitle),
          content: const Text(AppStrings.deleteAccountConfirmBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                ref.read(authViewModelProvider.notifier).deleteAccount();
                Navigator.pop(context);
              },
              child: Text(AppStrings.confirmDelete,
                  style: TextStyle(color: cs.error)),
            ),
          ],
        );
      },
    );
  }
}
