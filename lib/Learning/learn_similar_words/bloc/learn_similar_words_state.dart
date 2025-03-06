//lib/Learning_section/blocs/learn_similar_words/learn_similar_words_state.dart

import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/data/models/similar_words_models.dart';

class LearnSimilarWordsState extends Equatable {
  final List<SeedWithBranches> seedsWithBranches;
  final bool isLoading;
  final String? error;

  const LearnSimilarWordsState({
    this.seedsWithBranches = const [],
    this.isLoading = false,
    this.error,
  });

    LearnSimilarWordsState copyWith({
        List<SeedWithBranches>? seedsWithBranches,
        bool? isLoading,
        String? error,
    }) {
      return LearnSimilarWordsState(
        seedsWithBranches: seedsWithBranches ?? this.seedsWithBranches,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
    }

  @override
  List<Object?> get props => [seedsWithBranches, isLoading, error];
}