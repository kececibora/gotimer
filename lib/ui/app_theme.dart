import 'package:flutter/material.dart';

enum GoThemeId { darkFantasy }

class GoThemePalette {
  const GoThemePalette();

  Color get bg => const Color(0xFF241A0F);
  Color get card => const Color(0xFF2B2821);
  Color get panel => const Color(0xFF332417);
  Color get panelDeep => const Color(0xFF2B2821);
  Color get parchment => const Color(0xFFF0E3C7);
  Color get parchmentSoft => const Color(0xFFE8DBC2);
  Color get textSecondary => const Color(0xFF9E8F75);
  Color get ink => const Color(0xFF1A1714);
  Color get brass => const Color(0xFFC79E61);
  Color get brassDeep => const Color(0xFFA37340);
  Color get slate => const Color(0xFF5C8799);
  Color get moss => const Color(0xFF789E5C);
  Color get blackStone => const Color(0xFF11100F);
  Color get blackStoneSoft => const Color(0xFF3B3731);
  Color get blackStoneGlow => const Color(0xFFAA9C86);
  Color get whiteStone => const Color(0xFFEDE4D2);
  Color get whiteStoneSoft => const Color(0xFFCDBF9F);
  Color get whiteStoneGlow => const Color(0xFFFFF2D8);
  Color get danger => const Color(0xFFB94338);
  Color get menuTop => const Color(0xFF141615);
  Color get menuMid => const Color(0xFF211F1A);
  Color get menuBottom => const Color(0xFF38291A);
  Color get gameBackground => const Color(0xFF241A0F);
  Color get hairline => const Color(0x14FFFFFF);

  // Compatibility aliases used by the timer implementation.
  Color get active => brass;
  Color get blackBase => const Color(0xFF231712);
  Color get whiteBase => const Color(0xFF18212A);
  Color get controlBar => const Color(0xFF211A14);
  Color get controlButton => const Color(0xFF362A20);
  Color get gradientTop => const Color(0xD9141615);
  Color get accent => brass;
  Color get backgroundTint => const Color(0xFF241A0F);
  double get backgroundTintOpacity => 0.12;
  String get backgroundImage1 => 'assets/textures/dark_tabletop.png';
  String? get backgroundImage2 => null;
}

class AppThemeController {
  AppThemeController._();

  static final ValueNotifier<GoThemeId> notifier = ValueNotifier<GoThemeId>(
    GoThemeId.darkFantasy,
  );

  static const GoThemePalette palette = GoThemePalette();
  static GoThemeId get current => notifier.value;

  static void setTheme(GoThemeId themeId) {
    notifier.value = GoThemeId.darkFantasy;
  }

  static Future<void> loadTheme() async {
    notifier.value = GoThemeId.darkFantasy;
  }

  static ThemeData buildMaterialTheme() {
    final p = palette;
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: p.brass,
          brightness: Brightness.dark,
          surface: p.panelDeep,
        ).copyWith(
          primary: p.brass,
          onPrimary: p.ink,
          secondary: p.brassDeep,
          onSecondary: p.parchment,
          surface: p.panelDeep,
          onSurface: p.parchment,
          error: p.danger,
          onError: p.parchment,
          outline: p.brass.withValues(alpha: 0.48),
          outlineVariant: p.hairline,
          shadow: Colors.black,
        );

    final baseText =
        Typography.material2021(
          platform: TargetPlatform.android,
          colorScheme: colorScheme,
        ).white.apply(
          fontFamily: 'SF Pro Rounded',
          fontFamilyFallback: const ['Roboto', 'NotoSansThai'],
          bodyColor: p.parchmentSoft,
          displayColor: p.parchment,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: p.gameBackground,
      canvasColor: p.panelDeep,
      splashColor: p.brass.withValues(alpha: 0.12),
      highlightColor: p.brass.withValues(alpha: 0.06),
      dividerColor: p.hairline,
      textTheme: baseText.copyWith(
        bodyLarge: baseText.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
        bodyMedium: baseText.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          height: 1.35,
        ),
        bodySmall: baseText.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          height: 1.35,
          color: p.textSecondary,
        ),
        labelLarge: baseText.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: p.menuTop,
        foregroundColor: p.parchment,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'Cinzel',
          fontFamilyFallback: const ['SF Pro Rounded', 'Roboto', 'NotoSansThai'],
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          height: 1.1,
          color: p.parchment,
        ),
        iconTheme: IconThemeData(color: p.brass),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.panelDeep,
        modalBackgroundColor: p.panelDeep,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: Colors.black.withValues(alpha: 0.72),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.panelDeep,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'Cinzel',
          fontFamilyFallback: const ['SF Pro Rounded', 'Roboto', 'NotoSansThai'],
          fontWeight: FontWeight.w800,
          fontSize: 18,
          color: p.parchment,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: p.brass.withValues(alpha: 0.42)),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: p.panelDeep,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: p.brass.withValues(alpha: 0.36)),
        ),
        textStyle: TextStyle(
          color: p.parchmentSoft,
          fontWeight: FontWeight.w600,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: p.brass,
          foregroundColor: p.ink,
          disabledBackgroundColor: p.brass.withValues(alpha: 0.28),
          disabledForegroundColor: p.ink.withValues(alpha: 0.5),
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: 'Cinzel',
            fontFamilyFallback: ['SF Pro Rounded', 'Roboto', 'NotoSansThai'],
            fontWeight: FontWeight.w800,
            letterSpacing: 0.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.parchment,
          backgroundColor: p.controlButton,
          side: BorderSide(color: p.brass.withValues(alpha: 0.72)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.brass,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? p.ink : p.textSecondary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? p.brass : p.controlButton,
        ),
        trackOutlineColor: WidgetStatePropertyAll(
          p.brass.withValues(alpha: 0.46),
        ),
      ),
      dividerTheme: DividerThemeData(color: p.hairline, thickness: 1),
      iconTheme: IconThemeData(color: p.parchmentSoft),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _DarkFadePageTransitionsBuilder(),
          TargetPlatform.iOS: _DarkFadePageTransitionsBuilder(),
          TargetPlatform.macOS: _DarkFadePageTransitionsBuilder(),
          TargetPlatform.windows: _DarkFadePageTransitionsBuilder(),
          TargetPlatform.linux: _DarkFadePageTransitionsBuilder(),
        },
      ),
    );
  }
}

class _DarkFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const _DarkFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ColoredBox(
      color: const Color(0xFF141615),
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        child: child,
      ),
    );
  }
}
