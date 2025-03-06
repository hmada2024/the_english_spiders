//lib/Learning_section/blocs/learn_verb_conjugation/learn_verb_conjugations_state.dart
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/data/models/verb_conjugations_models.dart';

class LearnVerbConjugationsState extends Equatable {
final List<Verb> verbs;
final List<Conjugations>? conjugations;
final bool isLoading;
final String? error;
final String? message;
final String? selectedVerbType;

const LearnVerbConjugationsState({
this.verbs = const [],
this.conjugations,
this.isLoading = false,
this.error,
this.message,
this.selectedVerbType,
});

LearnVerbConjugationsState copyWith({
List<Verb>? verbs,
List<Conjugations>? conjugations,
bool? isLoading,
String? error,
String? message,
String? selectedVerbType,
}) {
return LearnVerbConjugationsState(
  verbs: verbs ?? this.verbs,
  conjugations:  const [],
  isLoading: isLoading ?? this.isLoading,
  error: error ?? this.error,
  message: message ?? this.message,
  selectedVerbType: selectedVerbType ?? this.selectedVerbType,
);
}

@override
List<Object?> get props => [verbs, conjugations, isLoading, error, message, selectedVerbType];
}