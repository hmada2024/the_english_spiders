// lib/core/widgets/shared/category_title.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class CategoryTitle extends StatelessWidget {
  final String title;

  const CategoryTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium)
      ),
      child: Text(
        title,
        style: theme.textTheme.titleLarge!.copyWith(color: theme.colorScheme.onPrimary), // Use theme text style and color
      ),
    );
  }
}