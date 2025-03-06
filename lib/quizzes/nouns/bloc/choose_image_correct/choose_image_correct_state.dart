//lib/quizzes/nouns/bloc/choose_image_correct/choose_image_correct_state.dart
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/data/models/nouns_model.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_image_correct/choose_image_correct_event.dart';

enum ChooseCorrectAnswerStatus {
  initial,
  loading,
  questionReady,
  correct,
  wrong,
  completed,
  error,
}

class ChooseCorrectAnswerState extends Equatable {
  final List<Noun> nouns;
  final Noun? currentNoun;
  final List<dynamic> answerOptions;
  final int score;
  final int answeredQuestions;
  final int totalQuestions;
  final bool playAudioAutomatically;
  final bool shouldPlayAudio;
  final String? error;
  final QuizType quizType;
  final ChooseCorrectAnswerStatus status;
  final bool isAnswered; //  <--  الخاصية الجديدة

  const ChooseCorrectAnswerState({
    this.nouns = const [],
    this.currentNoun,
    this.answerOptions = const [],
    this.score = 0,
    this.answeredQuestions = 0,
    required this.totalQuestions,
    required this.playAudioAutomatically,
    this.shouldPlayAudio = true,
    this.error,
    this.quizType = QuizType.imageBased,
    this.status = ChooseCorrectAnswerStatus.initial,
    this.isAnswered = false, // <-- القيمة الافتراضية
  });

  ChooseCorrectAnswerState copyWith({
    List<Noun>? nouns,
    Noun? currentNoun,
    List<dynamic>? answerOptions,
    int? score,
    int? answeredQuestions,
    int? totalQuestions,
    bool? playAudioAutomatically,
    bool? shouldPlayAudio,
    String? error,
    QuizType? quizType,
    ChooseCorrectAnswerStatus? status,
    bool? isAnswered, // <-- إضافة الخاصية إلى copyWith
  }) {
    return ChooseCorrectAnswerState(
      nouns: nouns ?? this.nouns,
      currentNoun: currentNoun ?? this.currentNoun,
      answerOptions: answerOptions ?? this.answerOptions,
      score: score ?? this.score,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      playAudioAutomatically:
          playAudioAutomatically ?? this.playAudioAutomatically,
      shouldPlayAudio: shouldPlayAudio ?? this.shouldPlayAudio,
      error: error,
      quizType: quizType ?? this.quizType,
      status: status ?? this.status,
      isAnswered: isAnswered ?? this.isAnswered, // <-- إضافة الخاصية
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
        playAudioAutomatically,
        shouldPlayAudio,
        error,
        quizType,
        status,
        isAnswered, 
      ];
}