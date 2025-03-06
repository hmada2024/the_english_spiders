//lib/core/widgets/shared/custom_button.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';

class CustomButton extends StatelessWidget {
  final String labelText;
  final ButtonStyle style;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.labelText,
    required this.style,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = ScreenSize.isTablet(context);
    final theme = Theme.of(context);
    final defaultStyle = ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      padding: EdgeInsets.symmetric(vertical: isTablet ? 20 : 15, horizontal: isTablet ? 40: 20), //responsive
      textStyle: theme.textTheme.labelLarge!.copyWith(
        fontSize: isTablet ? 22 : 18,
      )

    );

    final effectiveStyle = defaultStyle.merge(style);


    return ElevatedButton(
      onPressed: onPressed,
      style: effectiveStyle, 
      child: Text(labelText),
    );
  }
}