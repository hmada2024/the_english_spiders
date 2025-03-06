//lib/core/widgets/shared/error_display.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class ErrorDisplay extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const ErrorDisplay({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(
              Icons.error_outline,
              size: 50,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppConstants.marginMedium),
             Text(
              'An error occurred:',
              style: theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.onSurface),
            ),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onSurface),
            ),
            if (onRetry != null) ...[ // Show retry button only if onRetry is provided
              const SizedBox(height: AppConstants.marginMedium),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}