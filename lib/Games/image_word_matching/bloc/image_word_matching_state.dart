//lib/Games/image_word_matching/bloc/image_word_matching_state.dart
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/Games/image_word_matching/models/card_data.dart';

enum ImageWordMatchingStatus { initial, loading, loaded, error, completed }

class ImageWordMatchingState extends Equatable {
  final List<CardData> cards;
  final List<CardData> flippedCards;
  final bool isProcessing;
  final int score;
  final int matchedQuestions; // Number of matched pairs
  final int totalQuestions;
  final String? error;
  final ImageWordMatchingStatus status;

  const ImageWordMatchingState({
    this.cards = const [],
    this.flippedCards = const [],
    this.isProcessing = false,
    this.score = 0,
    this.matchedQuestions = 0,
    this.totalQuestions = 0,
    this.error,
    this.status = ImageWordMatchingStatus.initial,
  });

  ImageWordMatchingState copyWith({
    List<CardData>? cards,
    List<CardData>? flippedCards,
    bool? isProcessing,
    int? score,
    int? matchedQuestions,
    int? totalQuestions,
    String? error,
    ImageWordMatchingStatus? status,
  }) {
    return ImageWordMatchingState(
      cards: cards ?? this.cards,
      flippedCards: flippedCards ?? this.flippedCards,
      isProcessing: isProcessing ?? this.isProcessing,
      score: score ?? this.score,
      matchedQuestions: matchedQuestions ?? this.matchedQuestions,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      error: error, // Don't use ?? this.error
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        cards,
        flippedCards,
        isProcessing,
        score,
        matchedQuestions,
        totalQuestions,
        error,
        status,
      ];
}