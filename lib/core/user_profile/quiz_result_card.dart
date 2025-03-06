import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/user_profile/quiz_type_card.dart';
import 'package:the_english_spiders/data/models/quiz_result_model.dart';

class QuizResultCard extends StatelessWidget {
  final QuizResultModel quizResult;

  const QuizResultCard({super.key, required this.quizResult});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // MODIFIED
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: AppConstants.defaultElevation,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12.0)), // MODIFIED: Use theme if possible.
      color: theme.cardTheme.color, // MODIFIED
      child: ExpansionTile(
        title: Text(quizResult.quizType, style: theme.textTheme.titleMedium),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: quizResult.subQuizzes
                  .map((subQuiz) => QuizTypeCard(subQuiz: subQuiz))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}