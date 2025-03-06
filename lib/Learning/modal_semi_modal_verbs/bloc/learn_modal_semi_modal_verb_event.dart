part of 'learn_modal_semi_modal_verb_bloc.dart';

abstract class LearnModalSemiModalVerbEvent extends Equatable {
  const LearnModalSemiModalVerbEvent();
    @override
  List<Object?> get props => [];
}

class LoadModalSemiModalVerbs extends LearnModalSemiModalVerbEvent {}

class SelectModalSemiModalVerb extends LearnModalSemiModalVerbEvent {
  final ModalSemiModalVerb modalSemiModalVerb;
  const SelectModalSemiModalVerb(this.modalSemiModalVerb);
   @override
  List<Object?> get props => [modalSemiModalVerb];
}

class PlayModalSemiModalVerbAudio extends LearnModalSemiModalVerbEvent {
  final ModalSemiModalVerb modalSemiModalVerb;
  const PlayModalSemiModalVerbAudio({required this.modalSemiModalVerb});
    @override
  List<Object?> get props => [modalSemiModalVerb];
}

class PlayModalSemiModalVerbExampleAudio
    extends LearnModalSemiModalVerbEvent {
  final ModalSemiModalVerb modalSemiModalVerb;
  const PlayModalSemiModalVerbExampleAudio({required this.modalSemiModalVerb});
    @override
  List<Object?> get props => [modalSemiModalVerb];
}