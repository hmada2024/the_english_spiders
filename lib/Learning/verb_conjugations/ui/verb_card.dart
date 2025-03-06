// lib/Learning_section/categories/verb_conjugations/verb_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/bloc/verb_conjugations_bloc.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/bloc/verb_conjugations_event.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/data/models/verb_conjugations_models.dart';
import 'package:the_english_spiders/Learning/shared/item_card/expandable_item_card.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_card_header.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_details.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_detail_row.dart';
import 'package:the_english_spiders/core/ui/shared/audio_type.dart';

class VerbCard extends StatelessWidget {
  final Verb verb;

  const VerbCard({super.key, required this.verb});

  Color _getCardColor(String verbType) {
    return verbType == "regular"
        ? AppConstants.greyColor
        : Colors.orange.shade100;
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = _getCardColor(verb.verbType);
    return ExpandableItemCard(
      backgroundColor: cardColor,
      title: ItemCardHeader<Verb>(
        item: verb,
        isExpanded: false,
        onTap: () {},
        displayValue: (Verb v) => v.baseForm,
        audioData: (Verb v) => v.baseAudio,
      ),
      content: _buildConjugationsContent(context),
    );
  }

    Widget _buildConjugationsContent(BuildContext context) {
    final conjugations = verb.conjugations;

    if (conjugations == null || conjugations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No conjugations available.'),
      );
    }

    final conjugation = conjugations.first;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ItemDetails(
        rows: [
          if (verb.verbType == 'regular')
            ItemDetailRow(
              title: 'Past Simple & Past Participle',
              value: conjugation.pastForm ?? 'N/A',
              audio: conjugation.pastAudio,
              rowColor: AppConstants.greyColor,
              onPlayAudio: (_) {
                context.read<LearnVerbConjugationsBloc>().add(
                    PlayVerbAudio(verb: verb, audioType: AudioType.past));
              },
            ),
          if (verb.verbType != 'regular') ...[
            ItemDetailRow(
              title: 'Past Simple',
              value: conjugation.pastForm ?? 'N/A',
              audio: conjugation.pastAudio,
              rowColor: Colors.green.shade100,
              onPlayAudio: (_) {
                context.read<LearnVerbConjugationsBloc>().add(
                    PlayVerbAudio(verb: verb, audioType: AudioType.past));
              },
            ),
            ItemDetailRow(
              title: 'Past Participle',
              value: conjugation.pPForm ?? 'N/A',
              audio: conjugation.ppAudio,
              rowColor: Colors.orange.shade100,
              onPlayAudio: (_) {
                context.read<LearnVerbConjugationsBloc>().add(
                    PlayVerbAudio(verb: verb, audioType: AudioType.pp));
              },
            ),
          ],
        ],
      ),
    );
  }

}
