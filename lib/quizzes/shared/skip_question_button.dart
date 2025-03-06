import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';

class SkipQuestionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;
  final Alignment alignment;

  const SkipQuestionButton({
    super.key,
    this.onPressed,
    this.isEnabled = true,
    this.alignment = Alignment.bottomLeft,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // MODIFIED
    ScreenSize.getWidth(context);

    return Align(
      alignment: alignment,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary, // MODIFIED
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
                color:
                    theme.colorScheme.onSurface.withValues(alpha:0.5)), // MODIFIED
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Skip",
              style: theme.textTheme.bodyLarge!.copyWith(
                // MODIFIED
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary, // MODIFIED
              ),
            ),
            Text(
              "and",
              style: theme.textTheme.bodySmall!.copyWith(
                // MODIFIED - Using bodySmall for the smaller text
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary, // MODIFIED
              ),
            ),
            Text(
              "Next",
              style: theme.textTheme.bodyLarge!.copyWith(
                // MODIFIED
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary, // MODIFIED
              ),
            ),
          ],
        ),
      ),
    );
  }
}