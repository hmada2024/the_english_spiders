//lib/quizzes_section/shared_quizzes/widgets/answers_options_element.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/data/models/nouns_model.dart';
import 'package:the_english_spiders/quizzes/shared/quiz_widget_helpers.dart';

class AnswersOptionsElement<T> extends StatelessWidget {
  final T data;
  final VoidCallback? onTap;
  final bool isCorrect;
  final bool isWrong;
  final double borderRadius;
  final double shadowBlurRadius;
  final double shadowOffset;
  final Color? defaultColor;
  final Color? correctColor;
  final Color? wrongColor;
  final bool isDisabled;
  final double fontSize;
  final Color? textColor;
  final double elevation;
  final BoxBorder? border;
  final ButtonStyle? buttonStyle;
  final double? imageHeight;
  final bool showImage;
  final bool isSelected;

  const AnswersOptionsElement({
    super.key,
    required this.data,
    this.onTap,
    this.isCorrect = false,
    this.isWrong = false,
    required this.borderRadius,
    this.shadowBlurRadius = 0.0,
    this.shadowOffset = 0.0,
    this.defaultColor,
    this.correctColor,
    this.wrongColor,
    this.isDisabled = false,
    this.fontSize = 16.0,
    this.textColor,
    this.elevation = 0.0,
    this.border,
    this.buttonStyle,
    this.imageHeight,
    this.showImage = true,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // MODIFIED
    final boxDecoration = getBoxDecorationForAnswer(
      isSelected && isCorrect,
      isSelected && isWrong,
      borderRadius: borderRadius,
      shadowBlurRadius: shadowBlurRadius,
      shadowOffset: shadowOffset,
      defaultColor: defaultColor ?? theme.colorScheme.surface, // MODIFIED
      correctColor: correctColor ?? theme.colorScheme.secondary,   // MODIFIED
      wrongColor: wrongColor ?? theme.colorScheme.error,         // MODIFIED
      border: border,
    );

    if (data is Noun) {
      final noun = data as Noun;
      if (showImage && noun.image != null) {
        // Display image
        return GestureDetector(
          onTap: isDisabled
              ? null
              : () {
                  if (onTap != null) {
                    onTap!();
                  }
                },
          child: Opacity(
            opacity: isDisabled ? 0.5 : 1.0,
            child: Container(
              decoration: boxDecoration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: SizedBox(
                  height: imageHeight,
                  child: Image.memory(
                    noun.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/placeholder_image.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      } else {
        // Display word as button
        return SizedBox(
          height: 50.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0),
            child: ElevatedButton(
              onPressed: isDisabled
                  ? null
                  : () {
                      if (onTap != null) {
                        onTap!();
                      }
                    },
              style: buttonStyle ??
                  getButtonStyleForAnswer(
                    isSelected && isCorrect,
                    isSelected && isWrong,
                    textColor: textColor ?? theme.colorScheme.onSurface, // MODIFIED
                    defaultColor:
                        defaultColor ?? theme.colorScheme.surface,        // MODIFIED
                    correctColor: correctColor ?? theme.colorScheme.secondary,    // MODIFIED
                    wrongColor: wrongColor ?? theme.colorScheme.error,           // MODIFIED
                  ).copyWith(
                    shape:
                        WidgetStateProperty.resolveWith<RoundedRectangleBorder>(
                            (states) => RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                )),
                    elevation: WidgetStateProperty.resolveWith<double>(
                        (states) => elevation),
                  ),
              child: Center(
                child: Text(
                  noun.name,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    // MODIFIED: Using TextTheme
                    fontWeight: FontWeight.bold,
                    color: textColor ?? theme.colorScheme.onSurface, // MODIFIED
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}