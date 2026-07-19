import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/providers.dart';
import '../../viewmodels/saved_cards_viewmodel.dart';
import '../../widgets/cards/saved_card_thumbnail.dart';
import '../../widgets/common/wc_app_bar.dart';
import '../../widgets/common/wc_empty_state.dart';

class SavedCardsScreen extends ConsumerWidget {
  const SavedCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savedCardsViewModelProvider);
    final notifier = ref.read(savedCardsViewModelProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: const WcAppBar(title: AppStrings.savedCards),
      body: state.cards.when(
        data: (cards) {
          final filtered = state.filteredCards;
          if (filtered.isEmpty) {
            return WcEmptyState(
              icon: Icons.folder_open_outlined,
              title: AppStrings.noSavedCards,
              subtitle: AppStrings.noSavedCardsSubtitle,
              actionLabel: 'Create a Card',
              onAction: () => context.push('/occasions'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth > 600 ? 3 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, idx) {
              final card = filtered[idx];
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
                onLongPress: () => _showDeleteDialog(context, notifier, card.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text('Error loading cards: $err',
              style: theme.textTheme.bodyMedium?.copyWith(color: cs.error)),
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, SavedCardsViewModel notifier, String cardId) {
    showDialog(
      context: context,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return AlertDialog(
          title: const Text('Delete Saved Card?'),
          content: const Text('Are you sure you want to delete this card?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                notifier.deleteCard(cardId);
                Navigator.pop(context);
              },
              child: Text('Delete', style: TextStyle(color: cs.error)),
            ),
          ],
        );
      },
    );
  }
}
