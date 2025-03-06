//lib/quizzes/collect_compound_words/bloc/collect_compound_words_state.dart
part of 'collect_compound_words_bloc.dart';

enum CollectCompoundWordsStatus {
  initial,
  loading,
  questionReady,
  correct,
  wrong,
  completed,
  error
}
enum PartStatus {
  neutral,
  selected,
  correct,
  wrong,
}

class ChooseCompoundPartState extends Equatable {
  final List<CompoundWord> compoundWords;
  final CompoundWord? currentWord;
  final String displayedPart; // The part of the word shown to the user
  final List<String> answerOptions;
  final int score;
  final int answeredQuestions;
  final int totalQuestions;
  final String? error;
  final CollectCompoundWordsStatus status;
    final bool playAudioAutomatically;
  final bool shouldPlayAudio;
  final String? selectedPart1; // NEW: To store the first selected part.
   final Map<String, PartStatus> selectedPartsStatus; // NEW
  final bool isAnswered; // <-- الخاصية الجديدة

  const ChooseCompoundPartState({
    this.compoundWords = const [],
    this.currentWord,
    this.displayedPart = '',
    this.answerOptions = const [],
    this.score = 0,
    this.answeredQuestions = 0,
    required this.totalQuestions,
    this.error,
    this.status = CollectCompoundWordsStatus.initial,
    this.playAudioAutomatically = true,
    this.shouldPlayAudio = true,
    this.selectedPart1, // Initialize as null.
    this.selectedPartsStatus = const {}, // NEW
    this.isAnswered = false, // <-- القيمة الافتراضية
  });

  ChooseCompoundPartState copyWith({
    List<CompoundWord>? compoundWords,
    CompoundWord? currentWord,
    String? displayedPart,
    List<String>? answerOptions,
    int? score,
    int? answeredQuestions,
    int? totalQuestions,
    String? error,
    CollectCompoundWordsStatus? status,
        bool? playAudioAutomatically,
    bool? shouldPlayAudio,
    String? selectedPart1,
    Map<String, PartStatus>? selectedPartsStatus,
    bool? isAnswered, // <-- إضافة الخاصية
  }) {
    return ChooseCompoundPartState(
      compoundWords: compoundWords ?? this.compoundWords,
      currentWord: currentWord ?? this.currentWord,
      displayedPart: displayedPart ?? this.displayedPart,
      answerOptions: answerOptions ?? this.answerOptions,
      score: score ?? this.score,
      answeredQuestions: answeredQuestions ?? this.answeredQuestions,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      error: error, // Don't use ?? this.error
      status: status ?? this.status,
      playAudioAutomatically:
          playAudioAutomatically ?? this.playAudioAutomatically,
      shouldPlayAudio: shouldPlayAudio ?? this.shouldPlayAudio,
      selectedPart1:  selectedPart1,
      selectedPartsStatus: selectedPartsStatus ?? this.selectedPartsStatus, // NEW
      isAnswered: isAnswered ?? this.isAnswered, // <-- إضافة الخاصية
    );
  }

  @override
  List<Object?> get props => [
        compoundWords,
        currentWord,
        displayedPart,
        answerOptions,
        score,
        answeredQuestions,
        totalQuestions,
        error,
        status,
        playAudioAutomatically,
        shouldPlayAudio,
        selectedPart1,
        selectedPartsStatus,
        isAnswered,
      ];
}