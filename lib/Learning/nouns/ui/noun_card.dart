//lib/Learning_section/categories/nouns/noun_card.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/Learning/shared/item_card/audio_button.dart';
import 'package:the_english_spiders/data/models/displayable_item.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/ui/shared/bounce_animation.dart';
import 'package:the_english_spiders/Learning/nouns/ui/image_section.dart';
import 'package:the_english_spiders/Learning/nouns/ui/name_overlay.dart';

class ItemCard<T extends DisplayableItem> extends StatelessWidget {
  final T item;
  final int index;
  final VoidCallback? onPlayAudio;

  const ItemCard({
    super.key,
    required this.item,
    required this.index,
    this.onPlayAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fontSize = constraints.maxWidth * 0.05;
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  boxShadow: const [
                    BoxShadow(
                      color: AppConstants.shadowColor,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                  child: BounceAnimation(
                    onTap: onPlayAudio,
                    child: SizedBox(
                      width: constraints.maxWidth * 0.8,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ImageSection(
                            imageBytes: item.image,
                            width: constraints.maxWidth * 0.8,
                            height: constraints.maxHeight * 0.25,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(4.0),
                              child: NameOverlay(
                                name: item.name,
                                fontSize: fontSize,
                                textColor: Colors.black,
                              ),
                            ),
                          ),
                          Positioned(
                            top: constraints.maxHeight * 0.02,
                            right: constraints.maxWidth * 0.02,
                            child: AudioButton(
                              iconSize: constraints.maxWidth * 0.07,
                              onPressed: onPlayAudio,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}