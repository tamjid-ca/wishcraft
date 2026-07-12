import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/occasion_themes.dart';
import '../../../data/models/occasion_model.dart';

class OccasionChip extends StatelessWidget {
  final OccasionModel occasion;
  final VoidCallback onTap;
  final bool isSelected;

  const OccasionChip({
    super.key,
    required this.occasion,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = getOccasionTheme(occasion.id);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? theme.gradient : null,
          color: isSelected ? null : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected ? Colors.transparent : theme.primaryColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(occasion.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              occasion.displayName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : theme.primaryColor,
              ),
            ),
          ],
        ),
      ).animate().scale(duration: 200.ms),
    );
  }
}
