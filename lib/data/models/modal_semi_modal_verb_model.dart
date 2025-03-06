import 'dart:typed_data';
import 'package:the_english_spiders/core/config/database_constants.dart';

class ModalSemiModalVerb {
  final int id;
  final String main;
  final String example;
  final String tense;
  final String type;
  final String translation;
  final Uint8List? audio;
  final Uint8List? exampleAudio;

  ModalSemiModalVerb({
    required this.id,
    required this.main,
    required this.example,
    required this.tense,
    required this.type,
    required this.translation,
    this.audio,
    this.exampleAudio,
  });

  factory ModalSemiModalVerb.fromMap(Map<String, dynamic> map) {
    return ModalSemiModalVerb(
      id: map[Constants.modalSemiModalVerbIdColumn] as int,
      main: map[Constants.modalSemiModalVerbMainColumn] as String,
      example: map[Constants.modalSemiModalVerbExampleColumn] as String,
      tense: map[Constants.modalSemiModalVerbTenseColumn] as String,
      type: map[Constants.modalSemiModalVerbTypeColumn] as String,
      translation: map[Constants.modalSemiModalVerbTranslationColumn] as String,
      audio: map[Constants.modalSemiModalVerbAudioColumn] as Uint8List?,
      exampleAudio:
          map[Constants.modalSemiModalVerbExampleAudioColumn] as Uint8List?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.modalSemiModalVerbIdColumn: id,
      Constants.modalSemiModalVerbMainColumn: main,
      Constants.modalSemiModalVerbExampleColumn: example,
      Constants.modalSemiModalVerbTenseColumn: tense,
      Constants.modalSemiModalVerbTypeColumn: type,
      Constants.modalSemiModalVerbTranslationColumn: translation,
      Constants.modalSemiModalVerbAudioColumn: audio,
      Constants.modalSemiModalVerbExampleAudioColumn: exampleAudio,
    };
  }

  ModalSemiModalVerb copyWith({
    int? id,
    String? main,
    String? example,
    String? tense,
    String? type,
    String? translation,
    Uint8List? audio,
    Uint8List? exampleAudio,
  }) {
    return ModalSemiModalVerb(
      id: id ?? this.id,
      main: main ?? this.main,
      example: example ?? this.example,
      tense: tense ?? this.tense,
      type: type ?? this.type,
      translation: translation ?? this.translation,
      audio: audio ?? this.audio,
      exampleAudio: exampleAudio ?? this.exampleAudio,
    );
  }
}