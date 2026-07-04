import 'package:flutter/material.dart';

class ColorPalettePicker extends StatelessWidget {
  final int selectedColorValue;
  final ValueChanged<Color> onSelect;

  static const List<Color> colors = [
    Colors.white,
    Colors.black,
    Color(0xFFFFD700), // Gold
    Color(0xFFFF8A80), // Light Red
    Color(0xFFE91E63), // Pink
    Color(0xFF81D4FA), // Light Blue
    Color(0xFF4CAF50), // Green
    Color(0xFFE040FB), // Neon Purple
    Color(0xFF263238), // Dark Blue Grey
  ];

  const ColorPalettePicker({
    super.key,
    required this.selectedColorValue,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: colors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, idx) {
          final color = colors[idx];
          final isSelected = color.value == selectedColorValue;
          return GestureDetector(
            onTap: () => onSelect(color),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey[400]!,
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.4),
                          blurRadius: 6,
                        )
                      ]
                    : [],
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: color == Colors.white ? Colors.black : Colors.white,
                      size: 18,
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
