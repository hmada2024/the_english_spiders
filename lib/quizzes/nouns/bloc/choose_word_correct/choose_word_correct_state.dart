//lib/quizzes/nouns/bloc/choose_word_correct/choose_word_correct_state.dart
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/data/models/nouns_model.dart';

enum ChooseWordCorrectStatus {
  initial,
  loading,
  questionReady,
  correct,
  wrong,
  completed,
  error
}

class ChooseWordCorrectState extends Equatable {
  final List<Noun> nouns;
  final Noun? currentNoun;
  final List<String> answerOptions;
  final int score;
  final int answeredQuestions;
  final int totalQuestions;
  final bool isInteractionDisabled;
  final String? error;
  final ChooseWordCorrectStatus status;
  final bool isAnswered;

  const ChooseWordCorrectState({
    this.nouns = const [],
    this.currentNoun,
    this.answerOptions = const [],
    this.score = 0,
    this.answeredQuestions = 0,
    required this.totalQuestions,
    this.isInteractionDisabled = false,
    this.error,
    this.status = ChooseWordCorrectStatus.initial,
    this.isAnswered = false,
  });

  ChooseWordCorrectState copyWith({
    List<Noun>? nouns,
    Noun? currentNoun,
    List<String>? answerOptions,
    int? score,
    int? answeredQuestions,
    int? totalQuestions,
    bool? isInteractionDisabled,
    String? error,
    ChooseWordCorrectStatus? status,
    bool? isAnswered,
  }) {
    return ChooseWordCorrectState(
      nouns: nouns ?? this.nouns,
      currentNoun: currentNoun ?? this.currentNoun,
      answerOptions: answerOptions ?? this.answerOptions,
      score: score ?? this.score,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      isInteractionDisabled: isInteractionDisabled ?? this.isInteractionDisabled,
      error: error,
      status: status ?? this.status,
      isAnswered: isAnswered ?? this.isAnswered,
    );
  }

  @override
  List<Object?> get props => [
        nouns,
        currentNoun,
        answerOptions,
        score,
        answeredQuestions,
        totalQuestions,
        isInteractionDisabled,
        error,
        status,
        isAnswered,
      ];
}