part of 'learn_phrasal_verb_bloc.dart';

class LearnPhrasalVerbState extends Equatable {
  final List<PhrasalVerb> phrasalVerbs;
  final PhrasalVerb? selectedPhrasalVerb;
  final bool isLoading;
  final String? error;
  final String? message;

  const LearnPhrasalVerbState({
    this.isLoading = false,
    this.error,
    this.message,
    this.phrasalVerbs = const [],
    this.selectedPhrasalVerb,
  });

  LearnPhrasalVerbState copyWith({
    bool? isLoading,
    String? error,
    String? message,
    List<PhrasalVerb>? phrasalVerbs,
    PhrasalVerb? selectedPhrasalVerb,
  }) {
    return LearnPhrasalVerbState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
      phrasalVerbs: phrasalVerbs ?? this.phrasalVerbs,
      selectedPhrasalVerb: selectedPhrasalVerb ?? this.selectedPhrasalVerb,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        message,
        phrasalVerbs,
        selectedPhrasalVerb,
      ];
}