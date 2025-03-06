//lib/quizzes/shared/question_element.dart
import 'package:flutter/material.dart';
import 'dart:typed_data';

enum QuestionType { text, image, audio }

class QuestionElement<T> extends StatelessWidget {
  final T? data;
  final double? imageHeight;
  final double? textSize;
  final double? containerPaddingHorizontal;
  final double? containerPaddingVertical;
  final double? containerBorderRadius;
  final Color? textColor;
  final Color? backgroundColor;
  final double? shadowSpreadRadius;
  final double? shadowBlurRadius;
  final double? shadowOffsetDy;
  final bool? canPlayAudio;
  final VoidCallback? onPlayAudio;
  final QuestionType questionType;

  const QuestionElement({
    super.key,
    this.data,
    this.imageHeight,
    this.textSize,
    this.containerPaddingHorizontal = 8.0,
    this.containerPaddingVertical = 8.0,
    this.containerBorderRadius = 12.0,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.transparent, // Change default to transparent
    this.shadowSpreadRadius = 1.0,
    this.shadowBlurRadius = 3.0,
    this.shadowOffsetDy = 2.0,
    this.canPlayAudio = false,
    this.onPlayAudio,
    required this.questionType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // MODIFIED
    final screenWidth = MediaQuery.of(context).size.width;

    Widget questionContent;

    switch (questionType) {
      case QuestionType.text:
        questionContent = Text(
          data as String,
          style: theme.textTheme.bodyLarge!.copyWith(
            // MODIFIED: Using TextTheme
            fontWeight: FontWeight.w500,
            color: textColor ?? theme.colorScheme.onSurface, // MODIFIED
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        );
        break;

      case QuestionType.image:
        questionContent = ClipRRect(
          borderRadius: BorderRadius.circular(containerBorderRadius ?? 12.0),
          child: data != null
              ? Image.memory(
                  data as Uint8List,
                  height: imageHeight,
                  fit: BoxFit.cover,
                )
              : const SizedBox(),
        );
        break;

      case QuestionType.audio:
        questionContent = SizedBox(
          height: 150,
          child: Center(
            child: Icon(
              Icons.volume_up,
              size: screenWidth * 0.15,
              color: theme.colorScheme.primary, // MODIFIED
            ),
          ),
        );
        break;
    }

    return GestureDetector(
      onTap: canPlayAudio == true ? onPlayAudio : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: containerPaddingHorizontal ?? 8.0,
          vertical: containerPaddingVertical ?? 8.0,
        ),
        decoration: BoxDecoration(
          color:
              backgroundColor, // Use backgroundColor here (defaults to transparent)
          borderRadius: BorderRadius.circular(containerBorderRadius ?? 12.0),
          boxShadow: [
            if (questionType == QuestionType.image)
              BoxShadow(
                color: theme.shadowColor, // MODIFIED
                spreadRadius: shadowSpreadRadius ?? 1.0,
                blurRadius: shadowBlurRadius ?? 3.0,
                offset: Offset(0, shadowOffsetDy ?? 2.0),
              ),
          ],
        ),
        child: questionContent,
      ),
    );
  }
}