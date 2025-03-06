import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/quizzes/sentence_quizzes/bloc/arrange_sentence_bloc.dart';

class SentenceSegmentGrid extends StatelessWidget {
  const SentenceSegmentGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArrangeSentenceBloc, ArrangeSentenceState>(
      builder: (context, state) {
        return _buildGrid(context, state);
      },
    );
  }

  Widget _buildGrid(BuildContext context, ArrangeSentenceState state) {
     Theme.of(context); // MODIFIED
    final screenWidth = MediaQuery.of(context).size.width;
    return Wrap(
      spacing: screenWidth * 0.02,
      runSpacing: screenWidth * 0.02,
      children: state.shuffledSegments
          .map((segment) => _buildSegment(context, segment, state))
          .toList(),
    );
  }

  Widget _buildSegment(
      BuildContext context, String segment, ArrangeSentenceState state) {
     final theme = Theme.of(context); // MODIFIED
    final screenWidth = MediaQuery.of(context).size.width;
    final isUsed = state.userOrder.contains(segment);
    return InkWell(
      onTap: isUsed || state.isInteractionDisabled
          ? null
          : () => context
              .read<ArrangeSentenceBloc>()
              .add(ArrangeSentenceSelectSegment(segment)),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.02, horizontal: screenWidth * 0.04),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha:0.5)), // MODIFIED
          borderRadius: BorderRadius.circular(12.0),
          color: isUsed
              ? theme.cardTheme.color!.withValues(alpha:0.5) // MODIFIED: Use cardTheme color with opacity
              : theme.cardTheme.color, // MODIFIED: Use cardTheme color
        ),
        child: _buildSegmentText(segment, isUsed, screenWidth, theme), // MODIFIED
      ),
    );
  }

 Widget _buildSegmentText(String segment, bool isUsed, double screenWidth, ThemeData theme) {
    return Text(
      segment,
      style: theme.textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.bold,
        color: isUsed ? theme.colorScheme.onSurface.withValues(alpha:0.5) : theme.colorScheme.primary, 
      ),
    );
  }
}