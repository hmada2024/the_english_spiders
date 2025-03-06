//lib/data/models/sentence_model.dart
import 'dart:typed_data';

import 'package:the_english_spiders/core/config/database_constants.dart';
import 'package:the_english_spiders/data/models/image_segment_model.dart';

class Sentence {
  final int id;
  final Uint8List? image;
  final String? fullText;
  final Uint8List? audio;
  final List<ImageSegment> segments;

  Sentence({
    required this.id,
    this.image,
    this.fullText,
    this.audio,
    List<ImageSegment>? segments,
  }) : segments = segments ?? [];

  factory Sentence.fromMap(Map<String, dynamic> map) {
    return Sentence(
      id: map[Constants.imageIdColumn] as int,
      image: map[Constants.sentenceImageColumn] as Uint8List?,
      fullText: map[Constants.sentenceFullTextColumn] as String?,
      audio: map[Constants.sentenceAudioColumn] as Uint8List?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.imageIdColumn: id,
      Constants.sentenceImageColumn: image,
      Constants.sentenceFullTextColumn: fullText,
      Constants.sentenceAudioColumn: audio,
    };
  }
}
