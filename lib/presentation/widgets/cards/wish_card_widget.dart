import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/occasion_themes.dart';
import '../../../core/theme/card_templates.dart';
import '../../../data/models/wish_card_model.dart';
import '../../../domain/entities/card_layout.dart';
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
    final template = getCardTemplate(card.templateId);
    
    // Determine colors
    final isDefaultColor = card.textColor == 0xFFFFFFFF;
    final textColor = isDefaultColor ? template.textColor : Color(card.textColor);
    final borderColor = card.showBorder ? template.borderColor : Colors.transparent;
    final gradientColors = template.gradientColors;

    // Outer polaroid layout frame setup
    final isPolaroid = card.cardLayout == CardLayout.polaroid;
    
    Widget buildCardContent(BuildContext context, {required bool isInnerPolaroid}) {
      final textAlignment = card.cardLayout == CardLayout.centred ? TextAlign.center : TextAlign.left;
      final crossAlign = card.cardLayout == CardLayout.centred ? CrossAxisAlignment.center : CrossAxisAlignment.start;

      Widget wishTextWidget = Text(
        card.wishText,
        style: AppTextStyles.cardWishText(
          fontFamily: card.fontFamily,
          fontSize: card.fontSize,
          color: isInnerPolaroid ? textColor : (isPolaroid ? Colors.black87 : textColor),
        ),
        textAlign: textAlignment,
        maxLines: 8,
        overflow: TextOverflow.ellipsis,
      );

      // Wrap in splitBand if layout is splitBand
      if (card.cardLayout == CardLayout.splitBand) {
        wishTextWidget = Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: (isInnerPolaroid ? template.borderColor : theme.secondaryColor).withOpacity(0.25),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (isInnerPolaroid ? template.borderColor : theme.secondaryColor).withOpacity(0.5),
              width: 1,
            ),
          ),
          child: wishTextWidget,
        );
      }

      Widget labelWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: (isInnerPolaroid ? template.borderColor : theme.secondaryColor).withOpacity(0.25),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          occasionDisplayName,
          style: AppTextStyles.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isInnerPolaroid ? template.borderColor : theme.secondaryColor,
            letterSpacing: 1.2,
          ),
        ),
      );

      List<Widget> children;
      
      switch (card.cardLayout) {
        case CardLayout.centred:
          children = [
            labelWidget,
            const Spacer(),
            wishTextWidget,
            const Spacer(),
            if (card.recipientName.isNotEmpty)
              Text(
                'To: ${card.recipientName}',
                style: AppTextStyles.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isInnerPolaroid ? textColor.withOpacity(0.9) : textColor.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 4),
            if (card.senderName.isNotEmpty)
              Text(
                '— ${card.senderName}',
                style: AppTextStyles.poppins(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: isInnerPolaroid ? textColor.withOpacity(0.7) : textColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
          ];
          break;
        case CardLayout.topHeavy:
          children = [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                labelWidget,
                if (card.recipientName.isNotEmpty)
                  Text(
                    'To: ${card.recipientName}',
                    style: AppTextStyles.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textColor.withOpacity(0.9),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            wishTextWidget,
            const Spacer(),
            if (card.senderName.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '— ${card.senderName}',
                  style: AppTextStyles.poppins(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ),
          ];
          break;
        case CardLayout.polaroid:
          if (isInnerPolaroid) {
            children = [
              labelWidget,
              const Spacer(),
              wishTextWidget,
              const Spacer(),
            ];
          } else {
            // This case handles the polaroid details on the white frame when not nested
            children = [
              const Spacer(),
              if (card.recipientName.isNotEmpty)
                Text(
                  'To: ${card.recipientName}',
                  style: AppTextStyles.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              if (card.senderName.isNotEmpty)
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '— ${card.senderName}',
                    style: AppTextStyles.poppins(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                ),
            ];
          }
          break;
        case CardLayout.minimal:
        case CardLayout.splitBand:
        case CardLayout.classic:
        default:
          children = [
            labelWidget,
            const Spacer(),
            wishTextWidget,
            const SizedBox(height: 16),
            if (card.recipientName.isNotEmpty)
              Text(
                'To: ${card.recipientName}',
                style: AppTextStyles.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: textColor.withOpacity(0.9),
                ),
              ),
            const SizedBox(height: 4),
            if (card.senderName.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '— ${card.senderName}',
                  style: AppTextStyles.poppins(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ),
          ];
          break;
      }

      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: crossAlign,
          children: children,
        ),
      );
    }

    final boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(isPolaroid ? 8 : 20),
      border: card.showBorder
          ? Border.all(
              color: borderColor,
              width: 3,
            )
          : null,
    );

    // If it's polaroid, the card itself is white and contains a nested colored box
    if (isPolaroid) {
      return Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: card.showBorder ? Border.all(color: Colors.grey.shade300, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Container(decoration: boxDecoration),
                    // Pattern (unless minimal)
                    if (card.cardLayout != CardLayout.minimal)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _CardPatternPainter(
                            color: template.borderColor.withOpacity(0.15),
                            pattern: template.pattern,
                          ),
                        ),
                      ),
                    buildCardContent(context, isInnerPolaroid: true),
                    // Stickers inside polaroid
                    ...card.stickerIds.asMap().entries.map((e) {
                      final idx = e.key;
                      final positions = [
                        const Alignment(-0.75, -0.75),
                        const Alignment(0.75, -0.75),
                        const Alignment(0.75, 0.75),
                        const Alignment(-0.75, 0.75),
                      ];
                      final align = positions[idx % positions.length];
                      return Align(
                        alignment: align,
                        child: Text(
                          e.value.contains('heart') ? '❤️' : (e.value.contains('star') ? '✨' : '🌸'),
                          style: const TextStyle(fontSize: 28),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Text area on the white frame of polaroid
            if (card.recipientName.isNotEmpty || card.senderName.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (card.recipientName.isNotEmpty)
                      Text(
                        'To: ${card.recipientName}',
                        style: AppTextStyles.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    if (card.senderName.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '— ${card.senderName}',
                          style: AppTextStyles.poppins(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    return Container(
      width: 360,
      height: 360,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: card.showBorder
            ? Border.all(
                color: borderColor,
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
            if (card.cardLayout != CardLayout.minimal)
              Positioned.fill(
                child: CustomPaint(
                  painter: _CardPatternPainter(
                    color: template.borderColor.withOpacity(0.15),
                    pattern: template.pattern,
                  ),
                ),
              ),

            // Content
            buildCardContent(context, isInnerPolaroid: false),

            // Sticker overlays
            ...card.stickerIds.asMap().entries.map((e) {
              final idx = e.key;
              final positions = [
                const Alignment(-0.7, -0.7),
                const Alignment(0.7, -0.7),
                const Alignment(0.7, 0.7),
                const Alignment(-0.7, 0.7),
              ];
              final align = positions[idx % positions.length];
              return Align(
                alignment: align,
                child: Text(
                  e.value.contains('heart') ? '❤️' : (e.value.contains('star') ? '✨' : '🌸'),
                  style: const TextStyle(fontSize: 32),
                ),
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
  final CardPattern pattern;

  _CardPatternPainter({required this.color, required this.pattern});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (pattern) {
      case CardPattern.circles:
        canvas.drawCircle(Offset(size.width + 30, -30), 100, paint);
        canvas.drawCircle(Offset(-30, size.height + 30), 80, paint);
        break;
      case CardPattern.waves:
        final path = Path();
        path.moveTo(0, size.height * 0.8);
        path.quadraticBezierTo(size.width * 0.25, size.height * 0.7, size.width * 0.5, size.height * 0.8);
        path.quadraticBezierTo(size.width * 0.75, size.height * 0.9, size.width, size.height * 0.8);
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        path.close();
        canvas.drawPath(path, paint);

        final path2 = Path();
        path2.moveTo(0, size.height * 0.2);
        path2.quadraticBezierTo(size.width * 0.25, size.height * 0.3, size.width * 0.5, size.height * 0.2);
        path2.quadraticBezierTo(size.width * 0.75, size.height * 0.1, size.width, size.height * 0.2);
        path2.lineTo(size.width, 0);
        path2.lineTo(0, 0);
        path2.close();
        canvas.drawPath(path2, paint);
        break;
      case CardPattern.stars:
        final strokePaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        _drawStarShape(canvas, Offset(size.width * 0.8, size.height * 0.2), 15, strokePaint);
        _drawStarShape(canvas, Offset(size.width * 0.2, size.height * 0.7), 20, strokePaint);
        _drawStarShape(canvas, Offset(size.width * 0.85, size.height * 0.8), 10, strokePaint);
        break;
      case CardPattern.floral:
        // Simple leaf/flower shapes
        canvas.drawOval(Rect.fromCenter(center: Offset(size.width * 0.85, 40), width: 60, height: 30), paint);
        canvas.drawOval(Rect.fromCenter(center: Offset(40, size.height * 0.85), width: 30, height: 60), paint);
        break;
      case CardPattern.hearts:
        _drawHeartShape(canvas, Offset(size.width * 0.85, size.height * 0.15), 25, paint);
        _drawHeartShape(canvas, Offset(size.width * 0.15, size.height * 0.85), 20, paint);
        break;
      case CardPattern.stripes:
        final stripePaint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;
        for (double i = -size.width; i < size.width * 2; i += 24) {
          canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), stripePaint);
        }
        break;
      case CardPattern.dots:
        for (double x = 15; x < size.width; x += 30) {
          for (double y = 15; y < size.height; y += 30) {
            canvas.drawCircle(Offset(x, y), 2, paint);
          }
        }
        break;
      case CardPattern.geometric:
        final path = Path();
        path.moveTo(size.width, 0);
        path.lineTo(size.width - 80, 0);
        path.lineTo(size.width, 80);
        path.close();
        canvas.drawPath(path, paint);

        final path2 = Path();
        path2.moveTo(0, size.height);
        path2.lineTo(80, size.height);
        path2.lineTo(0, size.height - 80);
        path2.close();
        canvas.drawPath(path2, paint);
        break;
      case CardPattern.none:
      default:
        break;
    }
  }

  void _drawStarShape(Canvas canvas, Offset center, double size, Paint paint) {
    canvas.drawLine(Offset(center.dx - size, center.dy), Offset(center.dx + size, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - size), Offset(center.dx, center.dy + size), paint);
    canvas.drawLine(Offset(center.dx - size * 0.7, center.dy - size * 0.7), Offset(center.dx + size * 0.7, center.dy + size * 0.7), paint);
    canvas.drawLine(Offset(center.dx - size * 0.7, center.dy + size * 0.7), Offset(center.dx + size * 0.7, center.dy - size * 0.7), paint);
  }

  void _drawHeartShape(Canvas canvas, Offset center, double width, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy + width * 0.3);
    path.cubicTo(center.dx - width / 2, center.dy - width / 2, center.dx - width, center.dy + width / 4, center.dx, center.dy + width);
    path.cubicTo(center.dx + width, center.dy + width / 4, center.dx + width / 2, center.dy - width / 2, center.dx, center.dy + width * 0.3);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CardPatternPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.pattern != pattern;
}
