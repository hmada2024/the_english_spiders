//lib/Learning_section/blocs/learn_compound_word/learn_compound_word_state.dart
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/data/models/compound_word_model.dart';

class LearnCompoundWordState extends Equatable {
  final List<CompoundWord> compoundWords;
  final CompoundWord? selectedCompoundWord;
  final bool isLoading;
  final String? error;
  final String? message;

  const LearnCompoundWordState({
    this.isLoading = false,
    this.error,
    this.message,
    this.compoundWords = const [],
    this.selectedCompoundWord,
  });

  LearnCompoundWordState copyWith({
    bool? isLoading,
    String? error,
    String? message,
    List<CompoundWord>? compoundWords,
    CompoundWord? selectedCompoundWord,
  }) {
    return LearnCompoundWordState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
      compoundWords: compoundWords ?? this.compoundWords,
      selectedCompoundWord: selectedCompoundWord ?? this.selectedCompoundWord,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        message,
        compoundWords,
        selectedCompoundWord,
      ];
}
