// lib/quizzes/collect_phrasal_verbs/bloc/collect_phrasal_verbs_event.dart
part of 'collect_phrasal_verbs_bloc.dart';

abstract class CollectPhrasalVerbsEvent extends Equatable {
  const CollectPhrasalVerbsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPhrasalVerbs extends CollectPhrasalVerbsEvent {}

class SelectPhrasalVerbPart extends CollectPhrasalVerbsEvent {
  final String selectedPart;
  const SelectPhrasalVerbPart({required this.selectedPart});

  @override
  List<Object?> get props => [selectedPart];
}

class NextPhrasalVerbQuestion extends CollectPhrasalVerbsEvent {}

class PlayPhrasalVerbAudio extends CollectPhrasalVerbsEvent {
  final Uint8List? audioBytes;
  const PlayPhrasalVerbAudio({this.audioBytes});
  @override
  List<Object?> get props => [audioBytes];
}

class StopPhrasalVerbAudio extends CollectPhrasalVerbsEvent {}

class StartNewPhrasalVerbQuiz extends CollectPhrasalVerbsEvent {}

class SkipQuestion extends CollectPhrasalVerbsEvent {}