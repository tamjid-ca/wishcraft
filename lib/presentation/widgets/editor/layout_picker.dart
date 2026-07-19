import 'package:flutter/material.dart';
import '../../../domain/entities/card_layout.dart';

class LayoutPicker extends StatelessWidget {
  final CardLayout selectedLayout;
  final ValueChanged<CardLayout> onSelect;

  const LayoutPicker({
    super.key,
    required this.selectedLayout,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Card Layout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 55,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: CardLayout.values.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, idx) {
              final layout = CardLayout.values[idx];
              final isSelected = layout == selectedLayout;
              final displayName = _getLayoutName(layout);
              return ChoiceChip(
                label: Text(displayName),
                selected: isSelected,
                selectedColor: Theme.of(context).primaryColor,
                onSelected: (_) => onSelect(layout),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getLayoutName(CardLayout layout) {
    switch (layout) {
      case CardLayout.classic:
        return 'Classic';
      case CardLayout.centred:
        return 'Centred';
      case CardLayout.topHeavy:
        return 'Top Heavy';
      case CardLayout.minimal:
        return 'Minimal';
      case CardLayout.splitBand:
        return 'Split Band';
      case CardLayout.polaroid:
        return 'Polaroid';
    }
  }
}
