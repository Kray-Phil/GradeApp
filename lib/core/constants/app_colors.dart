import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryDark = Color(0xFF3730A3);

  // Accent Palette
  static const Color accent = Color(0xFF0D9488); // Teal
  static const Color accentLight = Color(0xFF2DD4BF);
  static const Color accentDark = Color(0xFF0F766E);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  // Typography
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);

  // Grade Colors
  // 90–100 → Green
  static const Color gradeExcellent = Color(0xFF10B981);
  // 80–89 → Blue
  static const Color gradeGood = Color(0xFF3B82F6);
  // 70–79 → Orange
  static const Color gradeNeedsImprovement = Color(0xFFF59E0B);
  // Below 70 → Red
  static const Color gradePoor = Color(0xFFEF4444);

  // Semantic
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
}
