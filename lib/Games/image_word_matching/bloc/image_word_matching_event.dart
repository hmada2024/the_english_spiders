//lib/Games/image_word_matching/bloc/image_word_matching_event.dart
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/Games/image_word_matching/models/card_data.dart';

abstract class ImageWordMatchingEvent extends Equatable {
  const ImageWordMatchingEvent();

  @override
  List<Object> get props => [];
}

class LoadMatchingPairs extends ImageWordMatchingEvent {}

class FlipCard extends ImageWordMatchingEvent {
  final CardData card;

  const FlipCard({required this.card});

  @override
  List<Object> get props => [card];
}
class PlayAudioEvent extends ImageWordMatchingEvent {
  final Uint8List audioBytes;

  const PlayAudioEvent({required this.audioBytes});
    @override
  List<Object> get props => [audioBytes];

}

//حدث ايقاف الصوت
class StopAudioEvent extends ImageWordMatchingEvent {}

class ResetGame extends ImageWordMatchingEvent {}