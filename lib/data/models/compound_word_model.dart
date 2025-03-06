//lib/data/models/compound_word_model.dart
import 'dart:typed_data';
import 'package:the_english_spiders/core/config/database_constants.dart';

class CompoundWord {
  final int id;
  final String main;
  final String part1;
  final String part2;
  final String? example;
  final Uint8List? mainAudio;
  final Uint8List? mainExampleAudio;

  CompoundWord({
    required this.id,
    required this.main,
    required this.part1,
    required this.part2,
    this.example,
    this.mainAudio,
    this.mainExampleAudio,
  });

  // Add the fromMap factory constructor
  factory CompoundWord.fromMap(Map<String, dynamic> map) {
    return CompoundWord(
      id: map[Constants.compoundWordIdColumn] as int,
      main: map[Constants.compoundWordMainColumn] as String,
      part1: map[Constants.compoundWordPart1Column] as String,
      part2: map[Constants.compoundWordPart2Column] as String,
      example: map[Constants.compoundWordExampleColumn] as String?,
      mainAudio: map[Constants.compoundWordMainAudioColumn] as Uint8List?,
      mainExampleAudio:
          map[Constants.compoundWordExampleAudioColumn] as Uint8List?,
    );
  }

  // Add the toMap method
  Map<String, dynamic> toMap() {
    return {
      Constants.compoundWordIdColumn: id,
      Constants.compoundWordMainColumn: main,
      Constants.compoundWordPart1Column: part1,
      Constants.compoundWordPart2Column: part2,
      Constants.compoundWordExampleColumn: example,
      Constants.compoundWordMainAudioColumn: mainAudio,
      Constants.compoundWordExampleAudioColumn: mainExampleAudio,
    };
  }
}
