//lib/data/models/displayable_item.dart
import 'dart:typed_data';

abstract class DisplayableItem {
  final int id;
  final String name;
  final Uint8List? image;
  final Uint8List? audio;

  DisplayableItem({
    required this.id,
    required this.name,
    this.image,
    this.audio,
  });

  Map<String, dynamic> toMap();

  DisplayableItem copyWith({
    int? id,
    String? name,
    Uint8List? image,
    Uint8List? audio,
  });
}