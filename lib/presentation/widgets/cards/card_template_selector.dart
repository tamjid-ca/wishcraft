import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/occasion_themes.dart';

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
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: templateIds.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, idx) {
          final id = templateIds[idx];
          final isSelected = id == selectedId;
          return GestureDetector(
            onTap: () => onSelect(id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: theme.gradient,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? theme.secondaryColor : Colors.transparent,
                  width: 3,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: theme.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 8,
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  '${idx + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
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
