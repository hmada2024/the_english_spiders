//lib/Learning_section/categories/compound_words/compound_word_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/compound_words/bloc/learn_compound_word_bloc.dart';
import 'package:the_english_spiders/Learning/compound_words/bloc/learn_compound_word_event.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_card_header.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/data/models/compound_word_model.dart';
import 'package:the_english_spiders/core/ui/shared/audio_type.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_detail_row.dart';
import 'package:the_english_spiders/Learning/shared/item_card/expandable_item_card.dart';
import 'package:the_english_spiders/core/ui/text/string_extensions.dart';

class CompoundWordCard extends StatelessWidget {
  final CompoundWord compoundWord;

  const CompoundWordCard({
    super.key,
    required this.compoundWord,
  });

  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);
    return ExpandableItemCard(
      title: ItemCardHeader<CompoundWord>(
        item: compoundWord,
        isExpanded: false,
        onTap: () {},
        displayValue: (CompoundWord c) => c.main,
        audioData: (CompoundWord c) => c.mainAudio,
      ),
      content: Padding(
        padding:  const EdgeInsets.all(AppConstants.paddingSmall),
        child: Column(
          children: [
            if (compoundWord.example != null &&
                compoundWord.example!.isNotEmpty)
              ItemDetailRow(
                richValue: compoundWord.example!.formatWithHighlight(
                   theme.colorScheme.secondary),
                audio: compoundWord.mainExampleAudio,
                onPlayAudio: (audioData) {
                  if (compoundWord.mainExampleAudio != null) {
                    context.read<LearnCompoundWordBloc>().add(
                        PlayCompoundWordAudio(
                            compoundWord, AudioType.example));
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}