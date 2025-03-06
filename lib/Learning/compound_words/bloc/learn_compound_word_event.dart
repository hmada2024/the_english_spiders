// lib/Learning_section/blocs/learn_compound_word/learn_compound_word_event.dart
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/data/models/compound_word_model.dart';
import 'package:the_english_spiders/core/ui/shared/audio_type.dart';

abstract class LearnCompoundWordEvent extends Equatable {
  const LearnCompoundWordEvent();

  @override
  List<Object?> get props => [];
}

class LoadCompoundWords extends LearnCompoundWordEvent {
  const LoadCompoundWords();
}

class SelectCompoundWord extends LearnCompoundWordEvent {
  final CompoundWord compoundWord;
  const SelectCompoundWord(this.compoundWord);

  @override
  List<Object?> get props => [compoundWord];
}

class PlayCompoundWordAudio extends LearnCompoundWordEvent {
  final CompoundWord compoundWord;
  final AudioType audioType; 
  const PlayCompoundWordAudio(this.compoundWord, this.audioType);

  @override
  List<Object?> get props => [compoundWord, audioType];
}