import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/data/models/quiz_result_model.dart';


class QuizTypeCard extends StatelessWidget {
    final SubQuizResult subQuiz;
    const QuizTypeCard({super.key, required this.subQuiz});

     @override
    Widget build(BuildContext context) {
      final theme = Theme.of(context);
        return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium)),
            color: AppConstants.greyColor,
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(subQuiz.quizSubType, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text("Score: ${subQuiz.score} / ${subQuiz.totalQuestions}", style: theme.textTheme.bodyMedium),
                        Text("Correct Answers: ${subQuiz.correctAnswers}", style: theme.textTheme.bodyMedium),
                    ],
                ),
            ),
        );
    }
}