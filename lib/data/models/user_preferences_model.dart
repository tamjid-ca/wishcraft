class UserPreferencesModel {
  final String defaultFont;
  final String defaultTone;
  final String themeMode; // 'light' | 'dark' | 'system'

  const UserPreferencesModel({
    this.defaultFont = 'Playfair Display',
    this.defaultTone = 'Heartfelt',
    this.themeMode = 'system',
  });

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      defaultFont: json['defaultFont'] as String? ?? 'Playfair Display',
      defaultTone: json['defaultTone'] as String? ?? 'Heartfelt',
      themeMode: json['themeMode'] as String? ?? 'system',
    );
  }

  Map<String, dynamic> toJson() => {
        'defaultFont': defaultFont,
        'defaultTone': defaultTone,
        'themeMode': themeMode,
      };

  UserPreferencesModel copyWith({
    String? defaultFont,
    String? defaultTone,
    String? themeMode,
  }) {
    return UserPreferencesModel(
      defaultFont: defaultFont ?? this.defaultFont,
      defaultTone: defaultTone ?? this.defaultTone,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
