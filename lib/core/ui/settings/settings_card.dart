// lib/core/widgets/settings/settings_card.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class SettingsCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const SettingsCard({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.defaultElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}