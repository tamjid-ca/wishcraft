import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/occasion_themes.dart';
import '../../../data/models/wish_card_model.dart';

class SavedCardThumbnail extends StatelessWidget {
  final WishCardModel card;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const SavedCardThumbnail({
    super.key,
    required this.card,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getOccasionTheme(card.occasionId);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: card.thumbnailUrl != null
            ? CachedNetworkImage(
                imageUrl: card.thumbnailUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(color: Colors.grey[300]),
                ),
                errorWidget: (context, url, error) => _Placeholder(theme: theme, card: card),
              )
            : _Placeholder(theme: theme, card: card),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final OccasionTheme theme;
  final WishCardModel card;

  const _Placeholder({required this.theme, required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: theme.gradient),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              card.recipientName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                card.wishText,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
