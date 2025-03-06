//lib/data/models/verb_conjugations_models.dart
import 'dart:typed_data';

import 'package:the_english_spiders/core/config/database_constants.dart';

class Verb {
  final int? id;
  final String baseForm;
  final String? translation;
  final String verbType;
  final Uint8List? baseAudio;
  final List<Conjugations>? conjugations;
  bool get isRegular => verbType == Constants.regularVerbCategory;

  Verb({
    this.id,
    required this.baseForm,
    this.translation,
    required this.verbType,
    this.baseAudio,
    this.conjugations,
  });

  factory Verb.fromMap(Map<String, dynamic> map) {
    return Verb(
      id: map[Constants.verbIdColumn],
      baseForm: map[Constants.verbBaseFormColumn] ?? '',
      translation: map[Constants.verbTranslationColumn],
      verbType: map[Constants.verbTypeColumn] ?? '',
      baseAudio: map[Constants.verbBaseAudioColumn],
      conjugations: [],
    );
  }

    Verb copyWith({
    int? id,
    String? baseForm,
    String? translation,
    String? verbType,
    Uint8List? baseAudio,
    List<Conjugations>? conjugations,
    }) {
    return Verb(
        id: id ?? this.id,
        baseForm: baseForm ?? this.baseForm,
        translation: translation ?? this.translation,
        verbType: verbType ?? this.verbType,
        baseAudio: baseAudio ?? this.baseAudio,
        conjugations: conjugations ?? this.conjugations,
    );
    }

  Map<String, dynamic> toMap() {
    return {
      Constants.verbIdColumn: id,
      Constants.verbBaseFormColumn: baseForm,
      Constants.verbTranslationColumn: translation,
      Constants.verbTypeColumn: verbType,
      Constants.verbBaseAudioColumn: baseAudio,
    };
  }
}

class Conjugations {
  final int? id;
  final int verbId;
  final String? pastForm;
  final Uint8List? pastAudio;
  final String? pPForm;
  final Uint8List? ppAudio;

  Conjugations({
    this.id,
    required this.verbId,
    this.pastForm,
    this.pastAudio,
    this.pPForm,
    this.ppAudio,
  });

  factory Conjugations.fromMap(Map<String, dynamic> map) {
    return Conjugations(
      id: map[Constants.conjugationIdColumn],
      verbId: map[Constants.conjugationVerbIdColumn] ?? 0,
      pastForm: map[Constants.conjugationPastFormColumn],
      pastAudio: map[Constants.conjugationPastAudioColumn],
      pPForm: map[Constants.conjugationPPFormColumn],
      ppAudio: map[Constants.conjugationPPAudioColumn],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.conjugationIdColumn: id,
      Constants.conjugationVerbIdColumn: verbId,
      Constants.conjugationPastFormColumn: pastForm,
      Constants.conjugationPastAudioColumn: pastAudio,
      Constants.conjugationPPFormColumn: pPForm,
      Constants.conjugationPPAudioColumn: ppAudio,
    };
  }
}