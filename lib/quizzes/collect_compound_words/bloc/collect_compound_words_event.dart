//lib/quizzes/collect_compound_words/bloc/collect_compound_words_event.dart
part of 'collect_compound_words_bloc.dart';

abstract class CollectCompoundWordsEvent extends Equatable {
  const CollectCompoundWordsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCompoundWords extends CollectCompoundWordsEvent {}

class SelectCompoundPart extends CollectCompoundWordsEvent {
  final String selectedPart;
  const SelectCompoundPart({required this.selectedPart});

  @override
  List<Object?> get props => [selectedPart];
}

class NextCompoundQuestion extends CollectCompoundWordsEvent {}

class PlayCompoundAudio extends CollectCompoundWordsEvent {
  final Uint8List? audioBytes;
  const PlayCompoundAudio({this.audioBytes});
  @override
  List<Object?> get props => [audioBytes];
}
class StopCompoundAudio extends CollectCompoundWordsEvent {}

class StartNewCompoundQuiz extends CollectCompoundWordsEvent {}

class SkipQuestion extends CollectCompoundWordsEvent {}