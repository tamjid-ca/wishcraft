import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/occasion_model.dart';
import '../../../providers/providers.dart';
import '../../widgets/cards/saved_card_thumbnail.dart';
import '../../widgets/common/wc_app_bar.dart';
import '../../widgets/common/wc_section_header.dart';
import '../../widgets/common/wc_empty_state.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final savedCardsAsync = ref.watch(savedCardsViewModelProvider).cards;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final hPad = screenWidth > 600 ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: WcAppBar(
        title: AppStrings.appName,
        showGradientBorder: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: user?.photoUrl != null
              ? CircleAvatar(backgroundImage: NetworkImage(user!.photoUrl!))
              : CircleAvatar(
                  backgroundColor: cs.primaryContainer,
                  child: Icon(Icons.person, color: cs.onPrimaryContainer),
                ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outlined),
            tooltip: 'My Cards',
            onPressed: () => context.push('/saved-cards'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // ── Hero banner ────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 0),
              child: _HeroBanner(
                userName: user?.displayName ?? 'Friend',
                onCreateTap: () => context.push('/occasions'),
              ),
            ),
          ),

          // ── Browse Categories ───────────────────────────────────
          SliverToBoxAdapter(
            child: WcSectionHeader(
              title: 'Browse Categories',
              padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 8),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: hPad),
                itemCount: occasions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final o = occasions[idx];
                  return ActionChip(
                    avatar: Text(o.emoji, style: const TextStyle(fontSize: 16)),
                    label: Text(o.displayName),
                    onPressed: () => context.push('/wish-generator/${o.id}'),
                  );
                },
              ),
            ),
          ),

          // ── Recent Cards ────────────────────────────────────────
          SliverToBoxAdapter(
            child: WcSectionHeader(
              title: AppStrings.recentCards,
              padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 8),
              trailing: TextButton(
                onPressed: () => context.push('/saved-cards'),
                child: Text(
                  'See all',
                  style: TextStyle(color: cs.primary),
                ),
              ),
            ),
          ),
          savedCardsAsync.when(
            data: (cards) {
              if (cards.isEmpty) {
                return SliverToBoxAdapter(
                  child: WcEmptyState(
                    icon: Icons.card_giftcard_outlined,
                    title: AppStrings.noRecentCards,
                    subtitle: 'Tap "Create Card" below to get started!',
                    actionLabel: 'Create Card',
                    onAction: () => context.push('/occasions'),
                  ),
                );
              }
              final maxCount = cards.length > 4 ? 4 : cards.length;
              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: hPad),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, idx) {
                      final card = cards[idx];
                      return SavedCardThumbnail(
                        card: card,
                        onTap: () {
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
                    childCount: maxCount,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 600 ? 3 : 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (err, _) => SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(hPad),
                child: Center(child: Text('Error: $err')),
              ),
            ),
          ),

          // Bottom padding for FAB
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
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

/// The glassmorphic hero banner on the home screen.
class _HeroBanner extends StatelessWidget {
  final String userName;
  final VoidCallback onCreateTap;

  const _HeroBanner({required this.userName, required this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        children: [
          // Gradient base
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          // Decorative circles
          Positioned(
            left: -20,
            top: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
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
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Glassmorphic content
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hello, $userName! 👋',
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
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        onPressed: onCreateTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.92),
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text('Create New Card',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
