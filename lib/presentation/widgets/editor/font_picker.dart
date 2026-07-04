import 'package:flutter/material.dart';

class FontPicker extends StatelessWidget {
  final String selectedFontFamily;
  final ValueChanged<String> onSelect;

  static const List<String> fonts = [
    'Playfair Display',
    'Dancing Script',
    'Montserrat',
    'Lato',
    'Sacramento',
    'Nunito',
  ];

  const FontPicker({
    super.key,
    required this.selectedFontFamily,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: fonts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final font = fonts[idx];
          final isSelected = font == selectedFontFamily;
          return ChoiceChip(
            label: Text(font),
            selected: isSelected,
            onSelected: (_) => onSelect(font),
          );
        },
      ),
    );
  }
}
