//lib/quizzes/nouns/bloc/choose_image_correct/choose_image_correct_event.dart
import 'package:equatable/equatable.dart';
import 'dart:typed_data';

abstract class ChooseCorrectAnswerEvent extends Equatable {
  const ChooseCorrectAnswerEvent();

  @override
  List<Object?> get props => [];
}

class LoadNouns extends ChooseCorrectAnswerEvent {
  final String category;
  const LoadNouns({required this.category});

  @override
  List<Object?> get props => [category];
}

class CheckAnswer extends ChooseCorrectAnswerEvent {
  final dynamic selectedAnswer;
  const CheckAnswer({required this.selectedAnswer});

  @override
  List<Object?> get props => [selectedAnswer];
}

class NextQuestion extends ChooseCorrectAnswerEvent {}

class ResetQuiz extends ChooseCorrectAnswerEvent {}

class PlayAudio extends ChooseCorrectAnswerEvent {
  final Uint8List? audioBytes;
  const PlayAudio({this.audioBytes});

  @override
  List<Object?> get props => [audioBytes];
}

class StopAudio extends ChooseCorrectAnswerEvent {}

class LoadSettings extends ChooseCorrectAnswerEvent {}

enum QuizType { imageBased, textBased }

class SetQuizType extends ChooseCorrectAnswerEvent {
  final QuizType quizType;
  const SetQuizType({required this.quizType});

  @override
  List<Object> get props => [quizType];
}

class StartNewQuiz extends ChooseCorrectAnswerEvent {
  final String category;

  const StartNewQuiz({required this.category});

  @override
  List<Object?> get props => [category];
}

// إضافة الحدث الجديد
class SkipQuestion extends ChooseCorrectAnswerEvent {}