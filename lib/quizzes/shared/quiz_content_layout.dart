// lib/quizzes/shared/quiz_content_layout.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/quizzes/shared/correct_wrong_message.dart';
import 'package:the_english_spiders/quizzes/shared/skip_question_button.dart'; // Import

enum QuizOptionsType { words, images }

class QuizContentLayout<T> extends StatelessWidget {
  final String title;
  final Widget questionWidget;
  final List<Widget> answerOptions;
  final int score;
  final int answeredQuestions;
  final int totalQuestions;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onResetQuiz;
  final QuizOptionsType optionsType;
  final Widget? leading;
  final List<Widget>? actions;
  final double? optionsAspectRatio;
  final int? optionsCrossAxisCount;
  final double questionWidgetHeight;
  final double optionsSpacing;
  final double correctMessageFontSize;
  final double baseQuizPadding;
  final double bottomPadding;
  final bool showSkipButton;
  final VoidCallback? onSkip;

  const QuizContentLayout({
    super.key,
    required this.title,
    required this.questionWidget,
    required this.answerOptions,
    required this.score,
    required this.answeredQuestions,
    required this.totalQuestions,
    required this.isCorrect,
    required this.isWrong,
    required this.onResetQuiz,
    required this.optionsType,
    this.leading,
    this.actions,
    this.optionsAspectRatio,
    this.optionsCrossAxisCount,
    required this.questionWidgetHeight,
    required this.optionsSpacing,
    required this.correctMessageFontSize,
    required this.baseQuizPadding,
    required this.bottomPadding,
    this.showSkipButton = false, //  <--  القيمة الافتراضية
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Add this line
    return Padding(
      padding: EdgeInsets.all(baseQuizPadding),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildScoreItem(
                  context,
                  'Questions',
                  '$answeredQuestions/$totalQuestions',
                  theme.colorScheme.onSurface.withValues(alpha:0.5), // MODIFIED
                ),
                _buildScoreItem(
                  context,
                  'Correct',
                  '$score',
                  theme.colorScheme.secondary, // MODIFIED
                ),
              ],
            ),
          ),

          SizedBox(height: questionWidgetHeight, child: questionWidget),
          SizedBox(height: optionsSpacing),
          Flexible(
            fit: FlexFit.loose,
            child: GridView.count(
              crossAxisCount: optionsCrossAxisCount ?? 2,
              shrinkWrap: true,
              crossAxisSpacing: optionsSpacing,
              mainAxisSpacing: optionsSpacing,
              childAspectRatio: optionsAspectRatio ??
                  (optionsType == QuizOptionsType.images ? 1.3 : 2.5),
              children: answerOptions,
            ),
          ),
          SizedBox(height: bottomPadding),
          if (isCorrect || isWrong)
            CorrectWrongMessage(
              isCorrect: isCorrect,
              correctTextSize: correctMessageFontSize,
            ),
          if (showSkipButton) //  <--  عرض الزر إذا كانت الخاصية true
            Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: SkipQuestionButton(
                onPressed: onSkip,
                isEnabled: true,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(
      BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyLarge!.copyWith(
      // MODIFIED
      fontWeight: FontWeight.bold,
      color: color,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.15), // MODIFIED
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5), // MODIFIED
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: textStyle.copyWith(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface
                      .withValues(alpha:0.5))), // MODIFIED
          const SizedBox(height: 2),
          Text(value, style: textStyle),
        ],
      ),
    );
  }
}