//lib/Learning_section/categories/adjectives/adjective_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/adjectives/bloc/learn_adjective_bloc.dart';
import 'package:the_english_spiders/Learning/adjectives/bloc/learn_adjective_event.dart';
import 'package:the_english_spiders/data/models/adjective_model.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_card_header.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_details.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_detail_row.dart';
import 'package:the_english_spiders/core/ui/shared/audio_type.dart';
import 'package:the_english_spiders/Learning/shared/item_card/expandable_item_card.dart';
import 'package:the_english_spiders/core/ui/text/string_extensions.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class AdjectiveCard extends StatelessWidget {
  final Adjective adjective;

  const AdjectiveCard({
    super.key,
    required this.adjective,
  });

  @override
  Widget build(BuildContext context) {
        Theme.of(context);
    return ExpandableItemCard(
      title: Row(
        children: [
          Expanded(
            child: ItemCardHeader<Adjective>(
              item: adjective,
              isExpanded: false,
              onTap: () {},
              displayValue: (Adjective a) => a.mainAdjective,
              audioData: (Adjective a) => a.mainAdjectiveAudio,
            ),
          ),
           const SizedBox(width: AppConstants.marginExtraSmall),
          Expanded(
            child: ItemCardHeader<Adjective>(
              item: adjective,
              isExpanded: false,
              onTap: () {},
              displayValue: (Adjective a) => a.reverseAdjective,
              audioData: (Adjective a) => a.reverseAdjectiveAudio,
            ),
          ),
        ],
      ),
      content: Padding(
        padding:  const EdgeInsets.all(AppConstants.paddingSmall),
        child: ItemDetails(
          rows: [
            ItemDetailRow(
              richValue:
                  adjective.mainExample.formatWithHighlight(AppConstants.primaryColor),
              audio: adjective.mainExampleAudio,
              onPlayAudio: (audioData) {
                context.read<LearnAdjectiveBloc>().add(PlayAdjectiveAudio(
                    adjective: adjective, audioType: AudioType.example));
              },
            ),
            ItemDetailRow(
              richValue: adjective.reverseExample
                  .formatWithHighlight(AppConstants.accentColor), // استخدام extension
              audio: adjective.reverseExampleAudio,
              onPlayAudio: (audioData) {
                context.read<LearnAdjectiveBloc>().add(PlayAdjectiveAudio(
                    adjective: adjective, audioType: AudioType.example));
              },
            ),
          ],
        ),
      ),
    );
  }
}