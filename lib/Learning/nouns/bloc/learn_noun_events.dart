// lib/Learning/nouns/bloc/learn_noun_events.dart
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/data/models/displayable_item.dart';
import 'package:flutter/material.dart'; //  أضف هذا

abstract class LearnNounEvent extends Equatable {
  const LearnNounEvent();

  @override
  List<Object?> get props => [];
}

class LoadNouns extends LearnNounEvent {
  final String category;
  final BuildContext context; // أضف هذا

  const LoadNouns({required this.category, required this.context}); // وعدّل هنا

  @override
  List<Object?> get props => [category, context]; // وعدّل هنا
}

class LoadCategories extends LearnNounEvent {
  const LoadCategories();
}

class SelectNoun extends LearnNounEvent {
  final DisplayableItem noun;

  const SelectNoun(this.noun);

  @override
  List<Object?> get props => [noun];
}

class PlayNounAudio extends LearnNounEvent {
  final DisplayableItem noun;

  const PlayNounAudio(this.noun);

  @override
  List<Object?> get props => [noun];
}