import 'package:flutter/material.dart';
import 'package:gotimer/translate/translate.dart';
import 'package:gotimer/ui/app_colors.dart';
import 'package:gotimer/ui/app_dimens.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchExternal(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class InfoButton extends StatelessWidget {
  final String languageCode;
  const InfoButton({super.key, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppDimens.radius20),
      onTap: () => _showInfo(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(AppDimens.radius20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [Icon(Icons.info_outline_rounded, size: 32, color: AppColors.textSecondary)],
        ),
      ),
    );
  }

  void _showInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radius24))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(999)),
                ),
              ),
              const SizedBox(height: AppDimens.gap16),
              Text(
                AppStrings.t(languageCode, 'infoTitle'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: AppDimens.gap16),
              _buildLinkRow(label: AppStrings.t(languageCode, 'infoSoftware'), name: 'rbkececi', url: 'https://www.linkedin.com/in/borakececi/'),
              const SizedBox(height: AppDimens.gap10),
              _buildLinkRow(label: AppStrings.t(languageCode, 'infoDesign'), name: 'mkrst', url: 'https://www.linkedin.com/in/m-kursat-elitok/'),
              const SizedBox(height: AppDimens.gap16),
              const Text(' ', style: TextStyle(fontSize: 0)),
              Text(AppStrings.t(languageCode, 'infoThanks'), style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: AppDimens.gap8),
              _buildLinkRow(label: '', name: 'Eskişehir Go Oyuncuları Derneği', url: 'https://www.instagram.com/eskisehirgooyunculari/'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLinkRow({required String label, required String name, required String url}) {
    return InkWell(
      onTap: () => _launchExternal(url),
      child: Row(
        children: [
          if (label.isNotEmpty) Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          if (label.isNotEmpty) const SizedBox(width: AppDimens.gap4),
          Flexible(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, color: Colors.white, decoration: TextDecoration.underline),
            ),
          ),
          const SizedBox(width: AppDimens.gap4),
          const Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
