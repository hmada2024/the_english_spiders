// lib/Learning_section/categories/similar_words/similar_word_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/learn_similar_words/bloc/learn_similar_words_bloc.dart';
import 'package:the_english_spiders/Learning/learn_similar_words/bloc/learn_similar_words_event.dart';
import 'package:the_english_spiders/Learning/shared/item_card/expandable_item_card.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_card_header.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_detail_row.dart';
import 'package:the_english_spiders/data/models/similar_words_models.dart';

class SimilarWordCard extends StatelessWidget {
  final SeedWithBranches seedWithBranches;

  const SimilarWordCard({super.key, required this.seedWithBranches});

  @override
  Widget build(BuildContext context) {
    return ExpandableItemCard(
      title: ItemCardHeader<SeedWord>(
        item: seedWithBranches.seed,
        isExpanded: false, // You might want to manage expansion state
        onTap: () {},
        displayValue: (SeedWord s) => s.seedWord,
        audioData: (SeedWord s) => s.audio,
      ),
      content: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: seedWithBranches.branches.map((branch) {
        return ItemDetailRow(
          title: branch.similarWord, // Or any other display logic
          value: branch.examples,
          audio: branch.audio,
            onPlayAudio: (audioData) {
                if (branch.audio != null) {
                context.read<LearnSimilarWordsBloc>().add(
                    PlayBranchWordAudio(branch));
                }
          },
        );
      }).toList(),
    );
  }
}