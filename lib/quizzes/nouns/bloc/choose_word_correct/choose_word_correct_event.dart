//lib/quizzes/nouns/bloc/choose_word_correct/choose_word_correct_event.dart
import 'package:equatable/equatable.dart';
import 'dart:typed_data';

abstract class ChooseWordCorrectEvent extends Equatable {
  const ChooseWordCorrectEvent();

  @override
  List<Object?> get props => [];
}

class LoadNouns extends ChooseWordCorrectEvent {
  final String category;
  const LoadNouns({required this.category});

  @override
  List<Object?> get props => [category];
}

class CheckAnswer extends ChooseWordCorrectEvent {
  final String selectedAnswer; // Changed to String
  const CheckAnswer({required this.selectedAnswer});

  @override
  List<Object?> get props => [selectedAnswer];
}

class NextQuestion extends ChooseWordCorrectEvent {}

class ResetQuiz extends ChooseWordCorrectEvent {}

class PlayAudio extends ChooseWordCorrectEvent {
  final Uint8List? audioBytes;
  const PlayAudio({this.audioBytes});

  @override
  List<Object?> get props => [audioBytes];
}

class StopAudio extends ChooseWordCorrectEvent {}

class StartNewQuiz extends ChooseWordCorrectEvent {
    final String category;

    const StartNewQuiz({required this.category});

    @override
    List<Object?> get props => [category];
}

class SkipQuestion extends ChooseWordCorrectEvent {}