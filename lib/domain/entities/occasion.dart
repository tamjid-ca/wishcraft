import 'package:flutter/material.dart';

class Occasion {
  final String id;
  final String displayName;
  final String emoji;
  final Color primaryColor;
  final Color secondaryColor;

  const Occasion({
    required this.id,
    required this.displayName,
    required this.emoji,
    required this.primaryColor,
    required this.secondaryColor,
  });
}
