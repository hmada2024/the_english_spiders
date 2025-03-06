import 'dart:typed_data';
import 'package:the_english_spiders/core/config/database_constants.dart';

class PhrasalVerb {
  final int id;
  final String expression;
  final String mainVerb;
  final String particle;
  final String meaning;
  final String example;
  final String translation;
  final Uint8List? audio;

  PhrasalVerb({
    required this.id,
    required this.expression,
    required this.mainVerb,
    required this.particle,
    required this.meaning,
    required this.example,
    required this.translation,
    this.audio,
  });

  factory PhrasalVerb.fromMap(Map<String, dynamic> map) {
    return PhrasalVerb(
      id: map[Constants.phrasalVerbIdColumn] as int,
      expression: map[Constants.phrasalVerbExpressionColumn] as String,
      mainVerb: map[Constants.phrasalVerbMainVerbColumn] as String,
      particle: map[Constants.phrasalVerbParticleColumn] as String,
      meaning: map[Constants.phrasalVerbMeaningColumn] as String,
      example: map[Constants.phrasalVerbExampleColumn] as String,
      translation: map[Constants.phrasalVerbTranslationColumn] as String,
      audio: map[Constants.phrasalVerbAudioColumn] as Uint8List?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.phrasalVerbIdColumn: id,
      Constants.phrasalVerbExpressionColumn: expression,
      Constants.phrasalVerbMainVerbColumn: mainVerb,
      Constants.phrasalVerbParticleColumn: particle,
      Constants.phrasalVerbMeaningColumn: meaning,
      Constants.phrasalVerbExampleColumn: example,
      Constants.phrasalVerbTranslationColumn: translation,
      Constants.phrasalVerbAudioColumn: audio,
    };
  }

    PhrasalVerb copyWith({
    int? id,
    String? expression,
    String? mainVerb,
    String? particle,
    String? meaning,
    String? example,
    String? translation,
    Uint8List? audio,
  }) {
    return PhrasalVerb(
      id: id ?? this.id,
      expression: expression ?? this.expression,
      mainVerb: mainVerb ?? this.mainVerb,
      particle: particle ?? this.particle,
      meaning: meaning ?? this.meaning,
      example: example ?? this.example,
      translation: translation ?? this.translation,
      audio: audio ?? this.audio,
    );
  }
}