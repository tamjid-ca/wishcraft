import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/occasion_themes.dart';
import '../../../data/models/occasion_model.dart';

class OccasionGrid extends StatelessWidget {
  final List<OccasionModel> occasions;
  final ValueChanged<OccasionModel> onTap;

  const OccasionGrid({
    super.key,
    required this.occasions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.4,
      ),
      itemCount: occasions.length,
      itemBuilder: (context, idx) {
        final occasion = occasions[idx];
        return _OccasionCard(
          occasion: occasion,
          onTap: () => onTap(occasion),
          delay: Duration(milliseconds: idx * 60),
        );
      },
    );
  }
}

class _OccasionCard extends StatelessWidget {
  final OccasionModel occasion;
  final VoidCallback onTap;
  final Duration delay;

  const _OccasionCard({
    required this.occasion,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getOccasionTheme(occasion.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: theme.gradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              right: -10,
              bottom: -10,
              child: Text(
                occasion.emoji,
                style: const TextStyle(fontSize: 56),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    occasion.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const Spacer(),
                  Text(
                    occasion.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate(delay: delay).slideY(begin: 0.3, duration: 400.ms, curve: Curves.easeOut).fade(),
    );
  }
}
