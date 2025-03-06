//lib/Learning/nouns/ui/noun_content.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/Learning/nouns/bloc/learn_noun_state.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/Learning/nouns/ui/empty_state_display.dart';
import 'package:the_english_spiders/core/ui/shared/error_display.dart';
import 'package:the_english_spiders/Learning/nouns/ui/responsive_grid_view.dart';
import 'package:the_english_spiders/Learning/nouns/ui/noun_card.dart';
import 'package:the_english_spiders/data/models/displayable_item.dart';

class NounContent extends StatelessWidget {
  final LearnNounState state;
  final Function(DisplayableItem) onPlayAudio;
  final VoidCallback onRetry;

  const NounContent({
    super.key,
    required this.state,
    required this.onPlayAudio,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppConstants.primaryColor,
        ),
      );
    }

    if (state.error != null) {
      return ErrorDisplay(errorMessage: state.error!, onRetry: onRetry);
    }

    if (state.nouns.isEmpty) {
      return const EmptyStateDisplay(
          message: 'No nouns found for this category.');
    }

    return ResponsiveGridView(
      itemCount: state.nouns.length,
      itemBuilder: (context, index) {
        final item = state.nouns[index];
        return ItemCard(
          key: ValueKey('${item.name}-${item.category}'),
          item: item,
          index: index,
          onPlayAudio: () => onPlayAudio(item),
        );
      },
      childAspectRatio: 1.1,
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 16.0,
    );
  }
}