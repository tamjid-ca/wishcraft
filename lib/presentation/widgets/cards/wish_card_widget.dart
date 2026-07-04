import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/occasion_themes.dart';
import '../../../data/models/wish_card_model.dart';
import '../../../core/theme/text_styles.dart';

class WishCardWidget extends StatelessWidget {
  final WishCardModel card;
  final String occasionDisplayName;
  final bool interactive;

  const WishCardWidget({
    super.key,
    required this.card,
    required this.occasionDisplayName,
    this.interactive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getOccasionTheme(card.occasionId);
    final textColor = Color(card.textColor);

    return Container(
      width: 360,
      height: 360,
      decoration: BoxDecoration(
        gradient: theme.gradient,
        borderRadius: BorderRadius.circular(20),
        border: card.showBorder
            ? Border.all(
                color: theme.secondaryColor,
                width: 3,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Decorative background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _CardPatternPainter(
                  color: theme.secondaryColor.withOpacity(0.1),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Occasion label
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.secondaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      occasionDisplayName,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.secondaryColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Wish text
                  Text(
                    card.wishText,
                    style: AppTextStyles.cardWishText(
                      fontFamily: card.fontFamily,
                      fontSize: card.fontSize,
                      color: textColor,
                    ),
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 16),

                  // Recipient name
                  if (card.recipientName.isNotEmpty)
                    Text(
                      'To: ${card.recipientName}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: textColor.withOpacity(0.9),
                      ),
                    ),

                  const SizedBox(height: 4),

                  // Sender name
                  if (card.senderName.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '— ${card.senderName}',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Sticker overlays
            ...card.stickerIds.asMap().entries.map((e) {
              final idx = e.key;
              // Stagger stickers in different corners
              final positions = [
                const Alignment(-0.7, -0.7),
                const Alignment(0.7, -0.7),
                const Alignment(0.7, 0.7),
                const Alignment(-0.7, 0.7),
              ];
              final align = positions[idx % positions.length];
              return Align(
                alignment: align,
                child: const Text('✨', style: TextStyle(fontSize: 32)),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _CardPatternPainter extends CustomPainter {
  final Color color;
  _CardPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Top-right decorative circle
    canvas.drawCircle(Offset(size.width + 30, -30), 100, paint);
    // Bottom-left decorative circle
    canvas.drawCircle(Offset(-30, size.height + 30), 80, paint);
  }

  @override
  bool shouldRepaint(covariant _CardPatternPainter oldDelegate) =>
      oldDelegate.color != color;
}
