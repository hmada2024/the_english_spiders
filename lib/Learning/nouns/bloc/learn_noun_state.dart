//lib/Learning_section/blocs/learn_noun/learn_noun_state.dart
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/data/models/nouns_model.dart';
import 'package:the_english_spiders/data/models/displayable_item.dart'; 


class LearnNounState extends Equatable {
  final List<Noun> nouns;
  final String selectedCategory;
  final DisplayableItem? selectedNoun;
  final List<String> categories;
  final bool isLoading;
  final String? error;
  final String? message;

  const LearnNounState({
    this.isLoading = false,
    this.error,
    this.message,
    this.nouns = const [],
    this.selectedCategory = 'all',
    this.selectedNoun,
    this.categories = const [],
  });

  LearnNounState copyWith({
    bool? isLoading,
    String? error,
    String? message,
    List<Noun>? nouns,
    String? selectedCategory,
    DisplayableItem? selectedNoun,
    List<String>? categories,
  }) {
    return LearnNounState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
      nouns: nouns ?? this.nouns,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedNoun: selectedNoun ?? this.selectedNoun,
      categories: categories ?? this.categories,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        message,
        nouns,
        selectedCategory,
        selectedNoun,
        categories,
      ];
}
