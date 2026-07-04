import 'package:flutter/material.dart';

class OccasionTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final List<Color> gradientColors;

  const OccasionTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.gradientColors,
  });

  LinearGradient get gradient => LinearGradient(
        colors: gradientColors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

const Map<String, OccasionTheme> occasionThemes = {
  'fathers_day': OccasionTheme(
    primaryColor: Color(0xFF1A3C5E),
    secondaryColor: Color(0xFFD4A853),
    accentColor: Color(0xFFE8F4FD),
    gradientColors: [Color(0xFF1A3C5E), Color(0xFF2E6DA4)],
  ),
  'mothers_day': OccasionTheme(
    primaryColor: Color(0xFFE91E8C),
    secondaryColor: Color(0xFFFFF0F5),
    accentColor: Color(0xFFFF6BB5),
    gradientColors: [Color(0xFFFF6BB5), Color(0xFFFF9ED8)],
  ),
  'birthday': OccasionTheme(
    primaryColor: Color(0xFF7B2FBE),
    secondaryColor: Color(0xFFFFD700),
    accentColor: Color(0xFFFF6B6B),
    gradientColors: [Color(0xFF7B2FBE), Color(0xFFE040FB)],
  ),
  'anniversary': OccasionTheme(
    primaryColor: Color(0xFFB71C1C),
    secondaryColor: Color(0xFFFFD700),
    accentColor: Color(0xFFFF8A80),
    gradientColors: [Color(0xFFB71C1C), Color(0xFFE53935)],
  ),
  'eid': OccasionTheme(
    primaryColor: Color(0xFF00695C),
    secondaryColor: Color(0xFFFFD700),
    accentColor: Color(0xFFE8F5E9),
    gradientColors: [Color(0xFF00695C), Color(0xFF00897B)],
  ),
  'christmas': OccasionTheme(
    primaryColor: Color(0xFF1B5E20),
    secondaryColor: Color(0xFFC62828),
    accentColor: Color(0xFFFFD700),
    gradientColors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
  ),
  'new_year': OccasionTheme(
    primaryColor: Color(0xFF1A237E),
    secondaryColor: Color(0xFFFFD700),
    accentColor: Color(0xFF7986CB),
    gradientColors: [Color(0xFF1A237E), Color(0xFF303F9F)],
  ),
  'diwali': OccasionTheme(
    primaryColor: Color(0xFFE65100),
    secondaryColor: Color(0xFFFFD700),
    accentColor: Color(0xFFFF6D00),
    gradientColors: [Color(0xFFE65100), Color(0xFFF57C00)],
  ),
  'graduation': OccasionTheme(
    primaryColor: Color(0xFF004D40),
    secondaryColor: Color(0xFFFFD700),
    accentColor: Color(0xFF80CBC4),
    gradientColors: [Color(0xFF004D40), Color(0xFF00695C)],
  ),
  'valentine': OccasionTheme(
    primaryColor: Color(0xFFAD1457),
    secondaryColor: Color(0xFFF8BBD0),
    accentColor: Color(0xFFFF80AB),
    gradientColors: [Color(0xFFAD1457), Color(0xFFE91E63)],
  ),
  'friendship': OccasionTheme(
    primaryColor: Color(0xFF0277BD),
    secondaryColor: Color(0xFFFFF9C4),
    accentColor: Color(0xFF81D4FA),
    gradientColors: [Color(0xFF0277BD), Color(0xFF0288D1)],
  ),
  'get_well': OccasionTheme(
    primaryColor: Color(0xFF2E7D32),
    secondaryColor: Color(0xFFF1F8E9),
    accentColor: Color(0xFFA5D6A7),
    gradientColors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
  ),
  'thank_you': OccasionTheme(
    primaryColor: Color(0xFF4527A0),
    secondaryColor: Color(0xFFEDE7F6),
    accentColor: Color(0xFFB39DDB),
    gradientColors: [Color(0xFF4527A0), Color(0xFF512DA8)],
  ),
  'congratulations': OccasionTheme(
    primaryColor: Color(0xFF827717),
    secondaryColor: Color(0xFFFFFDE7),
    accentColor: Color(0xFFFFEE58),
    gradientColors: [Color(0xFF827717), Color(0xFFF9A825)],
  ),
  'custom': OccasionTheme(
    primaryColor: Color(0xFF6B3FA0),
    secondaryColor: Color(0xFFFF6B9D),
    accentColor: Color(0xFFFFD700),
    gradientColors: [Color(0xFF6B3FA0), Color(0xFFFF6B9D)],
  ),
};

OccasionTheme getOccasionTheme(String occasionId) {
  return occasionThemes[occasionId] ?? occasionThemes['custom']!;
}
