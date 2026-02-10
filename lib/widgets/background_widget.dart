// ================== BACKGROUND WRAPPER ==================
import 'package:flutter/material.dart';
import 'package:gotimer/ui/app_colors.dart';
import 'package:gotimer/ui/app_dimens.dart';
import 'package:gotimer/ui/app_theme.dart';

class AppBackground extends StatelessWidget {
  final String? imagePath1;
  final String? imagePath2; // 👈 opsiyonel
  final Widget child;

  const AppBackground({
    super.key,
    this.imagePath1,
    this.imagePath2,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final palette = AppThemeController.palette;
    final topImagePath = imagePath1 ?? palette.backgroundImage1;
    final secondImagePath = imagePath2 ?? palette.backgroundImage2;

    return Stack(
      children: [
        Container(color: AppColors.bg),

        // Background 1 (her zaman)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            topImagePath,
            fit: BoxFit.cover,
            height: AppDimens.bgImageHeight,
          ),
        ),

        // Background 2 (SADECE varsa)
        if (secondImagePath != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.85,
              child: Image.asset(
                secondImagePath,
                fit: BoxFit.cover,
                height: AppDimens.bgImageHeight,
              ),
            ),
          ),

        if (palette.backgroundTintOpacity > 0)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: palette.backgroundTint.withValues(
                  alpha: palette.backgroundTintOpacity,
                ),
              ),
            ),
          ),

        // Gradient (istersen bunu da opsiyonel yapabiliriz)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: AppDimens.bgGradientHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.gradientTop, Colors.transparent],
              ),
            ),
          ),
        ),

        SafeArea(child: child),
      ],
    );
  }
}
