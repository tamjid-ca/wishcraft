class WishVariantModel {
  final String id;
  final String text;
  final bool isSelected;

  const WishVariantModel({
    required this.id,
    required this.text,
    this.isSelected = false,
  });

  WishVariantModel copyWith({
    String? id,
    String? text,
    bool? isSelected,
  }) {
    return WishVariantModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
