import 'package:flutter/material.dart';
import 'package:gotimer/ui/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Home
  static const TextStyle appSubtitle = TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textSecondary);

  static const TextStyle screenTitle = TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 1, color: Colors.white);

  // Cards
  static const TextStyle cardTitle = TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white);

  static const TextStyle cardDesc = TextStyle(fontSize: 13, color: AppColors.textSecondary);

  // Info bottom sheet
  static const TextStyle infoTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white);

  static const TextStyle infoLabel = TextStyle(fontSize: 13, color: AppColors.textSecondary);

  static const TextStyle infoLink = TextStyle(fontSize: 14, color: Colors.white, decoration: TextDecoration.underline);

  // Timer
  static const TextStyle timerBig = TextStyle(fontSize: 80, fontWeight: FontWeight.w800, letterSpacing: 2);

  static const TextStyle byoInfo = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);

  static const TextStyle moveCount = TextStyle(fontSize: 14);

  // Buttons
  static const TextStyle primaryButton = TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'SF Pro Text');
}
