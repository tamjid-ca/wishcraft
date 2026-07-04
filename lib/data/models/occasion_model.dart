import 'package:flutter/material.dart';

class OccasionModel {
  final String id;
  final String displayName;
  final String emoji;
  final Color primaryColor;
  final Color secondaryColor;
  final String templateFolder;
  final List<String> templateIds;

  const OccasionModel({
    required this.id,
    required this.displayName,
    required this.emoji,
    required this.primaryColor,
    required this.secondaryColor,
    required this.templateFolder,
    required this.templateIds,
  });
}

const List<OccasionModel> occasions = [
  OccasionModel(
    id: 'fathers_day',
    displayName: "Father's Day",
    emoji: '👨',
    primaryColor: Color(0xFF1A3C5E),
    secondaryColor: Color(0xFFD4A853),
    templateFolder: 'assets/images/templates/fathers_day/',
    templateIds: ['fd_01', 'fd_02', 'fd_03'],
  ),
  OccasionModel(
    id: 'mothers_day',
    displayName: "Mother's Day",
    emoji: '👩',
    primaryColor: Color(0xFFE91E8C),
    secondaryColor: Color(0xFFFFF0F5),
    templateFolder: 'assets/images/templates/mothers_day/',
    templateIds: ['md_01', 'md_02', 'md_03'],
  ),
  OccasionModel(
    id: 'birthday',
    displayName: 'Birthday',
    emoji: '🎂',
    primaryColor: Color(0xFF7B2FBE),
    secondaryColor: Color(0xFFFFD700),
    templateFolder: 'assets/images/templates/birthday/',
    templateIds: ['bd_01', 'bd_02', 'bd_03'],
  ),
  OccasionModel(
    id: 'anniversary',
    displayName: 'Anniversary',
    emoji: '💑',
    primaryColor: Color(0xFFB71C1C),
    secondaryColor: Color(0xFFFFD700),
    templateFolder: 'assets/images/templates/general/',
    templateIds: ['gen_01', 'gen_02'],
  ),
  OccasionModel(
    id: 'eid',
    displayName: 'Eid Mubarak',
    emoji: '🌙',
    primaryColor: Color(0xFF00695C),
    secondaryColor: Color(0xFFFFD700),
    templateFolder: 'assets/images/templates/eid/',
    templateIds: ['eid_01', 'eid_02', 'eid_03'],
  ),
  OccasionModel(
    id: 'christmas',
    displayName: 'Christmas',
    emoji: '🎄',
    primaryColor: Color(0xFF1B5E20),
    secondaryColor: Color(0xFFC62828),
    templateFolder: 'assets/images/templates/christmas/',
    templateIds: ['xmas_01', 'xmas_02', 'xmas_03'],
  ),
  OccasionModel(
    id: 'new_year',
    displayName: 'New Year',
    emoji: '🎆',
    primaryColor: Color(0xFF1A237E),
    secondaryColor: Color(0xFFFFD700),
    templateFolder: 'assets/images/templates/general/',
    templateIds: ['gen_01', 'gen_02'],
  ),
  OccasionModel(
    id: 'diwali',
    displayName: 'Diwali',
    emoji: '🪔',
    primaryColor: Color(0xFFE65100),
    secondaryColor: Color(0xFFFFD700),
    templateFolder: 'assets/images/templates/general/',
    templateIds: ['gen_01', 'gen_02'],
  ),
  OccasionModel(
    id: 'graduation',
    displayName: 'Graduation',
    emoji: '🎓',
    primaryColor: Color(0xFF004D40),
    secondaryColor: Color(0xFFFFD700),
    templateFolder: 'assets/images/templates/general/',
    templateIds: ['gen_01', 'gen_02'],
  ),
  OccasionModel(
    id: 'valentine',
    displayName: "Valentine's Day",
    emoji: '❤️',
    primaryColor: Color(0xFFAD1457),
    secondaryColor: Color(0xFFF8BBD0),
    templateFolder: 'assets/images/templates/general/',
    templateIds: ['gen_01', 'gen_02'],
  ),
  OccasionModel(
    id: 'friendship',
    displayName: 'Friendship Day',
    emoji: '🤝',
    primaryColor: Color(0xFF0277BD),
    secondaryColor: Color(0xFFFFF9C4),
    templateFolder: 'assets/images/templates/general/',
    templateIds: ['gen_01', 'gen_02'],
  ),
  OccasionModel(
    id: 'get_well',
    displayName: 'Get Well Soon',
    emoji: '🌻',
    primaryColor: Color(0xFF2E7D32),
    secondaryColor: Color(0xFFF1F8E9),
    templateFolder: 'assets/images/templates/general/',
    templateIds: ['gen_01', 'gen_02'],
  ),
  OccasionModel(
    id: 'thank_you',
    displayName: 'Thank You',
    emoji: '🙏',
    primaryColor: Color(0xFF4527A0),
    secondaryColor: Color(0xFFEDE7F6),
    templateFolder: 'assets/images/templates/general/',
    templateIds: ['gen_01', 'gen_02'],
  ),
  OccasionModel(
    id: 'congratulations',
    displayName: 'Congratulations',
    emoji: '🏆',
    primaryColor: Color(0xFF827717),
    secondaryColor: Color(0xFFFFFDE7),
    templateFolder: 'assets/images/templates/general/',
    templateIds: ['gen_01', 'gen_02'],
  ),
  OccasionModel(
    id: 'custom',
    displayName: 'Custom',
    emoji: '✨',
    primaryColor: Color(0xFF6B3FA0),
    secondaryColor: Color(0xFFFF6B9D),
    templateFolder: 'assets/images/templates/general/',
    templateIds: ['gen_01', 'gen_02'],
  ),
];
