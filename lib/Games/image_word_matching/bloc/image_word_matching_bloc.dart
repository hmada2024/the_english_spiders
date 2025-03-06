//lib/Games/image_word_matching/bloc/image_word_matching_bloc.dart
import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/data/models/nouns_model.dart';
import 'package:the_english_spiders/data/repositories/noun_repository.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/Games/image_word_matching/bloc/image_word_matching_event.dart';
import 'package:the_english_spiders/Games/image_word_matching/bloc/image_word_matching_state.dart';
import 'package:the_english_spiders/Games/image_word_matching/models/card_data.dart';
import 'package:the_english_spiders/Games/image_word_matching/models/matching_pair.dart';

class ImageWordMatchingBloc
    extends Bloc<ImageWordMatchingEvent, ImageWordMatchingState> {
  final NounRepository _nounRepository;
  final AudioService _audioService;
  final AssetBundle _assetBundle;
  Timer? _timer;

  ImageWordMatchingBloc(this._nounRepository, this._audioService, this._assetBundle)
      : super(const ImageWordMatchingState()) {
    on<LoadMatchingPairs>(_onLoadMatchingPairs);
    on<FlipCard>(_onFlipCard);
    on<ResetGame>(_onResetGame);
    on<PlayAudioEvent>(_onPlayAudio);
    on<StopAudioEvent>(_onStopAudio);
  }

    Future<void> _onLoadMatchingPairs(
      LoadMatchingPairs event, Emitter<ImageWordMatchingState> emit) async {
    if (state.status == ImageWordMatchingStatus.loading) return;
        emit(state.copyWith(status: ImageWordMatchingStatus.loading, error: null));
        try {
            final nouns = await _nounRepository.getNounsForMatchingQuiz();
            if (nouns.isEmpty) {
              emit(state.copyWith(
                  status: ImageWordMatchingStatus.error,
                  error: 'No nouns found for matching.'));
              return;
            }
            final List<MatchingPair> pairs = _createMatchingPairs(nouns);
            final List<CardData> cards = _createCardDataList(pairs);
            emit(state.copyWith(
                status: ImageWordMatchingStatus.loaded,
                cards: cards,
                totalQuestions: pairs.length,
                matchedQuestions: 0, // Reset matched pairs
                score: 0, // Reset score
            ));
            } catch (e) {
              emit(state.copyWith(
                  status: ImageWordMatchingStatus.error,
                  error: 'Failed to load matching pairs: $e'));
            }
          }

  List<MatchingPair> _createMatchingPairs(List<Noun> nouns) {
    final List<MatchingPair> pairs = [];
    final random = Random();
    final usedIndices = <int>{};

    while (pairs.length < 8 &&
        usedIndices.length <
            nouns.length) { // Limit to max 8 pairs AND available nouns
      int index = random.nextInt(nouns.length);
      if (!usedIndices.contains(index)) {
        usedIndices.add(index);
        final noun = nouns[index];
        if (noun.image != null && noun.audio != null) { //  Important null check!
          pairs.add(MatchingPair(
            id: noun.id,
            image: noun.image!,
            word: noun.name,
            audio: noun.audio!,
          ));
        }
      }
    }
    return pairs;
  }

  List<CardData> _createCardDataList(List<MatchingPair> pairs) {
    final List<CardData> cards = [];
    for (final pair in pairs) {
      cards.add(CardData(
        pairId: pair.id,
        displayData: pair.image,
        type: CardType.image,
        audio: pair.audio,
      ));
      cards.add(CardData(
        pairId: pair.id,
        displayData: pair.word,
        type: CardType.word,
        audio: pair.audio,
      ));
    }
    cards.shuffle(Random()); // Shuffle!
    return cards;
  }
  Future<void> _onFlipCard(
    FlipCard event, Emitter<ImageWordMatchingState> emit) async {
  // 1. Check if we should even flip
  if (state.isProcessing ||
      event.card.isMatched ||
      state.flippedCards.contains(event.card)) {
    return;
  }

  // 2. Flip the card and add to flippedCards
  final List<CardData> currentFlippedCards = List.from(state.flippedCards);
  final updatedCard = event.card.copyWith(isFlipped: true);
  final List<CardData> updatedCards = state.cards.map((card) {
    return card == event.card ? updatedCard : card;
  }).toList();
  currentFlippedCards.add(updatedCard);

  // 3. Update the state to show the flipped card
  emit(state.copyWith(
    cards: updatedCards,
    flippedCards: currentFlippedCards,
  ));

  // 4. Check if two cards are flipped
  if (currentFlippedCards.length == 2) {
      emit(state.copyWith(isProcessing: true)); // NOW set isProcessing
    final card1 = currentFlippedCards[0];
    final card2 = currentFlippedCards[1];

    if (card1.pairId == card2.pairId) {
      // Match found
      final newCards = state.cards.map((c) {
        if (c.pairId == card1.pairId) {
          return c.copyWith(isMatched: true);
        }
        return c;
      }).toList();

      try {
        await _audioService
            .start(await _getAssetData(AppConstants.correctAnswerSound));
      } catch (e) {
        debugPrint("Error playing sound: $e");
      }

      emit(state.copyWith(
        cards: newCards,
        flippedCards: [],
        score: state.score + 1,
        matchedQuestions: state.matchedQuestions + 1,
        isProcessing: false, // Reset after match
      ));

      if (state.matchedQuestions == state.totalQuestions) {
        emit(state.copyWith(status: ImageWordMatchingStatus.completed));
      }
    } else {
      // No match:  Timer starts *before* emitting state.
      try {
        await _audioService.start(await _getAssetData(AppConstants.wrongAnswerSound));
      } catch (e) {
          debugPrint("Error playing sound: $e");
      }
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 1), () {

        if (emit.isDone) return;
        final List<CardData> resetCards = state.cards.map((card) {
          return currentFlippedCards.contains(card)
              ? card.copyWith(isFlipped: false)
              : card;
        }).toList();

        emit(state.copyWith(
            cards: resetCards, flippedCards: [], isProcessing: false));
      });
    }
  }
  // No else needed!  If only one card, we *don't* change isProcessing.
}

  Future<void> _onResetGame(
      ResetGame event, Emitter<ImageWordMatchingState> emit) async {
    _timer?.cancel();
    await _audioService.stop();
    emit(const ImageWordMatchingState());
    add(LoadMatchingPairs());
  }

    Future<void> _onPlayAudio(
      PlayAudioEvent event, Emitter<ImageWordMatchingState> emit) async {
        // ignore: unnecessary_null_comparison
        if (event.audioBytes != null)
        {
            await _audioService.start(event.audioBytes);
        }
  }

  Future<void> _onStopAudio(
      StopAudioEvent event, Emitter<ImageWordMatchingState> emit) async {
    await _audioService.stop();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

    Future<Uint8List> _getAssetData(String assetPath) async {
    final byteData = await _assetBundle.load(assetPath);
    return byteData.buffer.asUint8List();
  }
}

//  NavigationService (no changes needed, but shown for completeness)
class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}