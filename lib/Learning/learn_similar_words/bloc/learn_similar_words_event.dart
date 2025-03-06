// lib/Learning_section/blocs/learn_similar_words/learn_similar_words_event.dart

import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/data/models/similar_words_models.dart';

abstract class LearnSimilarWordsEvent extends Equatable {
  const LearnSimilarWordsEvent();
    @override
    List<Object?> get props => [];
}

class LoadSimilarWords extends LearnSimilarWordsEvent {}

class PlaySeedWordAudio extends LearnSimilarWordsEvent {
  final SeedWord seedWord;
  const PlaySeedWordAudio(this.seedWord);
  @override
  List<Object?> get props => [seedWord];
}

class PlayBranchWordAudio extends LearnSimilarWordsEvent {
  final BranchWord branchWord;
  const PlayBranchWordAudio(this.branchWord);
  @override
List<Object?> get props => [branchWord];
}