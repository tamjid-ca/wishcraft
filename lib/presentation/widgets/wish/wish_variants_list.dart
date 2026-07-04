import 'package:flutter/material.dart';
import '../../../data/models/wish_variant_model.dart';
import 'wish_variant_card.dart';

class WishVariantsList extends StatelessWidget {
  final List<WishVariantModel> variants;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;
  final ValueChanged<int> onRegenerate;
  final Function(int, String) onEdit;

  const WishVariantsList({
    super.key,
    required this.variants,
    required this.selectedIndex,
    required this.onSelect,
    required this.onRegenerate,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: variants.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final variant = variants[idx];
        return WishVariantCard(
          variant: variant,
          isSelected: idx == selectedIndex,
          onTap: () => onSelect(idx),
          onRegenerate: () => onRegenerate(idx),
          onEdit: (text) => onEdit(idx, text),
        );
      },
    );
  }
}
