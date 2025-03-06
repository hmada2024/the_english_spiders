import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';

class ShowAnswerButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;

  const ShowAnswerButton({
    super.key,
    this.onPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // MODIFIED
    final screenWidth = ScreenSize.getWidth(context);
    return Container(
      margin: EdgeInsets.only(
          bottom: screenWidth * 0.02, right: screenWidth * 0.02),
      child: FloatingActionButton.extended(
        onPressed: isEnabled ? onPressed : null,
        backgroundColor: theme.colorScheme.secondary, // MODIFIED
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(
              color: theme.colorScheme.onSurface.withValues(alpha:0.5)), // MODIFIED
        ),
        label: Text(
          'Show Answer',
          style: theme.textTheme.bodyLarge!.copyWith(
            // MODIFIED
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSecondary, // MODIFIED
          ),
        ),
      ),
    );
  }
}