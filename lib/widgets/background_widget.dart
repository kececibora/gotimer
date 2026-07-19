import 'package:flutter/material.dart';
import 'package:gotimer/ui/app_colors.dart';
import 'package:gotimer/ui/app_theme.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    this.imagePath1,
    this.imagePath2,
    required this.child,
  });

  final String? imagePath1;
  final String? imagePath2;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = AppThemeController.palette;
    final texturePath = imagePath1 ?? palette.backgroundImage1;

    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.46, 1],
              colors: [Color(0xFF141615), Color(0xFF211F1A), Color(0xFF38291A)],
            ),
          ),
        ),
        Opacity(
          opacity: 0.34,
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(texturePath),
                repeat: ImageRepeat.repeat,
                alignment: Alignment.topCenter,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF5A4934),
                  BlendMode.softLight,
                ),
              ),
            ),
          ),
        ),
        if (imagePath2 != null)
          Opacity(
            opacity: 0.12,
            child: Image.asset(imagePath2!, fit: BoxFit.cover),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.55),
              radius: 1.25,
              colors: [
                AppColors.brass.withValues(alpha: 0.09),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.48),
              ],
              stops: const [0, 0.62, 1],
            ),
          ),
        ),
        SafeArea(child: child),
      ],
    );
  }
}
