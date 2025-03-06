//lib/Games/image_word_matching/models/card_data.dart
import 'package:equatable/equatable.dart';
import 'dart:typed_data';

enum CardType { image, word }

class CardData extends Equatable {
  final int pairId;
  final dynamic displayData; // Can be String (for word) or Uint8List (for image)
  final CardType type;
  final bool isFlipped;
  final bool isMatched;
  final Uint8List? audio; // Use Uint8List for audio data

  const CardData({
    required this.pairId,
    required this.displayData,
    required this.type,
    this.isFlipped = false,
    this.isMatched = false,
    this.audio,
  });

  CardData copyWith({
    bool? isFlipped,
    bool? isMatched,
  }) {
    return CardData(
      pairId: pairId,
      displayData: displayData,
      type: type,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
      audio: audio,
    );
  }

  @override
  List<Object?> get props => [pairId, displayData, type, isFlipped, isMatched, audio];
}