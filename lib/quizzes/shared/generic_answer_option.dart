//lib/quizzes/shared/generic_answer_option.dart
import 'package:flutter/material.dart';

class GenericAnswerOption extends StatelessWidget {
  final dynamic data;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;
  final bool isEnabled;
  final double width;
  final double height;
  final double borderRadius;
  final double fontSize;

  const GenericAnswerOption({
    super.key,
    required this.data,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
    required this.isEnabled,
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // MODIFIED
    Color backgroundColor;
    if (isSelected) {
      backgroundColor =
          theme.colorScheme.onSurface.withValues(alpha: 0.5); // MODIFIED
    } else if (isCorrect) {
      backgroundColor = theme.colorScheme.secondary; // MODIFIED
    } else if (isWrong) {
      backgroundColor = theme.colorScheme.error; // MODIFIED
    } else {
      backgroundColor = theme.colorScheme.surface; // MODIFIED
    }

    return IgnorePointer(
      ignoring: !isEnabled,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
                color: theme.colorScheme.onSurface, width: 1), //MODIFIED
          ),
          alignment: Alignment.center,
          child: Text(
            data.toString(),
            style: theme.textTheme.bodyLarge!.copyWith(
              // MODIFIED: Using TextTheme
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface, // MODIFIED
            ),
          ),
        ),
      ),
    );
  }
}
