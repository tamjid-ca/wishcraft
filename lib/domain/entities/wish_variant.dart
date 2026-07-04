class WishVariant {
  final String id;
  final String text;
  final bool isSelected;

  const WishVariant({
    required this.id,
    required this.text,
    this.isSelected = false,
  });
}
