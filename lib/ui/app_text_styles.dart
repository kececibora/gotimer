import 'package:flutter/material.dart';
import 'package:gotimer/ui/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle display({
    double fontSize = 18,
    Color? color,
    double letterSpacing = 0.5,
  }) => TextStyle(
    fontFamily: 'Cinzel',
    fontFamilyFallback: const ['SF Pro Rounded', 'Roboto', 'NotoSansThai'],
    fontSize: fontSize,
    fontWeight: FontWeight.w800,
    letterSpacing: letterSpacing,
    height: 1.1,
    color: color ?? AppColors.parchment,
  );

  static TextStyle get appSubtitle =>
      display(fontSize: 21, color: AppColors.brass, letterSpacing: 0.8);

  static TextStyle get screenTitle => display(fontSize: 30, letterSpacing: 1);
  static TextStyle get cardTitle => display(fontSize: 17);
  static TextStyle get infoTitle => display(fontSize: 16);

  static TextStyle get cardDesc => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: AppColors.textSecondary,
  );

  static TextStyle get infoLabel => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
  );

  static TextStyle get infoLink => TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.parchment,
    decoration: TextDecoration.underline,
  );

  static TextStyle get timerBig => display(
    fontSize: 76,
    letterSpacing: 2,
  ).copyWith(fontWeight: FontWeight.w900);

  static TextStyle get byoInfo => TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700,
    color: AppColors.parchmentSoft,
  );

  static TextStyle get moveCount => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.parchmentSoft,
  );

  static TextStyle get primaryButton =>
      display(fontSize: 16, color: AppColors.ink, letterSpacing: 0.6);
}
