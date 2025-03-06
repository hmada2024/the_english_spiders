//lib/Learning/nouns/ui/empty_state_display.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class EmptyStateDisplay extends StatelessWidget {
  final String message;

  const EmptyStateDisplay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off, // Or any other suitable icon
            size: 50,
            color: theme.colorScheme.onSurface
                .withValues(alpha: 0.6), 
          ),
          const SizedBox(height: AppConstants.marginMedium),
          Text(
            message,
            style: theme.textTheme.titleMedium!.copyWith(
                color:
                    theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
