import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/modal_semi_modal_verbs/bloc/learn_modal_semi_modal_verb_bloc.dart';
import 'package:the_english_spiders/Learning/shared/item_card/expandable_item_card.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_card_header.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_details.dart';
import 'package:the_english_spiders/Learning/shared/item_card/item_detail_row.dart';
import 'package:the_english_spiders/data/models/modal_semi_modal_verb_model.dart';

class ModalSemiModalVerbCard extends StatelessWidget {
  final ModalSemiModalVerb modalSemiModalVerb;

  const ModalSemiModalVerbCard({super.key, required this.modalSemiModalVerb});

  @override
  Widget build(BuildContext context) {
    return ExpandableItemCard(
      title: ItemCardHeader<ModalSemiModalVerb>(
        item: modalSemiModalVerb,
        isExpanded: false,
        onTap: () {},
        displayValue: (ModalSemiModalVerb m) => m.main,
        audioData: (ModalSemiModalVerb m) => m.audio, // For main audio
      ),
      content: _buildContent(context),
    );
  }

    Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ItemDetails(
        rows: [
          ItemDetailRow(
            value: modalSemiModalVerb.example,
            audio: modalSemiModalVerb.exampleAudio, // Pass example audio
            onPlayAudio: (audio) {
              context.read<LearnModalSemiModalVerbBloc>().add(
                  PlayModalSemiModalVerbExampleAudio(
                      modalSemiModalVerb: modalSemiModalVerb));
                        },
          ),
        ],
      ),
    );
  }
}