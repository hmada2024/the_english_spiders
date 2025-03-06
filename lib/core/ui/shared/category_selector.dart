//lib/core/widgets/shared/category_selector.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/ui/text/string_formatter.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = category == selectedCategory;

        return ListTile(
          title: Text(
            category == 'all'
                ? 'All Categories'
                : StringFormatter.formatFieldName(category),
            style: theme.textTheme.bodyLarge!.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          tileColor: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : null,
          trailing: isSelected
              ? Icon(Icons.check, color: theme.colorScheme.primary)
              : null,
          onTap: () {
            onCategorySelected(category);
          },
        );
      },
    );
  }
}
