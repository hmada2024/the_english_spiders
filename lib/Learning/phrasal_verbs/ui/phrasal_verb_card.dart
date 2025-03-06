import 'package:flutter/material.dart';
import 'package:the_english_spiders/Learning/shared/item_card/expandable_item_card.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_card_header.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_details.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_detail_row.dart';
import 'package:the_english_spiders/data/models/phrasal_verb_model.dart';

class PhrasalVerbCard extends StatelessWidget {
  final PhrasalVerb phrasalVerb;

  const PhrasalVerbCard({super.key, required this.phrasalVerb});

  @override
  Widget build(BuildContext context) {
    return ExpandableItemCard(
      title: ItemCardHeader<PhrasalVerb>(
        item: phrasalVerb,
        isExpanded: false,
        onTap: () {},
        displayValue: (PhrasalVerb p) => p.expression,
        audioData: (PhrasalVerb p) =>
            p.audio,
      ),
      content: _buildPhrasalVerbContent(context),
    );
  }

  Widget _buildPhrasalVerbContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ItemDetails(
        rows: [
          ItemDetailRow(
            title: 'Meaning',
            value: phrasalVerb.meaning,
          ),
           ItemDetailRow(
            title: 'Example',
            value: phrasalVerb.example,
          ),
        ],
      ),
    );
  }
}