// lib/quizzes/sentence_quizzes/bloc/arrange_sentence_state.dart
part of 'arrange_sentence_bloc.dart';

enum ArrangeSentenceStatus { initial, loading, questionReady, correct, wrong, completed, error }

class ArrangeSentenceState extends Equatable {
  final ArrangeSentenceStatus status;
  final List<Sentence> sentences; // Renamed from 'data' for clarity
  final Sentence? currentSentence; // Renamed for clarity
  final List<String> shuffledSegments;
  final List<String> userOrder;
  final bool isCorrect;
  final bool isWrong;
  final int score; // Added for consistency
  final int answeredQuestions;
  final bool isInteractionDisabled;
  final int totalQuestions;
  final bool playAudioAutomatically;
  final bool shouldPlayAudio;
  final int currentQuestionIndex;
  final String? error;
  final bool isAnswered;

  const ArrangeSentenceState({
    required this.status,
    this.sentences = const [],
    this.currentSentence,
    this.shuffledSegments = const [],
    this.userOrder = const [],
    this.isCorrect = false,
    this.isWrong = false,
    this.score = 0,
    this.answeredQuestions = 0,
    this.isInteractionDisabled = false,
    this.totalQuestions = 0,
    this.playAudioAutomatically = true,
    this.shouldPlayAudio = true,
    this.currentQuestionIndex = 0,
    this.error,
    this.isAnswered = false,
  });

  factory ArrangeSentenceState.initial() =>
      const ArrangeSentenceState(status: ArrangeSentenceStatus.initial);

  ArrangeSentenceState copyWith({
    ArrangeSentenceStatus? status,
    List<Sentence>? sentences,
    Sentence? currentSentence,
    List<String>? shuffledSegments,
    List<String>? userOrder,
    bool? isCorrect,
    bool? isWrong,
    int? score,
    int? answeredQuestions,
    bool? isInteractionDisabled,
    int? totalQuestions,
    bool? playAudioAutomatically,
    bool? shouldPlayAudio,
    int? currentQuestionIndex,
    String? error,
    bool? isAnswered,
  }) {
    return ArrangeSentenceState(
      status: status ?? this.status,
      sentences: sentences ?? this.sentences,
      currentSentence: currentSentence ?? this.currentSentence,
      shuffledSegments: shuffledSegments ?? this.shuffledSegments,
      userOrder: userOrder ?? this.userOrder,
      isCorrect: isCorrect ?? this.isCorrect,
      isWrong: isWrong ?? this.isWrong,
      score: score ?? this.score,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
      isInteractionDisabled:
          isInteractionDisabled ?? this.isInteractionDisabled,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      playAudioAutomatically:
          playAudioAutomatically ?? this.playAudioAutomatically,
      shouldPlayAudio: shouldPlayAudio ?? this.shouldPlayAudio,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      error: error ?? this.error,
      isAnswered: isAnswered ?? this.isAnswered,
    );
  }

  @override
  List<Object?> get props => [
        status,
        sentences,
        currentSentence,
        shuffledSegments,
        userOrder,
        isCorrect,
        isWrong,
        score,
        answeredQuestions,
        isInteractionDisabled,
        totalQuestions,
        playAudioAutomatically,
        shouldPlayAudio,
        currentQuestionIndex,
        error,
        isAnswered, 
      ];
}