import 'package:flutter/material.dart';
import 'package:gotimer/ui/app_theme.dart';

class AppColors {
  AppColors._();

  // Base
  static Color get bg => AppThemeController.palette.bg;
  static Color get card => AppThemeController.palette.card;
  static Color get textSecondary => AppThemeController.palette.textSecondary;

  // Timer areas
  static Color get active => AppThemeController.palette.active;
  static Color get blackBase => AppThemeController.palette.blackBase;
  static Color get whiteBase => AppThemeController.palette.whiteBase;

  // Control bar
  static Color get controlBar => AppThemeController.palette.controlBar;
  static Color get controlButton => AppThemeController.palette.controlButton;
  static Color get accent => AppThemeController.palette.accent;

  // Common
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Gradients
  static Color get gradientTop => AppThemeController.palette.gradientTop;
}
