// lib/quizzes/collect_verb_conjugations/bloc/collect_verb_conjugations_state.dart
part of 'collect_verb_conjugations_bloc.dart';

enum CollectVerbConjugationsStatus {
  initial,
  loading,
  questionReady,
  correct,
  wrong,
  completed,
  error
}

enum ConjugationStatus {
  neutral,
  selected,
  correct,
  wrong,
}

class CollectVerbConjugationsState extends Equatable {
  final List<Verb> verbs;
  final Verb? currentVerb;
  final List<String> answerOptions;
  final int score;
  final int answeredQuestions;
  final int totalQuestions;
  final String? error;
  final CollectVerbConjugationsStatus status;
  final bool playAudioAutomatically;
  final bool shouldPlayAudio;
  final List<String> selectedConjugations; // List of selected conjugations
  final Map<String, ConjugationStatus> selectedConjugationsStatus;
  final bool isAnswered; // <-- الخاصية الجديدة

  const CollectVerbConjugationsState({
    this.verbs = const [],
    this.currentVerb,
    this.answerOptions = const [],
    this.score = 0,
    this.answeredQuestions = 0,
    required this.totalQuestions,
    this.error,
    this.status = CollectVerbConjugationsStatus.initial,
    this.playAudioAutomatically = true,
    this.shouldPlayAudio = true,
    this.selectedConjugations = const [], // Initialize as empty list
    this.selectedConjugationsStatus = const {},
    this.isAnswered = false, // <-- القيمة الافتراضية
  });

  CollectVerbConjugationsState copyWith({
    List<Verb>? verbs,
    Verb? currentVerb,
    List<String>? answerOptions,
    int? score,
    int? answeredQuestions,
    int? totalQuestions,
    String? error,
    CollectVerbConjugationsStatus? status,
    bool? playAudioAutomatically,
    bool? shouldPlayAudio,
    List<String>? selectedConjugations,
    Map<String, ConjugationStatus>? selectedConjugationsStatus,
    bool? isAnswered, // <-- إضافة الخاصية
  }) {
    return CollectVerbConjugationsState(
      verbs: verbs ?? this.verbs,
      currentVerb: currentVerb ?? this.currentVerb,
      answerOptions: answerOptions ?? this.answerOptions,
      score: score ?? this.score,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      error: error, // Don't use ?? this.error
      status: status ?? this.status,
      playAudioAutomatically:
          playAudioAutomatically ?? this.playAudioAutomatically,
      shouldPlayAudio: shouldPlayAudio ?? this.shouldPlayAudio,
      selectedConjugations:
          selectedConjugations ?? this.selectedConjugations, //
      selectedConjugationsStatus:
          selectedConjugationsStatus ?? this.selectedConjugationsStatus,
      isAnswered: isAnswered ?? this.isAnswered, // <-- إضافة الخاصية
    );
  }

  @override
  List<Object?> get props => [
        verbs,
        currentVerb,
        answerOptions,
        score,
        answeredQuestions,
        totalQuestions,
        error,
        status,
        playAudioAutomatically,
        shouldPlayAudio,
        selectedConjugations,
        selectedConjugationsStatus,
        isAnswered,
      ];
}