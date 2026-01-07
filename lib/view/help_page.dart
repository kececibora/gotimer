import 'package:flutter/material.dart';
import 'package:gotimer/translate/translate.dart';
import 'package:gotimer/widgets/change_lang_widgets.dart'; // AppLanguage.notifier
import 'package:gotimer/ui/app_colors.dart';
import 'package:gotimer/ui/app_dimens.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.radius20),
      onTap: () => _showHelp(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(AppDimens.radius20)),
        child: const Icon(Icons.help_outline_rounded, size: 32, color: AppColors.textSecondary),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radius24))),
      builder: (sheetContext) {
        return ValueListenableBuilder<String>(
          valueListenable: AppLanguage.notifier,
          builder: (context, lang, _) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: _DragHandle()),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: Colors.white70),
                          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.gap16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HelpTitle(lang: lang),
                            const SizedBox(height: AppDimens.gap16),
                            _HelpContent(lang: lang),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _HelpTitle extends StatelessWidget {
  final String lang;
  const _HelpTitle({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.t(lang, 'helpTitle'),
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(999)),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4));
  }
}

class _HelpContent extends StatelessWidget {
  final String lang;
  const _HelpContent({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(AppStrings.t(lang, 'helpGoalTitle')),
        _Paragraph(AppStrings.t(lang, 'helpGoalText')),

        _SectionTitle(AppStrings.t(lang, 'helpHomeTitle')),
        _Bullet(AppStrings.t(lang, 'helpHomeB1')),
        _Bullet(AppStrings.t(lang, 'helpHomeB2')),
        _Bullet(AppStrings.t(lang, 'helpHomeB3')),

        _SectionTitle(AppStrings.t(lang, 'helpSystemsTitle')),
        _Bullet(AppStrings.t(lang, 'helpSystemsB1')),
        _Bullet(AppStrings.t(lang, 'helpSystemsB2')),
        _Bullet(AppStrings.t(lang, 'helpSystemsB3')),

        _SectionTitle(AppStrings.t(lang, 'helpGameTitle')),
        _Bullet(AppStrings.t(lang, 'helpGameB1')),
        _Bullet(AppStrings.t(lang, 'helpGameB2')),
        _Bullet(AppStrings.t(lang, 'helpGameB3')),

        _SectionTitle(AppStrings.t(lang, 'helpSoundTitle')),
        _Bullet(AppStrings.t(lang, 'helpSoundB1')),
        _Bullet(AppStrings.t(lang, 'helpSoundB2')),

        _SectionTitle(AppStrings.t(lang, 'helpEndTitle')),
        _Bullet(AppStrings.t(lang, 'helpEndB1')),
        _Bullet(AppStrings.t(lang, 'helpEndB2')),

        const SizedBox(height: 12),
        _Paragraph(AppStrings.t(lang, 'helpOutro')),
        const SizedBox(height: 12),

        _SectionTitle(AppStrings.t(lang, 'helpDisclaimerTitle')),
        _Paragraph(AppStrings.t(lang, 'helpDisclaimerP1')),
        const SizedBox(height: 8),
        _Paragraph(AppStrings.t(lang, 'helpDisclaimerP2')),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.white)),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
