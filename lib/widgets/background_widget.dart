// ================== BACKGROUND WRAPPER ==================
import 'package:flutter/material.dart';
import 'package:gotimer/ui/app_colors.dart';
import 'package:gotimer/ui/app_dimens.dart';

class AppBackground extends StatelessWidget {
  final String imagePath1;
  final String? imagePath2; // 👈 opsiyonel
  final Widget child;

  const AppBackground({super.key, required this.imagePath1, this.imagePath2, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppColors.bg),

        // Background 1 (her zaman)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(imagePath1, fit: BoxFit.cover, height: AppDimens.bgImageHeight),
        ),

        // Background 2 (SADECE varsa)
        if (imagePath2 != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.85,
              child: Image.asset(imagePath2!, fit: BoxFit.cover, height: AppDimens.bgImageHeight),
            ),
          ),

        // Gradient (istersen bunu da opsiyonel yapabiliriz)
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: AppDimens.bgGradientHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black54, Colors.transparent]),
            ),
          ),
        ),

        SafeArea(child: child),
      ],
    );
  }
}
