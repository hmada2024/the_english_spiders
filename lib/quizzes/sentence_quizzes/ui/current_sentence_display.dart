import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/quizzes/sentence_quizzes/bloc/arrange_sentence_bloc.dart';

class CurrentSentenceDisplay extends StatelessWidget {
  const CurrentSentenceDisplay({super.key});

  @override
  Widget build(BuildContext context) {
     Theme.of(context); // MODIFIED
    return BlocBuilder<ArrangeSentenceBloc, ArrangeSentenceState>(
      builder: (context, state) {
        // Only show if the question is ready, correct, or wrong.
        if (state.status != ArrangeSentenceStatus.questionReady &&
            state.status != ArrangeSentenceStatus.correct &&
            state.status != ArrangeSentenceStatus.wrong) {
          return const SizedBox.shrink();
        }

        return _buildDisplay(context, state);
      },
    );
  }

  Widget _buildDisplay(BuildContext context, ArrangeSentenceState state) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Wrap(
        spacing: screenWidth * 0.01,
        runSpacing: screenWidth * 0.01,
        children: state.userOrder
            .map((segment) => _buildSegment(context, segment, state))
            .toList(),
      ),
    );
  }

  Widget _buildSegment(
      BuildContext context, String segment, ArrangeSentenceState state) {
    final theme = Theme.of(context); // MODIFIED
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: state.isInteractionDisabled
          ? null
          : () => context.read<ArrangeSentenceBloc>().add(
              ArrangeSentenceSelectSegment(segment, isRemove: true)),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.01, horizontal: screenWidth * 0.02),
        decoration: BoxDecoration(
          color: theme.cardTheme.color, // MODIFIED
          border: Border.all(
              color: theme.colorScheme.onSurface.withValues(alpha:0.5)), // MODIFIED
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: _buildSegmentText(segment, screenWidth, theme), // MODIFIED
      ),
    );
  }

   Widget _buildSegmentText(String segment, double screenWidth, ThemeData theme) { // MODIFIED: Added theme
    return Text(
      segment,
      style: theme.textTheme.bodyLarge!.copyWith( // MODIFIED: Using bodyLarge and copyWith for customization.
        color: theme.colorScheme.onSurface, // MODIFIED
      ),
    );
  }
}