import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/providers.dart';
import '../../widgets/common/error_snackbar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final themeMode = ref.watch(themeModeProvider);
    final authViewModel = ref.watch(authViewModelProvider);

    final isLoading = authViewModel is AsyncLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Profile
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
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person, size: 30),
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName ?? 'Google User',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email ?? '',
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
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

          const Text(
            AppStrings.account,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(AppStrings.signOut),
            onTap: isLoading
                ? null
                : () => ref.read(authViewModelProvider.notifier).signOut(),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(AppStrings.deleteAccount),
            onTap: isLoading ? null : () => _showDeleteConfirmation(context, ref),
          ),
          const SizedBox(height: 24),

          const Text(
            'App Preferences',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
          ),
          const Divider(),
          SwitchListTile(
            secondary: Icon(
              themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
              color: themeMode == ThemeMode.dark ? Colors.amber : Colors.grey,
            ),
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle between Light and Dark theme'),
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
              style: const TextStyle(color: Colors.grey, fontSize: 12),
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
              child: const Text(AppStrings.confirmDelete, style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
