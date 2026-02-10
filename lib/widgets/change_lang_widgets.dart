// ================== DİL YÖNETİMİ ==================

import 'package:flutter/material.dart';
import 'package:gotimer/translate/translate.dart';
import 'package:gotimer/ui/app_colors.dart';
import 'package:gotimer/ui/app_dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage {
  static const String _prefsKeyLanguage = 'selected_language';
  static final ValueNotifier<String> notifier = ValueNotifier<String>('en');

  static String get current => notifier.value;

  static void set(String code) {
    if (AppStrings.supportedLanguages.contains(code)) {
      notifier.value = code;
      _saveLanguage(code);
    }
  }

  static Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_prefsKeyLanguage);
      if (saved != null && AppStrings.supportedLanguages.contains(saved)) {
        notifier.value = saved;
      }
    } catch (_) {
      // Ignore persistence errors and keep defaults.
    }
  }

  static Future<void> _saveLanguage(String code) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKeyLanguage, code);
    } catch (_) {
      // Ignore persistence errors.
    }
  }
}

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  String _label(String code) {
    switch (code) {
      case 'tr':
        return 'TR 🇹🇷';
      case 'en':
        return 'EN 🇬🇧';
      case 'ja':
        return '日本語 🇯🇵';
      case 'ko':
        return '한국어 🇰🇷';
      case 'zh':
        return '中文 🇨🇳';

      case 'de':
        return 'DE 🇩🇪';
      case 'fr':
        return 'FR 🇫🇷';
      case 'es':
        return 'ES 🇪🇸';
      case 'it':
        return 'IT 🇮🇹';

      default:
        return code.toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLanguage.notifier,
      builder: (context, lang, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppDimens.gap20),
          ),
          child: PopupMenuButton<String>(
            initialValue: lang,
            offset: const Offset(0, 40),
            color: AppColors.card,
            onSelected: (code) => AppLanguage.set(code),
            itemBuilder: (context) {
              return AppStrings.supportedLanguages.map((code) {
                return PopupMenuItem<String>(
                  value: code,
                  child: Text(
                    _label(code),
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _label(lang),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppDimens.gap4),
                  const Icon(
                    Icons.language_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
