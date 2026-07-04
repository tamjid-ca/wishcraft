class WishCard {
  final String id;
  final String occasionId;
  final String recipientName;
  final String senderName;
  final String wishText;
  final String templateId;
  final String fontFamily;
  final double fontSize;
  final int textColor;
  final List<String> stickerIds;
  final bool showBorder;
  final String? thumbnailUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WishCard({
    required this.id,
    required this.occasionId,
    required this.recipientName,
    required this.senderName,
    required this.wishText,
    required this.templateId,
    required this.fontFamily,
    required this.fontSize,
    required this.textColor,
    required this.stickerIds,
    required this.showBorder,
    this.thumbnailUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}
