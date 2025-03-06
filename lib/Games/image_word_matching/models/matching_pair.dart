//lib/Games/image_word_matching/models/matching_pair.dart
import 'dart:typed_data';

class MatchingPair {
  final int id;
  final Uint8List image;
  final String word;
  final Uint8List audio;

  MatchingPair({
    required this.id,
    required this.image,
    required this.word,
    required this.audio,
  });
}