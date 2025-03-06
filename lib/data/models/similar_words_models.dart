//lib/data/models/similar_words_models.dart
import 'dart:typed_data';
import 'package:the_english_spiders/core/config/database_constants.dart'; // Import

class SeedWord {
  final int id;
  final String seedWord;
  final String translations;
  final String examples;
  final Uint8List? audio;

  SeedWord({
    required this.id,
    required this.seedWord,
    required this.translations,
    required this.examples,
    this.audio,
  });

  factory SeedWord.fromMap(Map<String, dynamic> map) {
    return SeedWord(
      id: map[Constants.seedIdColumn] as int,
      seedWord: map[Constants.seedWordColumn] as String,
      translations: map[Constants.seedTranslationsColumn] as String,
      examples: map[Constants.seedExamplesColumn] as String,
      audio: map[Constants.seedAudioColumn] as Uint8List?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.seedIdColumn: id,
      Constants.seedWordColumn: seedWord,
      Constants.seedTranslationsColumn: translations,
      Constants.seedExamplesColumn: examples,
      Constants.seedAudioColumn: audio,
    };
  }

  SeedWord copyWith({
    int? id,
    String? seedWord,
    String? translations,
    String? examples,
    Uint8List? audio,
  }) {
    return SeedWord(
      id: id ?? this.id,
      seedWord: seedWord ?? this.seedWord,
      translations: translations ?? this.translations,
      examples: examples ?? this.examples,
      audio: audio ?? this.audio,
    );
  }
}

class BranchWord {
  final int id;
  final int seedId;
  final String similarWord;
  final String translations;
  final String examples;
  final Uint8List? audio;

  BranchWord({
    required this.id,
    required this.seedId,
    required this.similarWord,
    required this.translations,
    required this.examples,
    this.audio,
  });

  factory BranchWord.fromMap(Map<String, dynamic> map) {
    return BranchWord(
      id: map[Constants.branchIdColumn] as int,
      seedId: map[Constants.branchSeedIdColumn] as int,
      similarWord: map[Constants.branchSimilarWordColumn] as String,
      translations: map[Constants.branchTranslationsColumn] as String,
      examples: map[Constants.branchExamplesColumn] as String,
      audio: map[Constants.branchAudioColumn] as Uint8List?,
    );
  }

    Map<String, dynamic> toMap() {
    return {
      Constants.branchIdColumn: id,
      Constants.branchSeedIdColumn: seedId,
      Constants.branchSimilarWordColumn: similarWord,
      Constants.branchTranslationsColumn: translations,
      Constants.branchExamplesColumn: examples,
      Constants.branchAudioColumn: audio,
    };
  }

  BranchWord copyWith({
    int? id,
    int? seedId,
    String? similarWord,
    String? translations,
    String? examples,
    Uint8List? audio,
  }) {
    return BranchWord(
      id: id ?? this.id,
      seedId: seedId ?? this.seedId,
      similarWord: similarWord ?? this.similarWord,
      translations: translations ?? this.translations,
      examples: examples ?? this.examples,
      audio: audio ?? this.audio,
    );
  }
}

class SeedWithBranches {
  final SeedWord seed;
  final List<BranchWord> branches;

  SeedWithBranches({required this.seed, required this.branches});
}