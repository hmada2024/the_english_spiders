//lib/quizzes/collect_compound_words/bloc/collect_compound_words_bloc.dart
import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/data/models/compound_word_model.dart';
import 'package:the_english_spiders/data/repositories/compound_word_repository.dart';

part 'collect_compound_words_event.dart';
part 'collect_compound_words_state.dart';

class CollectCompoundWordsBloc
    extends Bloc<CollectCompoundWordsEvent, ChooseCompoundPartState> {
  final CompoundWordRepository _repository;
  final AudioService _audioService;
  final _random = Random();
  List<CompoundWord> _initialData = [];
  final Set<int> _answeredQuestions = {};
  Timer? _interactionTimer;

  CollectCompoundWordsBloc(this._repository, this._audioService)
      : super(const ChooseCompoundPartState(totalQuestions: 0)) {
    on<LoadCompoundWords>(_onLoadCompoundWords);
    on<SelectCompoundPart>(_onSelectCompoundPart);
    on<NextCompoundQuestion>(_onNextCompoundQuestion);
    on<PlayCompoundAudio>(_onPlayCompoundAudio);
    on<StopCompoundAudio>(_onStopCompoundAudio);
    on<StartNewCompoundQuiz>(_onStartNewQuiz);
    on<SkipQuestion>(_onSkipQuestion); // إضافة معالج حدث التخطي
  }

    Future<void> _onStartNewQuiz(
      StartNewCompoundQuiz event, Emitter<ChooseCompoundPartState> emit) async {
     _resetQuizState();
    add(LoadCompoundWords());
  }

  Future<void> _onLoadCompoundWords(
      LoadCompoundWords event, Emitter<ChooseCompoundPartState> emit) async {
    if (state.status == CollectCompoundWordsStatus.loading) return;

    emit(state.copyWith(
      status: CollectCompoundWordsStatus.loading,
      error: null,
      score: 0,
      answeredQuestions: 0,
    ));

    try {
      List<CompoundWord> words = await _repository.getAll();
      _initialData = List.from(words);
      _initialData.shuffle(_random);

      emit(state.copyWith(
        compoundWords: words,
        totalQuestions: words.length,
        status: CollectCompoundWordsStatus.questionReady,
      ));
      if (words.isNotEmpty) {
        add(NextCompoundQuestion());
      } else {
        emit(state.copyWith(
            currentWord: null,
            displayedPart: '',
            answerOptions: [],
            status: CollectCompoundWordsStatus.error,
            error: 'No compound words found.'));
      }
    } catch (e) {
      emit(state.copyWith(
        status: CollectCompoundWordsStatus.error,
        error: 'Failed to load compound words: $e',
      ));
    }
  }

  Future<void> _onSelectCompoundPart(
    SelectCompoundPart event, Emitter<ChooseCompoundPartState> emit) async {
  if (state.status == CollectCompoundWordsStatus.correct ||
      state.status == CollectCompoundWordsStatus.wrong) {
    return;
  }
  _interactionTimer?.cancel();

  String? part1 = state.selectedPart1;
  String? part2 = event.selectedPart;
  Map<String, PartStatus> newStatus = Map.from(state.selectedPartsStatus); // Copy

  if (part1 == null) {
    // First part selected.
    newStatus[part2] = PartStatus.selected;
    emit(state.copyWith(selectedPart1: part2, selectedPartsStatus: newStatus));
    return;
  }

    bool isCorrect = _checkAnswer(part1, part2);
    newStatus[part1] = isCorrect ? PartStatus.correct : PartStatus.wrong;
    newStatus[part2] = isCorrect ? PartStatus.correct : PartStatus.wrong;


  String soundToPlay = isCorrect
      ? AppConstants.correctAnswerSound
      : AppConstants.wrongAnswerSound;
  try {
    await _audioService.start(await _getAssetData(soundToPlay));
  } catch (e) {
    debugPrint("Error playing sound: $e");
  }
  _answeredQuestions.add(state.currentWord!.id);

   emit(state.copyWith(
    status: isCorrect ? CollectCompoundWordsStatus.correct : CollectCompoundWordsStatus.wrong,
    score: isCorrect ? state.score + 1 : state.score,
    answeredQuestions: state.answeredQuestions + 1,
    selectedPartsStatus: newStatus, // Update with correct/wrong
    isAnswered: true, // <-- تم التعديل هنا
    // Don't reset selectedPart1 here!
  ));

    final completer = Completer<void>();
    _interactionTimer = Timer(const Duration(milliseconds: 1500), () {
        if (!emit.isDone) { // Check if the Bloc is still active.
          add(NextCompoundQuestion());
        }
        completer.complete();
    });
     await completer.future;
}

bool _checkAnswer(String part1, String part2) {
    CompoundWord word = state.currentWord!;
    return (word.part1 == part1 && word.part2 == part2) ||
           (word.part1 == part2 && word.part2 == part1);
}



 void _onNextCompoundQuestion(
      NextCompoundQuestion event, Emitter<ChooseCompoundPartState> emit) {
    _interactionTimer?.cancel();
    CompoundWord? nextWord;

    for (final word in _initialData) {
      if (!_answeredQuestions.contains(word.id)) {
        nextWord = word;
        break;
      }
    }

    if (nextWord != null) {
      emit(state.copyWith(
        currentWord: nextWord,
        displayedPart: "",
        answerOptions: _generateAnswerOptions(nextWord),
        status: CollectCompoundWordsStatus.questionReady,
        selectedPart1: null,
        selectedPartsStatus: {}, // Reset status for new question.
        isAnswered: false,
      ));

      if (state.playAudioAutomatically && state.shouldPlayAudio) {
        add(PlayCompoundAudio(audioBytes: nextWord.mainAudio));
      }
    } else {
       if (state.answeredQuestions == state.totalQuestions){
          emit(state.copyWith(
            status: CollectCompoundWordsStatus.completed,
            currentWord: null,
            displayedPart: '',
            answerOptions: [],
        ));
        }else
        {
          emit(state.copyWith(
          currentWord: null,
          displayedPart: '',
          answerOptions: [],
        ));
        }
    }
  }

 List<String> _generateAnswerOptions(CompoundWord correctWord) {
    Set<String> optionsSet = {correctWord.part1, correctWord.part2};
    List<CompoundWord> otherWords = _initialData.where((w) => w.id != correctWord.id).toList();
    otherWords.shuffle(_random);

    int count = 0;
    while (optionsSet.length < 8 && count < otherWords.length) {
      optionsSet.add(otherWords[count].part1);
      optionsSet.add(otherWords[count].part2);
      count++;
    }

    // Ensure we have exactly 8 options, filling with duplicates if necessary
    while (optionsSet.length < 8) {
        int index = _random.nextInt(optionsSet.length);
        optionsSet.add(optionsSet.elementAt(index));
    }

    List<String> options = optionsSet.toList()..shuffle(_random);

    return options;
  }


  Future<void> _onPlayCompoundAudio(
      PlayCompoundAudio event, Emitter<ChooseCompoundPartState> emit) async {
    if (event.audioBytes != null) {
      await _audioService.start(event.audioBytes!);
    }
  }
  Future<void> _onStopCompoundAudio(
      StopCompoundAudio event, Emitter<ChooseCompoundPartState> emit) async {
        await _audioService.stop();
  }

   void _resetQuizState() {
        _initialData.shuffle(_random);
        _answeredQuestions.clear();
    }

  // دالة معالج حدث التخطي
    Future<void> _onSkipQuestion(
      SkipQuestion event, Emitter<ChooseCompoundPartState> emit) async {
    // أوقف أي صوت قد يكون قيد التشغيل
    _audioService.stop();

    // ألغِ أي مؤقت موجود
    _interactionTimer?.cancel();

      // أضف السؤال الحالي إلى قائمة الأسئلة التي تمت الإجابة عليها (حتى لا يظهر مرة أخرى)
    if (state.currentWord != null) {
      _answeredQuestions.add(state.currentWord!.id);
    }

    // انتقل إلى السؤال التالي (بنفس منطق _onNextQuestion)
    add(NextCompoundQuestion());
  }

  @override
  Future<void> close() {
    _interactionTimer?.cancel();
    return super.close();
  }

  Future<Uint8List> _getAssetData(String assetPath) async {
    final byteData = await GetIt.instance<AssetBundle>().load(assetPath);
    return byteData.buffer.asUint8List();
  }
}