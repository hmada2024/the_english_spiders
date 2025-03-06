// lib/quizzes/collect_phrasal_verbs/bloc/collect_phrasal_verbs_state.dart
part of 'collect_phrasal_verbs_bloc.dart';

enum CollectPhrasalVerbsStatus {
  initial,
  loading,
  questionReady,
  correct,
  wrong,
  completed,
  error,
}

enum PartStatus {
  neutral,
  selected,
  correct,
  wrong,
}

class ChoosePhrasalVerbPartState extends Equatable {
  final List<PhrasalVerb> phrasalVerbs;
  final PhrasalVerb? currentPhrasalVerb;
  final String displayedPart;
  final List<String> answerOptions;
  final int score;
  final int answeredQuestions;
  final int totalQuestions;
  final String? error;
  final CollectPhrasalVerbsStatus status;
  final bool playAudioAutomatically;
  final bool shouldPlayAudio;
  final String? selectedPart1;
  final Map<String, PartStatus> selectedPartsStatus;
  final bool isAnswered;

  const ChoosePhrasalVerbPartState({
    this.phrasalVerbs = const [],
    this.currentPhrasalVerb,
    this.displayedPart = '',
    this.answerOptions = const [],
    this.score = 0,
    this.answeredQuestions = 0,
    required this.totalQuestions,
    this.error,
    this.status = CollectPhrasalVerbsStatus.initial,
    this.playAudioAutomatically = true,
    this.shouldPlayAudio = true,
    this.selectedPart1,
    this.selectedPartsStatus = const {},
    this.isAnswered = false,
  });

  ChoosePhrasalVerbPartState copyWith({
    List<PhrasalVerb>? phrasalVerbs,
    PhrasalVerb? currentPhrasalVerb,
    String? displayedPart,
    List<String>? answerOptions,
    int? score,
    int? answeredQuestions,
    int? totalQuestions,
    String? error,
    CollectPhrasalVerbsStatus? status,
    bool? playAudioAutomatically,
    bool? shouldPlayAudio,
    String? selectedPart1,
    Map<String, PartStatus>? selectedPartsStatus,
    bool? isAnswered,
  }) {
    return ChoosePhrasalVerbPartState(
      phrasalVerbs: phrasalVerbs ?? this.phrasalVerbs,
      currentPhrasalVerb: currentPhrasalVerb ?? this.currentPhrasalVerb,
      displayedPart: displayedPart ?? this.displayedPart,
      answerOptions: answerOptions ?? this.answerOptions,
      score: score ?? this.score,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      error: error, // Don't use ?? this.error
      status: status ?? this.status,
      playAudioAutomatically:
          playAudioAutomatically ?? this.playAudioAutomatically,
      shouldPlayAudio: shouldPlayAudio ?? this.shouldPlayAudio,
      selectedPart1: selectedPart1,
      selectedPartsStatus: selectedPartsStatus ?? this.selectedPartsStatus,
      isAnswered: isAnswered ?? this.isAnswered,
    );
  }

  @override
  List<Object?> get props => [
        phrasalVerbs,
        currentPhrasalVerb,
        displayedPart,
        answerOptions,
        score,
        answeredQuestions,
        totalQuestions,
        error,
        status,
        playAudioAutomatically,
        shouldPlayAudio,
    selectedPart1,
    selectedPartsStatus,
    isAnswered,
      ];
}