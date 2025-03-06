// lib/quizzes/collect_verb_conjugations/bloc/collect_verb_conjugations_event.dart
part of 'collect_verb_conjugations_bloc.dart';

abstract class CollectVerbConjugationsEvent extends Equatable {
  const CollectVerbConjugationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadVerbs extends CollectVerbConjugationsEvent {}

class SelectConjugation extends CollectVerbConjugationsEvent {
  final String selectedConjugation;

  const SelectConjugation({required this.selectedConjugation});

  @override
  List<Object?> get props => [selectedConjugation];
}

class NextVerbQuestion extends CollectVerbConjugationsEvent {}

class PlayVerbAudio extends CollectVerbConjugationsEvent {
  final Uint8List? audioBytes;

  const PlayVerbAudio({this.audioBytes});

  @override
  List<Object?> get props => [audioBytes];
}

class StopVerbAudio extends CollectVerbConjugationsEvent {}

class StartNewVerbQuiz extends CollectVerbConjugationsEvent {}

class SkipQuestion extends CollectVerbConjugationsEvent {}