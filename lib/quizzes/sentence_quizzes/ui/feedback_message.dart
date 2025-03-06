import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/quizzes/sentence_quizzes/bloc/arrange_sentence_bloc.dart';

class FeedbackMessage extends StatelessWidget {
  const FeedbackMessage({super.key});

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context); // MODIFIED
    return BlocBuilder<ArrangeSentenceBloc, ArrangeSentenceState>(
      builder: (context, state) {
        // No logic changes, only showing when feedback is needed.
        return AnimatedOpacity(
          opacity: state.isCorrect || state.isWrong ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: _buildMessage(state, theme), // MODIFIED
        );
      },
    );
  }

  Widget _buildMessage(ArrangeSentenceState state, ThemeData theme) { // MODIFIED: Added theme
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Text(
        state.isCorrect ? 'Correct!' : 'Wrong!',
        style: theme.textTheme.displaySmall!.copyWith(  // MODIFIED: Using displaySmall
          fontWeight: FontWeight.bold,
          color: state.isCorrect ? theme.colorScheme.secondary : theme.colorScheme.error, // MODIFIED
        ),
      ),
    );
  }
}