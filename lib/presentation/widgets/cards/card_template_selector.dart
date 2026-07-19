import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/occasion_themes.dart';
import '../../../data/models/wish_card_model.dart';
import '../../../domain/entities/card_layout.dart';
import 'wish_card_widget.dart';

class CardTemplateSelector extends StatelessWidget {
  final List<String> templateIds;
  final String selectedId;
  final String occasionId;
  final ValueChanged<String> onSelect;

  const CardTemplateSelector({
    super.key,
    required this.templateIds,
    required this.selectedId,
    required this.occasionId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getOccasionTheme(occasionId);
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: templateIds.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, idx) {
          final id = templateIds[idx];
          final isSelected = id == selectedId;

          // Build a dummy card model specifically for this template preview
          final previewCard = WishCardModel(
            id: 'preview_$id',
            occasionId: occasionId,
            recipientName: 'To You',
            senderName: 'Me',
            wishText: 'Best Wishes',
            templateId: id,
            fontFamily: 'Poppins',
            fontSize: 16,
            textColor: Colors.white.value,
            stickerIds: const [],
            showBorder: false,
            cardLayout: CardLayout.classic,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          return GestureDetector(
            onTap: () => onSelect(id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? theme.secondaryColor : Colors.grey.withOpacity(0.3),
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: WishCardWidget(
                    card: previewCard,
                    occasionDisplayName: '',
                  ),
                ),
              ),
            ).animate().scale(duration: 200.ms),
          );
        },
      ),
    );
  }
}
