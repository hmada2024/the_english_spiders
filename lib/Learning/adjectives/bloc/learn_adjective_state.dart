//lib/Learning_section/blocs/learn_adjective/learn_adjective_state.dart
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/data/models/adjective_model.dart';

class LearnAdjectiveState extends Equatable {
  final List<Adjective> adjectives; 
  final Adjective? selectedAdjective;
  final bool isLoading; 
  final String? error;
  final String? message; 

  const LearnAdjectiveState({
    this.isLoading = false,
    this.error,
    this.message,
    this.adjectives = const [],
    this.selectedAdjective,
  });

  LearnAdjectiveState copyWith({
    bool? isLoading,
    String? error,
    String? message,
    List<Adjective>? adjectives,
    Adjective? selectedAdjective,
  }) {
    return LearnAdjectiveState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
      adjectives: adjectives ?? this.adjectives,
      selectedAdjective: selectedAdjective ?? this.selectedAdjective,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        message,
        adjectives,
        selectedAdjective,
      ];
}
