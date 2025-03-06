
//lib/data/models/image_segment_model.dart
import 'package:the_english_spiders/core/config/database_constants.dart';

class ImageSegment {
  final int id;
  final String text;
  final int imageId;
  final int segmentOrder;

  ImageSegment({
    required this.id,
    required this.text,
    required this.imageId,
    required this.segmentOrder,
  });

  factory ImageSegment.fromMap(Map<String, dynamic> map) {
    return ImageSegment(
      id: map[Constants.sentenceIdColumn] as int,
      text: map[Constants.segmentTextColumn] as String,
      imageId: map[Constants.segmentImageIdColumn] as int,
      segmentOrder: map[Constants.segmentOrderColumn] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Constants.sentenceIdColumn: id,
      Constants.segmentTextColumn: text,
      Constants.segmentImageIdColumn: imageId,
      Constants.segmentOrderColumn: segmentOrder,
    };
  }
}
