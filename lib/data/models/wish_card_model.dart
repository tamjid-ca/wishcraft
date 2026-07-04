import 'package:cloud_firestore/cloud_firestore.dart';

class WishCardModel {
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

  const WishCardModel({
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

  factory WishCardModel.fromJson(Map<String, dynamic> json, String id) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.parse(val);
      return DateTime.now();
    }

    return WishCardModel(
      id: id,
      occasionId: json['occasionId'] as String? ?? '',
      recipientName: json['recipientName'] as String? ?? '',
      senderName: json['senderName'] as String? ?? '',
      wishText: json['wishText'] as String? ?? '',
      templateId: json['templateId'] as String? ?? 'template_01',
      fontFamily: json['fontFamily'] as String? ?? 'Playfair Display',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 18.0,
      textColor: (json['textColor'] as num?)?.toInt() ?? 0xFFFFFFFF,
      stickerIds: List<String>.from(json['stickerIds'] as List? ?? []),
      showBorder: json['showBorder'] as bool? ?? false,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'occasionId': occasionId,
      'recipientName': recipientName,
      'senderName': senderName,
      'wishText': wishText,
      'templateId': templateId,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'textColor': textColor,
      'stickerIds': stickerIds,
      'showBorder': showBorder,
      'thumbnailUrl': thumbnailUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  WishCardModel copyWith({
    String? id,
    String? occasionId,
    String? recipientName,
    String? senderName,
    String? wishText,
    String? templateId,
    String? fontFamily,
    double? fontSize,
    int? textColor,
    List<String>? stickerIds,
    bool? showBorder,
    String? thumbnailUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WishCardModel(
      id: id ?? this.id,
      occasionId: occasionId ?? this.occasionId,
      recipientName: recipientName ?? this.recipientName,
      senderName: senderName ?? this.senderName,
      wishText: wishText ?? this.wishText,
      templateId: templateId ?? this.templateId,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      textColor: textColor ?? this.textColor,
      stickerIds: stickerIds ?? this.stickerIds,
      showBorder: showBorder ?? this.showBorder,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
