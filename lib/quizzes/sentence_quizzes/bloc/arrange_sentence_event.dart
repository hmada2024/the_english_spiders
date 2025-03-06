// lib/quizzes/sentence_quizzes/bloc/arrange_sentence_event.dart
part of 'arrange_sentence_bloc.dart';

abstract class ArrangeSentenceEvent extends Equatable {
  const ArrangeSentenceEvent();

  @override
  List<Object?> get props => [];
}

class ArrangeSentenceLoadData extends ArrangeSentenceEvent {}

class ArrangeSentenceSelectSegment extends ArrangeSentenceEvent {
  final String segment;
  final bool isRemove;

  const ArrangeSentenceSelectSegment(this.segment, {this.isRemove = false});

  @override
  List<Object> get props => [segment, isRemove];
}

class ArrangeSentenceCheckAnswer extends ArrangeSentenceEvent {}

class ArrangeSentenceShowAnswer extends ArrangeSentenceEvent {}

class ArrangeSentenceNextQuestion extends ArrangeSentenceEvent {}

class ArrangeSentencePreviousQuestion extends ArrangeSentenceEvent {}

class ArrangeSentencePlayAudio extends ArrangeSentenceEvent {
  final Uint8List? audioBytes;

  const ArrangeSentencePlayAudio({this.audioBytes});

  @override
  List<Object?> get props => [audioBytes];
}

class ArrangeSentenceStopOperations extends ArrangeSentenceEvent {}

class ArrangeSentenceStartNewQuiz extends ArrangeSentenceEvent {}

class SkipQuestion extends ArrangeSentenceEvent {}