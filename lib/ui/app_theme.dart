import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GoThemeId { classic, wood }

class GoThemePalette {
  final Color bg;
  final Color card;
  final Color textSecondary;
  final Color active;
  final Color blackBase;
  final Color whiteBase;
  final Color controlBar;
  final Color controlButton;
  final Color gradientTop;
  final Color accent;
  final Color backgroundTint;
  final double backgroundTintOpacity;
  final String backgroundImage1;
  final String? backgroundImage2;

  const GoThemePalette({
    required this.bg,
    required this.card,
    required this.textSecondary,
    required this.active,
    required this.blackBase,
    required this.whiteBase,
    required this.controlBar,
    required this.controlButton,
    required this.gradientTop,
    required this.accent,
    required this.backgroundTint,
    required this.backgroundTintOpacity,
    required this.backgroundImage1,
    required this.backgroundImage2,
  });
}

class AppThemeController {
  AppThemeController._();
  static const String _prefsKeyTheme = 'selected_theme';

  static final ValueNotifier<GoThemeId> notifier = ValueNotifier<GoThemeId>(
    GoThemeId.classic,
  );

  static const Map<GoThemeId, GoThemePalette> _palettes = {
    GoThemeId.classic: GoThemePalette(
      bg: Color(0xFF181920),
      card: Color(0xFF22252F),
      textSecondary: Color(0xFFB2B5C3),
      active: Color(0xFFFFA851),
      blackBase: Color(0xFF111111),
      whiteBase: Color(0xFFF4F5FB),
      controlBar: Color(0xFF202020),
      controlButton: Color(0xFF303030),
      gradientTop: Colors.black54,
      accent: Color(0xFFFFA851),
      backgroundTint: Colors.transparent,
      backgroundTintOpacity: 0,
      backgroundImage1: 'assets/background/background_2.png',
      backgroundImage2: 'assets/background/background_1.png',
    ),
    GoThemeId.wood: GoThemePalette(
      bg: Color(0xFF1B130E),
      card: Color(0xFF3B2718),
      textSecondary: Color(0xFFE0C39D),
      active: Color(0xFFDDA154),
      blackBase: Color(0xFF2A1B12),
      whiteBase: Color(0xFFF2E2C9),
      controlBar: Color(0xFF2B1E15),
      controlButton: Color(0xFF5B3D29),
      gradientTop: Color(0xB3201108),
      accent: Color(0xFFDDA154),
      backgroundTint: Color(0xFF7A4A21),
      backgroundTintOpacity: 0.32,
      backgroundImage1: 'assets/background/background_2.png',
      backgroundImage2: 'assets/background/background_1.png',
    ),
  };

  static GoThemeId get current => notifier.value;

  static GoThemePalette get palette => _palettes[current]!;

  static void setTheme(GoThemeId themeId) {
    if (themeId != notifier.value) {
      notifier.value = themeId;
      _saveTheme(themeId);
    }
  }

  static Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKeyTheme);
      final theme = _parseTheme(raw);
      if (theme != null) notifier.value = theme;
    } catch (_) {
      // Ignore persistence errors and keep defaults.
    }
  }

  static Future<void> _saveTheme(GoThemeId themeId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKeyTheme, themeId.name);
    } catch (_) {
      // Ignore persistence errors.
    }
  }

  static GoThemeId? _parseTheme(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final theme in GoThemeId.values) {
      if (theme.name == raw) return theme;
    }
    return null;
  }

  static ThemeData buildMaterialTheme() {
    final p = palette;
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: p.bg,
      colorScheme: ColorScheme.dark(
        primary: p.accent,
        secondary: p.active,
        surface: p.card,
        onSurface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: p.bg,
        foregroundColor: Colors.white,
      ),
    );
  }
}
