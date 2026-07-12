import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/occasion_model.dart';
import '../../../providers/providers.dart';
import '../../widgets/cards/saved_card_thumbnail.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final savedCardsAsync = ref.watch(savedCardsViewModelProvider).cards;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: user?.photoUrl != null
              ? CircleAvatar(backgroundImage: NetworkImage(user!.photoUrl!))
              : const CircleAvatar(child: Icon(Icons.person)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section / welcome banner
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${user?.displayName ?? "Friend"}! 👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'What occasion are we celebrating today?',
                    style: TextStyle(
                      color: Color(0xE6FFFFFF),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/occasions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text('Create New Card'),
                  ),
                ],
              ),
            ),

            // Quick Occasions Horizontal Scroll
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Browse Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: occasions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final o = occasions[idx];
                  return ActionChip(
                    avatar: Text(o.emoji),
                    label: Text(o.displayName),
                    onPressed: () => context.push('/wish-generator/${o.id}'),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Recent Saved Cards section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                AppStrings.recentCards,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200,
              child: savedCardsAsync.when(
                data: (cards) {
                  if (cards.isEmpty) {
                    return const Center(
                      child: Text(AppStrings.noRecentCards),
                    );
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: cards.length > 5 ? 5 : cards.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, idx) {
                      final card = cards[idx];
                      return SizedBox(
                        width: 140,
                        child: SavedCardThumbnail(
                          card: card,
                          onTap: () {
                            // Editor view loaded with state
                            ref.read(cardEditorViewModelProvider.notifier).initFromCard(
                                  templateId: card.templateId,
                                  fontFamily: card.fontFamily,
                                  fontSize: card.fontSize,
                                  textColor: card.textColor,
                                  stickerIds: card.stickerIds,
                                  showBorder: card.showBorder,
                                  senderName: card.senderName,
                                );
                            context.push('/card-editor', extra: card);
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/occasions'),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create Card', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
