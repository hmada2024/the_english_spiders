//lib/Games/image_word_matching/ui/card_widget.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/Games/image_word_matching/bloc/image_word_matching_bloc.dart';
import 'package:the_english_spiders/Games/image_word_matching/bloc/image_word_matching_event.dart';
import 'package:the_english_spiders/Games/image_word_matching/models/card_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardWidget extends StatelessWidget {
  final CardData card;
  final VoidCallback onTap;

  const CardWidget({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: card.isMatched
              ? Colors.green.withValues(alpha: 0.5)
              : (card.isFlipped
                  ? Colors.white
                  : theme.primaryColor), // Use a distinct color
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: card.isMatched
                ? Colors.green
                : theme.primaryColor, // Use a matching border
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          // Important for rounded corners with images
          borderRadius: BorderRadius.circular(10),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: card.isFlipped || card.isMatched
                ? (card.type == CardType.image
                    ? _buildImageContent()
                    : _buildWordContent(context))
                : _buildCardBack(), // Show back of card
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent() {
    return Image.memory(
      card.displayData,
      fit: BoxFit.cover, // Cover the entire container
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Image.asset(
          'assets/images/placeholder_image.jpg',
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildWordContent(BuildContext context) {
    return InkWell(
      onTap: () => context
          .read<ImageWordMatchingBloc>()
          .add(PlayAudioEvent(audioBytes: card.audio!)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            card.displayData,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return const Center(
        child: Icon(
      Icons.question_mark,
      size: 48,
      color: Colors.white,
    ));
  }
}