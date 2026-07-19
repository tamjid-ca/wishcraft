import 'dart:ui' as ui;
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

    // Responsive sizing
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final horizontalPadding = screenWidth > 600 ? 24.0 : 16.0;

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
            // Hero section with glassmorphism welcome card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
              child: SizedBox(
                height: 190,
                child: Stack(
                  children: [
                    // Background deep-violet/pink gradient
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    // Decorative glow circles
                    Positioned(
                      left: -20,
                      top: -20,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -30,
                      bottom: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Glassmorphic layer
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.25),
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hello, ${user?.displayName ?? "Friend"}! 👋',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'What occasion are we celebrating today?',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ElevatedButton(
                                  onPressed: () => context.push('/occasions'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(0.9),
                                    foregroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Create New Card', style: TextStyle(fontSize: 13)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Occasions Horizontal Scroll (Occasion chips)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8.0),
              child: const Text(
                'Browse Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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

            const SizedBox(height: 20),

            // Recent Saved Cards grid section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8.0),
              child: const Text(
                AppStrings.recentCards,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            
            savedCardsAsync.when(
              data: (cards) {
                if (cards.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(horizontalPadding),
                    child: const Center(
                      child: Text(AppStrings.noRecentCards, style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }
                
                final maxCount = cards.length > 4 ? 4 : cards.length;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 600 ? 3 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: maxCount,
                  itemBuilder: (context, idx) {
                    final card = cards[idx];
                    return SavedCardThumbnail(
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
                              cardLayout: card.cardLayout,
                              thumbnailBase64: card.thumbnailBase64,
                            );
                        context.push('/card-editor', extra: card);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Padding(
                padding: EdgeInsets.all(horizontalPadding),
                child: Center(child: Text('Error: $err')),
              ),
            ),
            
            const SizedBox(height: 100), // padding at bottom for FAB
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
