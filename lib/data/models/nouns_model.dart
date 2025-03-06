//lib/data/models/nouns_model.dart
import 'package:the_english_spiders/data/models/displayable_item.dart'; 
import 'dart:typed_data';


class Noun extends DisplayableItem { 
  final String category;

  Noun({
    required super.id,
    required super.name,
    super.image,
    super.audio,
    required this.category,
  });

  factory Noun.fromMap(Map<String, dynamic> map) {
    return Noun(
      id: map['id'] as int,
      name: map['name'] as String,
      image: map['image'] as Uint8List?,
      audio: map['audio'] as Uint8List?,
      category: map['category'] as String,
    );
  }

  @override 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'audio': audio,
      'category': category,
    };
  }

  @override
  Noun copyWith({
      int? id,
      String? name,
      Uint8List? image,
      Uint8List? audio,
      String? category
      }) {
          return Noun(
              id: id ?? this.id,
              name: name ?? this.name,
              image: image ?? this.image,
              audio: audio ?? this.audio,
              category: category ?? this.category,
          );
      }
}