//lib/data/models/adjective_model.dart
import 'package:flutter/foundation.dart';
import 'package:the_english_spiders/core/config/database_constants.dart';

class Adjective {
  final int id;
  final String mainAdjective;
  final String mainExample;
  final String reverseAdjective;
  final String reverseExample;
  final Uint8List? mainAdjectiveAudio;
  final Uint8List? reverseAdjectiveAudio;
  final Uint8List? mainExampleAudio;
  final Uint8List? reverseExampleAudio;

  Adjective({
    required this.id,
    required this.mainAdjective,
    required this.mainExample,
    required this.reverseAdjective,
    required this.reverseExample,
    this.mainAdjectiveAudio,
    this.reverseAdjectiveAudio,
    this.mainExampleAudio,
    this.reverseExampleAudio,
  });

  factory Adjective.fromMap(Map<String, dynamic> map) {
    return Adjective(
      id: map[Constants.adjectiveIdColumn] as int,
      mainAdjective: map[Constants.mainAdjectiveColumn] as String? ?? '', // Empty string is fine for strings
      mainExample: map[Constants.mainExampleColumn] as String? ?? '', // Use empty string, we'll handle display logic later.
      reverseAdjective: map[Constants.reverseAdjectiveColumn] as String? ?? '',
      reverseExample: map[Constants.reverseExampleColumn] as String? ?? '', // Use empty string
      mainAdjectiveAudio: map[Constants.mainAdjectiveAudioColumn] as Uint8List?,
      reverseAdjectiveAudio: map[Constants.reverseAdjectiveAudioColumn] as Uint8List?,
      mainExampleAudio: map[Constants.mainExampleAudioColumn] as Uint8List?,
      reverseExampleAudio: map[Constants.reverseExampleAudioColumn] as Uint8List?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.adjectiveIdColumn: id,
      Constants.mainAdjectiveColumn: mainAdjective,
      Constants.mainExampleColumn: mainExample,
      Constants.reverseAdjectiveColumn: reverseAdjective,
      Constants.reverseExampleColumn: reverseExample,
      Constants.mainAdjectiveAudioColumn: mainAdjectiveAudio,
      Constants.reverseAdjectiveAudioColumn: reverseAdjectiveAudio,
      Constants.mainExampleAudioColumn: mainExampleAudio,
      Constants.reverseExampleAudioColumn: reverseExampleAudio,
    };
  }
}