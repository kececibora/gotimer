import 'package:flutter/material.dart';
import 'package:gotimer/ui/app_colors.dart';
import 'package:gotimer/ui/app_text_styles.dart';

class FantasyDecorations {
  FantasyDecorations._();

  static BoxDecoration panel({
    bool accented = false,
    Color? accent,
    double radius = 18,
    double opacity = 0.94,
  }) {
    final edge = accent ?? AppColors.brass;
    return BoxDecoration(
      color: AppColors.panelDeep.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: accented ? edge.withValues(alpha: 0.58) : AppColors.hairline,
        width: accented ? 1.2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: accented ? 0.48 : 0.34),
          blurRadius: accented ? 22 : 14,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration wood({double radius = 14}) => BoxDecoration(
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF433323), Color(0xFF2C221A), Color(0xFF1E1914)],
    ),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: AppColors.brass.withValues(alpha: 0.58)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.38),
        blurRadius: 12,
        offset: const Offset(0, 5),
      ),
    ],
  );

  static BoxDecoration chip({Color? accent, double radius = 14}) {
    final color = accent ?? AppColors.brass;
    return BoxDecoration(
      color: color.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: color.withValues(alpha: 0.5)),
    );
  }
}

class FantasyPanel extends StatelessWidget {
  const FantasyPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.accented = false,
    this.accent,
    this.radius = 18,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool accented;
  final Color? accent;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: FantasyDecorations.panel(
      accented: accented,
      accent: accent,
      radius: radius,
    ),
    child: child,
  );
}

class FantasyChip extends StatelessWidget {
  const FantasyChip({
    super.key,
    required this.child,
    this.accent,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  });

  final Widget child;
  final Color? accent;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: FantasyDecorations.chip(accent: accent),
    child: child,
  );
}

class FantasyIconSurface extends StatelessWidget {
  const FantasyIconSurface({
    super.key,
    required this.icon,
    this.color,
    this.size = 22,
    this.padding = const EdgeInsets.all(10),
  });

  final IconData icon;
  final Color? color;
  final double size;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: FantasyDecorations.wood(radius: 13),
    child: Icon(icon, color: color ?? AppColors.brass, size: size),
  );
}

class FantasyPrimaryButton extends StatefulWidget {
  const FantasyPrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height = 58,
    this.padding = const EdgeInsets.symmetric(horizontal: 22),
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double height;
  final EdgeInsetsGeometry padding;

  @override
  State<FantasyPrimaryButton> createState() => _FantasyPrimaryButtonState();
}

class _FantasyPrimaryButtonState extends State<FantasyPrimaryButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value || widget.onPressed == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    const sideDepth = 6.0;
    final radius = BorderRadius.circular(14);

    return SizedBox(
      height: widget.height,
      child: Listener(
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: sideDepth,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF7E522A), Color(0xFF472D1C)],
                  ),
                  borderRadius: radius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 80),
              curve: Curves.easeOut,
              left: 0,
              right: 0,
              top: _pressed ? sideDepth : 0,
              bottom: _pressed ? 0 : sideDepth,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFE2C088),
                      Color(0xFFC79E61),
                      Color(0xFFA37340),
                    ],
                    stops: [0, 0.48, 1],
                  ),
                  borderRadius: radius,
                  border: Border.all(
                    color: const Color(0xFFF0D8AC).withValues(alpha: 0.72),
                  ),
                ),
                child: FilledButton(
                  onPressed: widget.onPressed,
                  style: FilledButton.styleFrom(
                    padding: widget.padding,
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColors.ink,
                    disabledBackgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: radius),
                    textStyle: AppTextStyles.primaryButton,
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
