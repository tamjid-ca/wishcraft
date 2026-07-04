import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/providers.dart';
import '../../widgets/cards/saved_card_thumbnail.dart';

class SavedCardsScreen extends ConsumerWidget {
  const SavedCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savedCardsViewModelProvider);
    final notifier = ref.read(savedCardsViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.savedCards),
      ),
      body: state.cards.when(
        data: (cards) {
          final filtered = state.filteredCards;
          if (filtered.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(AppStrings.noSavedCards, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(AppStrings.noSavedCardsSubtitle, style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
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
                      );
                  context.push('/card-editor', extra: card);
                },
                onLongPress: () => _showDeleteDialog(context, notifier, card.id),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading cards: $err')),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, SavedCardsViewModel notifier, String cardId) {
    showDialog(
      context: context,
      builder: (context) {
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
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
