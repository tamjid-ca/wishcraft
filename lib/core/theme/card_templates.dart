import 'package:flutter/material.dart';

enum CardPattern {
  circles,
  waves,
  stars,
  floral,
  hearts,
  stripes,
  dots,
  geometric,
  none,
}

class CardTemplate {
  final String id;
  final String name;
  final List<Color> gradientColors;
  final Color textColor;
  final Color borderColor;
  final CardPattern pattern;

  const CardTemplate({
    required this.id,
    required this.name,
    required this.gradientColors,
    required this.textColor,
    required this.borderColor,
    required this.pattern,
  });
}

const List<CardTemplate> cardTemplates = [
  CardTemplate(
    id: 'template_01',
    name: 'Sunset Glow',
    gradientColors: [Color(0xFFFF5F6D), Color(0xFFFFC371)],
    textColor: Colors.white,
    borderColor: Color(0xFFFFE0B2),
    pattern: CardPattern.circles,
  ),
  CardTemplate(
    id: 'template_02',
    name: 'Ocean Breeze',
    gradientColors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
    textColor: Colors.white,
    borderColor: Color(0xFFE0F7FA),
    pattern: CardPattern.waves,
  ),
  CardTemplate(
    id: 'template_03',
    name: 'Midnight Star',
    gradientColors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
    textColor: Color(0xFFFFF9C4),
    borderColor: Color(0xFFFFD700),
    pattern: CardPattern.stars,
  ),
  CardTemplate(
    id: 'template_04',
    name: 'Forest Moss',
    gradientColors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    textColor: Colors.white,
    borderColor: Color(0xFFE8F5E9),
    pattern: CardPattern.floral,
  ),
  CardTemplate(
    id: 'template_05',
    name: 'Rose Quartz',
    gradientColors: [Color(0xFFF3A183), Color(0xFFEC6F66)],
    textColor: Colors.white,
    borderColor: Color(0xFFFFEBEE),
    pattern: CardPattern.hearts,
  ),
  CardTemplate(
    id: 'template_06',
    name: 'Golden Hour',
    gradientColors: [Color(0xFFF21B3F), Color(0xFFFF9900)],
    textColor: Colors.white,
    borderColor: Color(0xFFFFF9C4),
    pattern: CardPattern.geometric,
  ),
  CardTemplate(
    id: 'template_07',
    name: 'Royal Lavender',
    gradientColors: [Color(0xFFDA4453), Color(0xFF89216B)],
    textColor: Color(0xFFFFF3E0),
    borderColor: Color(0xFFFFE0B2),
    pattern: CardPattern.geometric,
  ),
  CardTemplate(
    id: 'template_08',
    name: 'Cherry Blossom',
    gradientColors: [Color(0xFFFFC0CB), Color(0xFFFBC2EB)],
    textColor: Color(0xFFAD1457),
    borderColor: Color(0xFFF8BBD0),
    pattern: CardPattern.dots,
  ),
  CardTemplate(
    id: 'template_09',
    name: 'Cyberpunk Neon',
    gradientColors: [Color(0xFF000000), Color(0xFF434343)],
    textColor: Color(0xFF00FFCC),
    borderColor: Color(0xFFFF007F),
    pattern: CardPattern.stripes,
  ),
  CardTemplate(
    id: 'template_10',
    name: 'Vintage Sepia',
    gradientColors: [Color(0xFFE6D5B8), Color(0xFFE1B382)],
    textColor: Color(0xFF3E2723),
    borderColor: Color(0xFFD7CCC8),
    pattern: CardPattern.none,
  ),
  CardTemplate(
    id: 'template_11',
    name: 'Aurora Borealis',
    gradientColors: [Color(0xFF0575E6), Color(0xFF00F260)],
    textColor: Colors.white,
    borderColor: Color(0xFFE0F2F1),
    pattern: CardPattern.waves,
  ),
  CardTemplate(
    id: 'template_12',
    name: 'Minimal Stark',
    gradientColors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
    textColor: Colors.black,
    borderColor: Colors.black,
    pattern: CardPattern.none,
  ),
];

CardTemplate getCardTemplate(String id) {
  return cardTemplates.firstWhere(
    (t) => t.id == id,
    orElse: () => cardTemplates.first,
  );
}
