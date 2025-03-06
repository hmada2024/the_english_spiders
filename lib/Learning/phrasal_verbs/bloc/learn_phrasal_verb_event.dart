part of 'learn_phrasal_verb_bloc.dart';

abstract class LearnPhrasalVerbEvent extends Equatable {
  const LearnPhrasalVerbEvent();
  @override
  List<Object?> get props => [];
}

class LoadPhrasalVerbs extends LearnPhrasalVerbEvent {}

class SelectPhrasalVerb extends LearnPhrasalVerbEvent {
  final PhrasalVerb phrasalVerb;
  const SelectPhrasalVerb(this.phrasalVerb);

    @override
  List<Object?> get props => [phrasalVerb]; //  مهم لـ Equatable
}


class PlayPhrasalVerbAudio extends LearnPhrasalVerbEvent {
  final PhrasalVerb phrasalVerb;
  const PlayPhrasalVerbAudio({required this.phrasalVerb});

  @override
  List<Object?> get props => [phrasalVerb];
}